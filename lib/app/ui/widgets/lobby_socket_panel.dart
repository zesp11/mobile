import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotale/app/services/websocket_service.dart';

// only for testing sockets for now


class LobbySocketPanel extends StatefulWidget {
  final String jwtToken;
  final String lobbyId;

  const LobbySocketPanel({
    Key? key,
    required this.jwtToken,
    required this.lobbyId,
  }) : super(key: key);

  @override
  State<LobbySocketPanel> createState() => _LobbySocketPanelState();
}

class _LobbySocketPanelState extends State<LobbySocketPanel> {
  final SocketService socketService = Get.find();
  final List<String> _logs = [];

  void _log(String msg) {
    setState(() => _logs.add(msg));
  }

  void _error(String err) {
    _log("Błąd: $err");
    Get.snackbar("Błąd", err, snackPosition: SnackPosition.BOTTOM);
  }

  @override
  void initState() {
    super.initState();
    socketService.connect(
      jwtToken: widget.jwtToken,
      lobbyId: widget.lobbyId,
      onLog: _log,
      onError: _error,
    );
  }

  @override
  void dispose() {
    socketService.disconnect((){print("Socket rozłączony pomyślnie");});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            socketService.sendMessage(widget.lobbyId, "testtttt\n");
          },
          child: Text("Wyślij wiadomość"),
        ),
        const SizedBox(height: 12),
        const Text("Logi połączenia:"),
        Container(
          height: 150,
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          color: Colors.black12,
          child: SingleChildScrollView(
            child: Text(_logs.join('\n')),
          ),
        ),
      ],
    );
  }
}
