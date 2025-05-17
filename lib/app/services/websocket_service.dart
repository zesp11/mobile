import 'dart:convert';
import 'dart:ui';
import 'package:geolocator/geolocator.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'dart:async';

class SocketService {
  Timer? _positionTimer;
  late StompClient _client;
  late String _sessionId = "bad";// = 'flutter-${DateTime.now().millisecondsSinceEpoch}';
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  late Function(String) onErrorGlobal;
  late Function(String) onLogGlobal;
  late Function(List<dynamic> users) onUsersReceived;
  bool _receivedSessionId = false; 
  late String token;

  void connect({
    required String jwtToken,
    required String lobbyId,
    required Function(String message) onLog,
    required Function(String error) onError,
    required Function(List<dynamic> users) onUsersReceived,
    required VoidCallback onConnected,
    
  }) {
    _client = StompClient(
      config: StompConfig(
        //url: "ws://10.0.2.2:8080/websocket/websocket", // na localu na emulatorze
        //url: "ws://localhost:8080/websocket/websocket", // na localu
        url: 'ws://squid-app-p63zw.ondigitalocean.app:8080/websocket/websocket',
        useSockJS: false,// 
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
          final url = frame.headers['sockjs-url'];
          this.onUsersReceived = onUsersReceived;

          //print(url);
          token = jwtToken;

          /*if (url != null) {
            _sessionId = _extractSessionId(url);
            onLog("Połączono, sessionId: $_sessionId");
          }*/
          //_sessionId = "kjsgsgsglslgds";

          /*final url = frame.headers['sessionId'];
          if (url != null) {
            print("sessionId: $url");
          } else {
            print("Brak sessionId w headerach...");
          }
          print("hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
          _sessionId = 'flutter-${DateTime.now().millisecondsSinceEpoch}';*/

          print("🔍 -------------------------------Wszystkie headery:");
          frame.headers.forEach((key, value) {
            print("  $key: $value");
          });
          print(frame.body);


          //_sessionId = 'flutter-${DateTime.now().millisecondsSinceEpoch}';
          onErrorGlobal = onError;
          onLogGlobal = onLog;

          onLog("✅ Połączono, sessionId: $_sessionId");
          print("✅ Połączono, sessionId: $_sessionId");

          //_subscribeToErrors(onError, onLog);
          _subscribeToLobby(lobbyId, onLog);
          
          //sendMessage(lobbyId, "init-session");

          //_subscribeToErrors(onError, onLog);
          onConnected();

        },
        onWebSocketError: (err) => onError("❌ WebSocket error: $err"),
        onStompError: (frame) => onError("❌ STOMP error: ${frame.body}"),
        onDisconnect: (_) {
          _isConnected = false;
          onLog("🔌 Rozłączono");
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
        //final body = frame.body ?? "";
        var body = frame.body ?? "";
        print("📥 Otrzymano: ${frame.body}");

        /*
        if (_receivedSessionId) {
          return;
        }*/
        print("lobby id hereeeeeeeeeeeeeeeeeeeee:");
            print(lobbyId);

        try {
          final data = jsonDecode(body);

          if (data is Map<String, dynamic>) {
          // 1. Obsługa sessionId (raz)
          if (!_receivedSessionId && data.containsKey('sessionId')) {
            _sessionId = data['sessionId'];
            _receivedSessionId = true;
            onLog("📌 Otrzymano sessionId: $_sessionId");

            _subscribeToErrors(onErrorGlobal!, onLogGlobal!);
            _subscribeToUserList(lobbyId);
            return;
          }

          final type = data['type'];

          switch (type) {
            case 'start-game':
              //a();
              break;
            case 'new-positions':
              //b();
              break;
            case 'new-user':
              //c();
              break;
            default:
              print("❓ Nieznany typ wiadomości: $type");
            }
          }
          
          
          else {
            print("💢 Nie zawiera sessionId!");
          }
        } catch (e) {
          print("💥 Error parsowania JSONa: $e");
        }

        //sendMessage(lobbyId, "init-session");
        /*body = body.replaceAll('\n', '\\n');

        try {
          final data = jsonDecode(body);
          if (data is Map<String, dynamic>) {
            final message = data['sessionId'];
            print("🔑 Wiadomość: $message");
          } else {
            print("❌");
          }
        } catch (e) {
          print("💥 Error parsowania JSONa: $e");
        }*/
        //print(${frame.body});
      },
      
    );

    sendMessage(lobbyId, "init-session");
    sendPosition(lobbyId);
  

  }

  void _subscribeToUserList(String lobbyId) {
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
            print(users);
            onLogGlobal("📥 Odebrano listę użytkowników.");
          } else {
            print("ℹ️ Odebrano wiadomość tekstową: $body");

            if (body.contains("Lobby created with status: gaming")) {
              onLogGlobal("📥 Odebrano wiadomość: $body");
            }
          }
        } catch (e) {
          print("💥 Błąd parsowania listy użytkowników: $e");
        }
      },
    );
  }

  void _subscribeToErrors(void Function(String) onError, void Function(String) onLog) {
    if (_sessionId == null) return;

    _client?.subscribe(
      destination: "/queue/errors/$_sessionId",
      callback: (frame) {
        //print("-----------------w error sessionid: ${_sessionId}");
        try {
          final Map<String, dynamic> error = frame.body != null ? Map<String, dynamic>.from(jsonDecode(frame.body!)) : {};
          final type = error['type'];

          switch (type) {
            case "LOBBY_NOT_FOUND":
              onError("Lobby nie istnieje.");
              disconnect(() => onLog("Rozłączono - brak lobby"));
              break;
            case "LOBBY_FULL":
              onError("Lobby pełne.");
              disconnect(() => onLog("Rozłączono - pełne lobby"));
              break;
            case "AUTH_ERROR":
              onError("JWT error: ${error['message']}");
              disconnect(() => onLog("JWT problem"));
              break;
            case "DUPLICATE_SESSION":
              onError("Zduplikowana sesja.");
              disconnect(() => onLog("Starsze połączenie zamknięte"));
              break;
            case "NO_LOBBY":
              onError("Nie podano ID lobby.");
              break;
            default:
              onError("Nieznany błąd: ${error['message'] ?? "brak info"}");
          }
        } catch (e) {
          onError("Błąd (nie JSON): ${frame.body}");
        }
      },
    );
  }

  void sendMessage(String lobbyId, String message) {
    if (_isConnected) {
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
    if (!_isConnected) {
      //onErrorGlobal("❌ Brak połączenia. Nie można dołączyć.");
      print("❌ Brak połączenia. Nie można dołączyć.");
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
    print("📨 Wysłano prośbę o dołączenie do lobby.");
    onLogGlobal("📨 Wysłano prośbę o dołączenie do lobby.");
  }

  void requestUserList(String lobbyId) {
    if (!_isConnected) {
      onErrorGlobal("❌ Brak połączenia. Nie można pobrać użytkowników.");
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
    if (_isConnected) {
      _positionTimer?.cancel();
      _client.deactivate();
      _isConnected = false;
      onDisconnected();
    }
  }

  Future<void> sendPosition(String lobbyId) async {

      if (!_isConnected) {
      onErrorGlobal("❌ Brak połączenia. Nie można wysłać pozycji.");
      return;
    }

    // 🔒 Sprawdzenie uprawnień
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        onErrorGlobal("❌ Odmówiono uprawnień do lokalizacji.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      onErrorGlobal("❌ Uprawnienia do lokalizacji na stałe zablokowane.");
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
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
    } catch (e) {
      onErrorGlobal("💥 Błąd pobierania lokalizacji: $e");
    }
  }

  void _startSendingPositionLoop(String lobbyId) {
  _positionTimer?.cancel(); 
  _positionTimer = Timer.periodic(Duration(seconds: 5), (_) {
    if (_isConnected) {
      sendPosition(lobbyId);
    } else {
      _positionTimer?.cancel();
    }
  });
}

  void disconnectSilently() {
  disconnect(() {});
  }

}


