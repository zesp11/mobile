import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:gotale/app/controllers/gameplay_controller.dart';
import 'package:gotale/app/models/lobby.dart';
import 'package:gotale/app/models/scenario.dart';
import 'package:gotale/app/services/lobby_service.dart';
import 'package:gotale/app/services/websocket_service.dart';
import 'package:gotale/app/ui/widgets/lobby_socket_panel.dart';

class LobbyController extends GetxController {
  final SocketService socketService = Get.find<SocketService>();
  final lobbyService = Get.find<LobbyService>();
  final FlutterSecureStorage secureStorage = Get.find<FlutterSecureStorage>();

  late Scenario gamebook;
  late String jwtToken ="";
  late int setLobbyId;

  var isConnected = false.obs;
  var users = <dynamic>[].obs;
  var createdLobby = Rxn<Lobby>();

  void init({required Scenario scenario, required String token, required String type, required int lobbyId}) {
    gamebook = scenario;
    jwtToken = token;
    
    switch (type) {
      case 'create':
        print("wybrano utworzenie lobby");
        _createAndOpenLobby();
        break;
      case 'join':
        print("wybrano dołączenie do lobby");
        _joinLobby(lobbyId);
        break;
    }


  }

  Future<Lobby> createLobby(int scenarioId) async {
    try {
      final lobby = await lobbyService.createLobby(scenarioId, jwtToken);
      createdLobby.value = lobby;
      /*print(lobby);
      print("powyzej lobby?");
      print(createdLobby.value?.idLobby);
      print(createdLobby.value);
      print("powyżej jest lobbyyy^");*/
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
      //final gameController = Get.find<GamePlayController>();
      //final game = gameController.currentGame.value;
      //if (game == null) throw Exception("Brak aktywnej gry!");
      //print("tworzy lobby---------------");
      //print(createdLobby.value?.idLobby);
      final lobby = await createLobby(gamebook.id);
      setLobbyId = lobby.idLobby;
      print("utworzono");

      Get.snackbar(
        "Lobby stworzone!",
        "ID Lobby: ${lobby.idLobby}, Status: ${lobby.status}",
        snackPosition: SnackPosition.BOTTOM,
      );

      if (jwtToken == "") {
        await loadToken();
      }

      /*if (jwtToken != null) {
        // przechodzimy do widoku socketowego
        Get.to(() => LobbySocketPanel(
              jwtToken: jwtToken,
              lobbyId: lobby.idLobby.toString(),
            ));
      } else {
        Get.snackbar("Błąd", "Token JWT jest pusty! Nie można utworzyć lobby.",
            snackPosition: SnackPosition.BOTTOM);
      }*/

      _connectToLobby();

    } catch (e) {
      print(
        "Błąd - Nie udało się stworzyć lobby: $e"
      );
    }
  }

  Future<void> _joinLobby(int lobbyId) async {
    try {
      setLobbyId = lobbyId;
      print("utworzono");

      Get.snackbar(
        "Dołączono do lobby!",
        "ID Lobby: ${setLobbyId}",
        snackPosition: SnackPosition.BOTTOM,
      );
      print("aftersnackbar");

      //print("token in join: ${jwtToken}");
      if (jwtToken == "") {
        print("pusty");
        await loadToken();
      }

      print("connect się wykona");

      _connectToLobby();

      sendJoin();

    } catch (e) {
      print(
        "Błąd - Nie udało się dołączyć do lobby: $e"
      );
    }
  }

  void _connectToLobby() {
    print("inside connect");
    socketService.connect(
      jwtToken: jwtToken,
      lobbyId: setLobbyId.toString(),
      onLog: (msg) => print("🧾 $msg"),
      onError: (err) => Get.snackbar("Błąd", err, backgroundColor: Get.theme.colorScheme.error),
      onUsersReceived: (userList) {
        users.assignAll(userList);
      },
    );
    print("after connect");
    isConnected.value = socketService.isConnected;
  }

  void disconnect() {
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

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
