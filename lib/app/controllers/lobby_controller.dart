import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:gotale/app/controllers/gameplay_controller.dart';
import 'package:gotale/app/models/lobby.dart';
import 'package:gotale/app/models/scenario.dart';
import 'package:gotale/app/routes/app_routes.dart';
import 'package:gotale/app/services/lobby_service.dart';
import 'package:gotale/app/services/user_service.dart';
import 'package:gotale/app/services/websocket_service.dart';
import 'package:gotale/app/ui/widgets/lobby_socket_panel.dart';
import 'package:logger/logger.dart';

class LobbyController extends GetxController {
  final SocketService socketService = Get.find<SocketService>();
  final lobbyService = Get.find<LobbyService>();
  final FlutterSecureStorage secureStorage = Get.find<FlutterSecureStorage>();
  SocketService get socket => socketService;
  final userService = Get.find<UserService>();
  final logger = Get.find<Logger>();

  late Scenario gamebook;
  late String jwtToken = "";
  late int setLobbyId;
  late int currentUserId;

  Function(String) onErrorGlobal = (msg) => print("ERROR: $msg");

  var isConnected = false.obs;
  var users = <dynamic>[].obs;
  var createdLobby = Rxn<Lobby>();

  late int setGameId;

  void init(
      {required Scenario scenario,
      required String token,
      required String type,
      required int lobbyId,
      required int gameId}) {
    gamebook = scenario;
    jwtToken = token;

    switch (type) {
      case 'create':
        logger.d("wybrano utworzenie lobby");
        _createAndOpenLobby();
        break;
      case 'join':
        logger.d("wybrano dołączenie do lobby");
        _joinLobby(lobbyId);
        break;
      case 'rejoin':
        logger.d("wybrano powrót do lobby");
        _joinLobby(lobbyId);
        setGameId = gameId;
        break;
      case 'rejoin-waiting':
        logger.d("wybrano powrót do lobby");
        _joinLobby(lobbyId);
        setGameId = gameId;
        break;
    }

    Future(() async {
      final currentUser = await userService.fetchCurrentUserProfile();
      currentUserId = currentUser.id;
    });
  }

  Future<Lobby> createLobby(int scenarioId) async {
    try {
      final lobby = await lobbyService.createLobby(scenarioId, jwtToken);
      createdLobby.value = lobby;
      
      return lobby;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadToken() async {
    final token = await secureStorage.read(key: 'accessToken');
    if (token != null) {
      jwtToken = 'Bearer $token';
    } else {
      jwtToken = "null";
    }
  }

  Future<void> _createAndOpenLobby() async {
    try {
      final lobby = await createLobby(gamebook.id);
      setLobbyId = lobby.idLobby;

      Get.snackbar(
        'lobby_created'.tr,
        "ID Lobby: ${lobby.idLobby}, Status: ${lobby.status}",
        snackPosition: SnackPosition.BOTTOM,
      );

      if (jwtToken == "") {
        await loadToken();
      }

      _connectToLobby(onConnected: () {});
    } catch (e) {
      logger.e("Błąd - Nie udało się stworzyć lobby: $e");
    }
  }

  Future<void> _joinLobby(int lobbyId) async {
    try {
      setLobbyId = lobbyId;

      Get.snackbar(
        "Dołączono do lobby!",
        "ID Lobby: ${setLobbyId}",
        snackPosition: SnackPosition.BOTTOM,
      );

      if (jwtToken == "") {
        await loadToken();
      }

      _connectToLobby(onConnected: () {
        sendJoin();
      });
    } catch (e) {
      logger.e("Błąd - Nie udało się dołączyć do lobby: $e");
    }
  }

  void _connectToLobby({required VoidCallback onConnected}) {
    socketService.connect(
      jwtToken: jwtToken,
      lobbyId: setLobbyId.toString(),
      onLog: (msg) => print("🧾 $msg"),
      onError: (err) => Get.snackbar("Błąd", err,
          backgroundColor: Get.theme.colorScheme.error),
      onUsersReceived: (userList) {
        users.assignAll(userList);
      },
      onConnected: () {
        isConnected.value = socketService.isConnected;
        onConnected();
      },
    );
    isConnected.value = socketService.isConnected;
  }

  void disconnect() {
    socketService.shouldReconnect = false;
    socketService.disconnect(() {
      isConnected.value = false;
    });
  }

  void requestUserList() {
    socketService.requestUserList(setLobbyId.toString());
  }

  void sendJoin() {
    socketService.sendJoinMessage(setLobbyId.toString());
  }

  void sendMessage(String msg) {
    socketService.sendMessage(setLobbyId.toString(), msg);
  }

  Future<Lobby> startGame() async {
    try {
      final lobby = await lobbyService.startGameFromLobby(setLobbyId);
      createdLobby.value = lobby;
      sendMessage(jsonEncode({
        "type": "start-game",
        "gameId": lobby.idGame,
      }));
      logger.d("sending gameId");
      socketService.gameStarted = true;
      return lobby;
    } catch (e) {
      rethrow;
    }
  }

  void joinGame() {
    logger.d("Otrzymane gameId do rozpoczęcia gry:");
    logger.d(setGameId);

    final gameController = Get.find<GamePlayController>();

    gameController.gameType = GameType.multi;
    socketService.gameStarted = true;

    Get.toNamed(AppRoutes.gameDetail.replaceFirst(
      ":id",
      setGameId.toString(),
    ));
  }

  void deleteUser(int id) async {
    try {
      sendMessage(jsonEncode({
        "type": "delete",
        "deleted-user": id,
      }));
    } catch (e) {
      rethrow;
    }
  }

  

  Future<void> reactToBeingDeleted(BuildContext context, int deletedUserId) async {
    if(deletedUserId == currentUserId)
    {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          final theme = Theme.of(context);
          return AlertDialog(
            backgroundColor: theme.colorScheme.primary,
            title: Text(
              'kicked_out_of_the_lobby'.tr,
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            content: Text(
              'host_kicked_you'.tr,
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  disconnect();
                  Navigator.of(dialogContext).pop();
                  Get.back();
                },
                child: Text(
                  "OK",
                  style: TextStyle(color: theme.colorScheme.secondary),
                ),
              ),
            ],
          );
        },
      );
    }
      
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
