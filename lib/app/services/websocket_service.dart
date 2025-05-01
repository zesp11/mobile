import 'dart:convert';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class SocketService {
  late StompClient _client;
  late String _sessionId;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  void connect({
    required String jwtToken,
    required String lobbyId,
    required Function(String message) onLog,
    required Function(String error) onError,
  }) {
    _client = StompClient(
      config: StompConfig(
        url: 'ws://squid-app-p63zw.ondigitalocean.app:8080/websocket/websocket', // ✅ czysty WebSocket
        useSockJS: false, // ❌ bez SockJS
        stompConnectHeaders: {
          'Authorization': 'Bearer $jwtToken',
          'lobby-id': lobbyId,
        },
        webSocketConnectHeaders: {
          'Authorization': 'Bearer $jwtToken',
        },
        onConnect: (StompFrame frame) {
          _isConnected = true;

          // ✅ Generujemy własne sessionId
          _sessionId = 'flutter-${DateTime.now().millisecondsSinceEpoch}';
          onLog("✅ Połączono, sessionId: $_sessionId");

          _subscribeToErrors(onError, onLog);
          _subscribeToLobby(lobbyId, onLog);
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
        onLog("📥 Otrzymano: ${frame.body}");
      },
    );
  }

  void _subscribeToErrors(Function(String message) onError, Function(String log) onLog) {
    _client.subscribe(
      destination: '/queue/errors/$_sessionId',
      callback: (StompFrame frame) {
        onError("⛔ Błąd: ${frame.body}");
        disconnect();
      },
    );
  }

  void sendMessage(String lobbyId, String message) {
    if (_isConnected) {
      _client.send(
        destination: '/app/lobby/send/$lobbyId',
        body: message,
      );
    }
  }

  void disconnect() {
    if (_isConnected) {
      _client.deactivate();
      _isConnected = false;
    }
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
