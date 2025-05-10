import 'dart:convert';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class SocketService {
  late StompClient _client;
  late String _sessionId = "bad";// = 'flutter-${DateTime.now().millisecondsSinceEpoch}';
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  late Function(String) onErrorGlobal;
  late Function(String) onLogGlobal;
  bool _receivedSessionId = false; 

  void connect({
    required String jwtToken,
    required String lobbyId,
    required Function(String message) onLog,
    required Function(String error) onError,
    
  }) {
    _client = StompClient(
      config: StompConfig(
        url: "ws://10.0.2.2:8080/websocket/websocket", // na localu na emulatorze
        //url: "ws://localhost:8080/websocket/websocket", // na localu
        //url: 'ws://squid-app-p63zw.ondigitalocean.app:8080/websocket/websocket',
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
          _isConnected = true;
          final url = frame.headers['sockjs-url'];

          print(url);

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
          print("tyle kurwaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");

/*
          final url = frame.headers['sockjs-url'];
          if (url != null) {

            _sessionId = _extractSessionId(url);
            onLog("Połączono, sessionId: $_sessionId");
          }
          else {
            //_sessionId = "chuj";
            //print("kurwaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
          }*/

          //_sessionId = 'flutter-${DateTime.now().millisecondsSinceEpoch}';
          onErrorGlobal = onError;
          onLogGlobal = onLog;

          onLog("✅ Połączono, sessionId: $_sessionId");
          print("✅ Połączono, sessionId: $_sessionId");

          //_subscribeToErrors(onError, onLog);
          _subscribeToLobby(lobbyId, onLog);
          
          //sendMessage(lobbyId, "init-session");

          _subscribeToErrors(onError, onLog);

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

        if (_receivedSessionId) {
          return;
        }

        try {
          final data = jsonDecode(body);
          if (data is Map<String, dynamic> && data.containsKey('sessionId')) {
            _sessionId = data['sessionId'];
            _receivedSessionId = true;
            onLog("📌 Otrzymano sessionId: $_sessionId");

            // Subskrypcja na błędy dopiero teraz
            //_subscribeToErrors(onErrorGlobal!, onLogGlobal!); // użyj zapisanych funkcji
            _subscribeToErrors(onErrorGlobal!, onLogGlobal!);
          } else {
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
  

  }

  void _subscribeToErrors(void Function(String) onError, void Function(String) onLog) {
    if (_sessionId == null) return;

    _client?.subscribe(
      destination: "/queue/errors/$_sessionId",
      callback: (frame) {
        print("-----------------w error sessionid: ${_sessionId}");
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

  void disconnect(void Function() onDisconnected) {
    if (_isConnected) {
      _client.deactivate();
      _isConnected = false;
      onDisconnected();
    }
  }

  void disconnectSilently() {
  disconnect(() {});
  }

  String _extractSessionId(String url) {
    final parts = url.split('/');
    return parts[parts.length - 2];
  }
}



/*class SocketService {
  StompClient? _client;
  bool _isConnected = false;
  String? _sessionId;

  void connectToLobby({
    required String jwtToken,
    required String lobbyId,
    required void Function(String) onLog,
    required void Function(String) onError,
  }) {
    if (_isConnected) {
      disconnect(() => onLog("Poprzednie połączenie rozłączone."));
    }

    _client = StompClient(
      config: StompConfig(
        url: 'ws://squid-app-p63zw.ondigitalocean.app:8080/websocket',
        useSockJS: false,
        stompConnectHeaders: {
          'Authorization': 'Bearer $jwtToken',
          'lobby-id': lobbyId,
        },
        webSocketConnectHeaders: {
          'Authorization': 'Bearer $jwtToken',
        },
        onConnect: (StompFrame frame) {
          _isConnected = true;
          final url = frame.headers['sockjs-url'];
          if (url != null) {
            _sessionId = _extractSessionId(url);
            onLog("Połączono, sessionId: $_sessionId");
          }

          _subscribeToErrors(onError, onLog);
          _subscribeToLobby(lobbyId, onLog);
        },
        onWebSocketError: (err) => onError("WebSocket error: $err"),
        onStompError: (frame) => onError("STOMP Error: ${frame.body}"),
        onDisconnect: (_) {
          _isConnected = false;
          onLog("Rozłączono");
        },
      ),
    );

    _client!.activate();
  }

  void sendLobbyMessage(String lobbyId, void Function(String) onLog) {
    final msg = "wiadomość do lobby $lobbyId";
    _client?.send(destination: "/app/lobby/send/$lobbyId", body: msg);
    onLog("Wysłano: $msg");
  }

  void disconnect(void Function() onDisconnected) {
    _client?.deactivate();
    _isConnected = false;
    onDisconnected();
  }

  void _subscribeToLobby(String lobbyId, void Function(String) onLog) {
    _client?.subscribe(
      destination: "/topic/lobby.$lobbyId",
      headers: {"lobby-id": lobbyId},
      callback: (frame) {
        final body = frame.body ?? "";
        onLog("Wiadomość z lobby: $body");
      },
    );
  }

  void _subscribeToErrors(void Function(String) onError, void Function(String) onLog) {
    if (_sessionId == null) return;

    _client?.subscribe(
      destination: "/queue/errors/$_sessionId",
      callback: (frame) {
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

  String _extractSessionId(String url) {
    final parts = url.split('/');
    return parts[parts.length - 2];
  }
}*/
