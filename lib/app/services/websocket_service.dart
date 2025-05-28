import 'dart:convert';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:gotale/app/controllers/lobby_controller.dart';
import 'package:logger/logger.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'dart:async';

class SocketService with WidgetsBindingObserver {
  Timer? _positionTimer;
  late StompClient _client;
  late String _sessionId = "bad";
  bool _isConnected = false;
  bool get isConnected => _isConnected;
  bool gameStarted = false;

  bool _wasConnectedBeforeBackground = false;
  String? _currentLobbyId;
  bool _isReconnecting = false;
  bool _isInitialConnection = true;

  late Function(String) onErrorGlobal;
  late Function(String) onLogGlobal;
  late Function(List<dynamic> users) onUsersReceived;
  bool _receivedSessionId = false;
  late String token;
  bool shouldReconnect = true;
  final logger = Get.find<Logger>();

  SocketService() {
    // Rejestrujemy observer do śledzenia cyklu życia aplikacji
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        logger.d("📱 Aplikacja przeszła w tło");
        _wasConnectedBeforeBackground = _isConnected;
        break;

      case AppLifecycleState.resumed:
        logger.d("📱 Aplikacja wróciła na pierwszy plan");
        if (_wasConnectedBeforeBackground &&
            !_isConnected &&
            _currentLobbyId != null) {
          logger.d("🔄 Wykryto potrzebę reconnect po powrocie z tła");
          _handleAppResumeReconnect();
        }
        break;

      case AppLifecycleState.inactive:
        // Stan przejściowy, nie robimy nic
        break;

      case AppLifecycleState.hidden:
        // Nowy stan w nowszych wersjach Fluttera
        break;
    }
  }

  void _handleAppResumeReconnect() {
    if (_isReconnecting || _currentLobbyId == null) return;

    _isReconnecting = true;
    onLogGlobal("🔄 Wznawianie połączenia po powrocie aplikacji...");

    // Czekamy chwilę na ustabilizowanie się aplikacji
    Future.delayed(Duration(milliseconds: 2000), () {
      if (!_isConnected && shouldReconnect) {
        onLogGlobal(
            "🔄 MANUAL Reconnect: STOMP nie połączył się automatycznie");
        reconnect(_currentLobbyId!);
      } else if (_isConnected) {
        onLogGlobal("✅ STOMP już się połączył automatycznie");
        _handlePostReconnectActions(_currentLobbyId!);
      }
      _isReconnecting = false;
    });
  }

  void _handlePostReconnectActions(String lobbyId) {
    logger.d("🔄 Wykonywanie akcji po reconnect...");
    _receivedSessionId = false;

    // Opóźnienie żeby dać czas na pełne połączenie
    Future.delayed(Duration(milliseconds: 1500), () {
      if (_isConnected) {
        //sendJoinMessage(lobbyId);
        _subscribeToUserList(lobbyId);

        //requestUserList(lobbyId);
        onLogGlobal("✅ Wykonano akcje po reconnect");
      }
    });
  }

  void connect({
    required String jwtToken,
    required String lobbyId,
    required Function(String message) onLog,
    required Function(String error) onError,
    required Function(List<dynamic> users) onUsersReceived,
    required VoidCallback onConnected,
  }) {
    _currentLobbyId = lobbyId;
    _client = StompClient(
      config: StompConfig(
        //url: "ws://10.0.2.2:8080/websocket/websocket", // na localu na emulatorze
        //url: "ws://localhost:8080/websocket/websocket", // na localu
        //url: 'ws://squid-app-p63zw.ondigitalocean.app:8080/websocket/websocket', // na http
        url: 'wss://api.gotale.pl:443/websocket/websocket', // na https
        useSockJS: false, //
        reconnectDelay: Duration(seconds: 2),
        heartbeatIncoming: Duration(seconds: 10),
        heartbeatOutgoing: Duration(seconds: 10),
        stompConnectHeaders: {
          'session-id': _sessionId,
          'Authorization': 'Bearer $jwtToken',
          'lobby-id': lobbyId,
        },
        webSocketConnectHeaders: {
          'Authorization': 'Bearer $jwtToken',
          'session-id': _sessionId,
        },
        onConnect: (StompFrame frame) {
          _startSendingPositionLoop(lobbyId);
          _isConnected = true;
          this.onUsersReceived = onUsersReceived;

          token = jwtToken;

          onErrorGlobal = onError;
          onLogGlobal = onLog;

          logger.d("✅ Połączono, sessionId: $_sessionId");

          if (_isInitialConnection) {
            logger.d(
                "✅ INITIAL Connect: Pierwsze połączenie, sessionId: $_sessionId");
            _isInitialConnection = false;
          } else {
            logger.d(
                "✅ AUTO Reconnect (STOMP): Automatyczne połączenie po rozłączeniu, sessionId: $_sessionId");
            // To jest auto-reconnect od STOMP, więc musimy wykonać akcje jak po reconnect
            _handlePostReconnectActions(lobbyId);
          }

          _subscribeToLobby(lobbyId, onLog);

          onConnected();
        },
        onWebSocketError: (err) {
          logger.e("❌ WebSocket error: $err");
          if (shouldReconnect && _currentLobbyId != null) {
            Future.delayed(Duration(seconds: 2), () {
              if (!_isConnected) {
                reconnect(_currentLobbyId!);
              }
            });
          }
        },
        onStompError: (frame) => logger.e("❌ STOMP error: ${frame.body}"),
        onDisconnect: (_) {
          _isConnected = false;
          _stopPositionTimer();
          onLog("🔌 Rozłączono");

          // Sprawdzamy czy to nie jest planowane rozłączenie
          if (shouldReconnect && _currentLobbyId != null) {
            // Opóźniamy reconnect żeby uniknąć zbyt częstych prób
            Future.delayed(Duration(seconds: 3), () {
              if (!_isConnected && shouldReconnect && _currentLobbyId != null) {
                logger.d("🔄 Auto-reconnect po rozłączeniu");
                reconnect(_currentLobbyId!);
              }
            });
          }
        },
      ),
    );

    _client.activate();
  }

  void _subscribeToLobby(String lobbyId, Function(String message) onLog) {
    _client.subscribe(
      destination: '/topic/lobby.$lobbyId',
      headers: {'lobby-id': lobbyId},
      callback: (StompFrame frame) {
        var body = frame.body ?? "";
        logger.d("📥 Otrzymano: ${frame.body}");

        try {
          final data = jsonDecode(body);

          if (data is Map<String, dynamic>) {
            // Obsługa sessionId (raz)
            if (!_receivedSessionId && data.containsKey('sessionId')) {
              _sessionId = data['sessionId'];
              _receivedSessionId = true;
              onLog("📌 Otrzymano sessionId: $_sessionId");

              _subscribeToErrors(onErrorGlobal!, onLogGlobal!);
              _subscribeToUserList(lobbyId);
              return;
            }

            final contentRaw = data['content'];
            if (contentRaw is String) {
              final content = jsonDecode(contentRaw);
              final type = content['type'];
              switch (type) {
                case 'start-game':
                  final LobbyController controller =
                      Get.find<LobbyController>();
                  controller.setGameId = content['gameId'];
                  controller.joinGame();
                  break;
                case 'delete':
                  logger.d("deleted user id:");
                  logger.d(content['deleted-user']);
                  int deletedUserId = content['deleted-user'];
                  final lobbyController = Get.find<LobbyController>();
                  final context = Get.context;
                  if (context != null) {
                    lobbyController.reactToBeingDeleted(deletedUserId);
                  }
                  break;
                default:
                  logger.d("❓ Nieznany typ wiadomości: $type");
              }
            }
          } else {
            logger.e("💢 Nie zawiera sessionId!");
          }
        } catch (e) {
          logger.e("💥 Error parsowania JSONa: $e");
        }
      },
    );

    sendMessage(lobbyId, "init-session");
    sendPosition(lobbyId);
  }

  void _subscribeToUserList(String lobbyId) {
    print("subscrining rn adjfflhgsngjg");
    _client.subscribe(
      destination: '/topic/lobby/users/$lobbyId',
      headers: {'lobby-id': lobbyId},
      callback: (StompFrame frame) {
        try {
          final body = frame.body ?? '';
          if (body.trim().startsWith('[')) {
            // Zakładamy, że to JSON lista
            final List<dynamic> users = jsonDecode(body);
            onUsersReceived(users);
            logger.d(users);
            onLogGlobal("📥 Odebrano listę użytkowników.");
          } else {
            logger.d("ℹ️ Odebrano wiadomość tekstową: $body");

            if (body.contains("Lobby created with status: gaming")) {
              onLogGlobal("📥 Dołączanie do gry hosta");
            }
          }
        } catch (e) {
          logger.e("💥 Błąd parsowania listy użytkowników: $e");
        }
      },
    );
  }

  void _subscribeToErrors(
      void Function(String) onError, void Function(String) onLog) {
    if (_sessionId == null) return;

    _client?.subscribe(
      destination: "/queue/errors/$_sessionId",
      callback: (frame) {
        try {
          final Map<String, dynamic> error = frame.body != null
              ? Map<String, dynamic>.from(jsonDecode(frame.body!))
              : {};
          final type = error['type'];

          switch (type) {
            case "LOBBY_NOT_FOUND":
              logger.e("Lobby nie istnieje.");
              disconnect(() => onLog("Rozłączono - brak lobby"));
              break;
            case "LOBBY_FULL":
              logger.e("Lobby pełne.");
              disconnect(() => onLog("Rozłączono - pełne lobby"));
              break;
            case "AUTH_ERROR":
              logger.e("JWT error: ${error['message']}");
              disconnect(() => onLog("JWT problem"));
              break;
            case "DUPLICATE_SESSION":
              logger.e("Zduplikowana sesja.");
              disconnect(() => onLog("Starsze połączenie zamknięte"));
              break;
            case "NO_LOBBY":
              logger.e("Nie podano ID lobby.");
              break;
            default:
              logger.e("Nieznany błąd: ${error['message'] ?? "brak info"}");
          }
        } catch (e) {
          logger.e("Błąd (nie JSON): ${frame.body}");
        }
      },
    );
  }

  void sendMessage(String lobbyId, String message) {
    if (_isConnected && _client.connected) {
      _client.send(
        destination: '/app/lobby/send/$lobbyId',
        body: message,
        headers: {
          'session-id': _sessionId,
          'lobby-id': lobbyId,
        },
      );
    }
  }

  void sendJoinMessage(String lobbyId) {
    if (!_isConnected || !_client.connected) {
      logger.e("❌ Brak połączenia. Nie można dołączyć.");
      return;
    }

    _client.send(
      destination: '/app/lobby/join',
      headers: {
        'Authorization': 'Bearer $token',
        'session-id': _sessionId,
      },
      body: jsonEncode({'lobbyId': lobbyId}),
    );
    logger.d("📨 Wysłano prośbę o dołączenie do lobby.");
  }

  void requestUserList(String lobbyId) {
    if (!_isConnected || !_client.connected) {
      logger.e("❌ Brak połączenia. Nie można pobrać użytkowników.");
      return;
    }

    _client.send(
      destination: '/app/lobby/users/$lobbyId',
      headers: {
        'Authorization': 'Bearer $token',
        'session-id': _sessionId,
        'lobby-id': lobbyId,
      },
      body: '',
    );
    onLogGlobal("📨 Wysłano żądanie o listę użytkowników.");
  }

  void disconnect(void Function() onDisconnected) {
    shouldReconnect = false;
    if (_isConnected) {
      _isConnected = false;
      _stopPositionTimer();
      _client.deactivate();
      _receivedSessionId = false;
      _sessionId = "bad";
      gameStarted = false;
      onDisconnected();
    }
  }

  bool _locationCheckInProgress = false;

  Future<void> sendPosition(String lobbyId) async {
    if (_locationCheckInProgress) return;
    _locationCheckInProgress = true;

    try {
      if (!_isConnected || !_client.connected) {
        logger.e("❌ Brak połączenia. Nie można wysłać pozycji.");
        if (shouldReconnect) {
          reconnect(lobbyId);
        }
        return;
      }

      // Sprawdzenie uprawnień
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          logger.e("❌ Odmówiono uprawnień do lokalizacji.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        logger.e("❌ Uprawnienia do lokalizacji na stałe zablokowane.");
        return;
      }

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        logger.e("📵 Lokalizacja jest wyłączona w ustawieniach systemowych.");
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      if (_isConnected && _client.connected) {
        _client.send(
          destination: '/app/lobby/location',
          headers: {
            'Authorization': 'Bearer $token',
            'session-id': _sessionId,
            'lobby-id': lobbyId,
          },
          body: jsonEncode({
            'lobbyId': lobbyId,
            'lat': position.latitude,
            'lon': position.longitude,
          }),
        );
        onLogGlobal("📨 Wysłano obecną pozycję.");
      }
    } catch (e) {
      logger.e("💥 Błąd pobierania lokalizacji: $e");
    } finally {
      _locationCheckInProgress = false;
    }
  }

  void reconnect(String lobbyId) {
    if (_isConnected) return;

    _isReconnecting = true;
    _receivedSessionId = false;
    _stopPositionTimer();

    onLogGlobal("🔁 Próba ponownego połączenia...");
    _sessionId = "bad";
    connect(
      jwtToken: token,
      lobbyId: lobbyId,
      onLog: onLogGlobal,
      onError: onErrorGlobal,
      onUsersReceived: onUsersReceived,
      onConnected: () {
        onLogGlobal("✅ Połączono ponownie.");
        _isReconnecting = false;
        Future.delayed(Duration(milliseconds: 1000), () {
          sendJoinMessage(lobbyId);
        });
        logger.d("Reconnect: resubscribing to user list");
        _subscribeToUserList(lobbyId);
      },
    );
  }

  void _startSendingPositionLoop(String lobbyId) {
    _stopPositionTimer();
    _positionTimer = Timer.periodic(Duration(seconds: 5), (_) {
      if (_isConnected && _client.connected) {
        sendPosition(lobbyId);
      } else {
        _positionTimer?.cancel();
      }
    });
  }

  void _stopPositionTimer() {
    _positionTimer?.cancel();
    _positionTimer = null;
  }

  void disconnectSilently() {
    disconnect(() {});
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    disconnectSilently();
  }
}
