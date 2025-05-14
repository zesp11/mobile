import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
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

  var isConnected = false.obs;
  var users = <dynamic>[].obs;
  var createdLobby = Rxn<Lobby>();

  void init({required Scenario scenario, required String token}) {
    gamebook = scenario;
    jwtToken = token;

    print("token:");
    print(token);

    _createAndOpenLobby();

    _connectToLobby();
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
      //final gameController = Get.find<GamePlayController>();
      //final game = gameController.currentGame.value;
      //if (game == null) throw Exception("Brak aktywnej gry!");
      print("tworzy lobby---------------");
      print(gamebook.id);
      final lobby = await createLobby(gamebook.id);
      print("utworzono");

      Get.snackbar(
        "Lobby stworzone!",
        "ID Lobby: ${lobby.idLobby}, Status: ${lobby.status}",
        snackPosition: SnackPosition.BOTTOM,
      );

      if (jwtToken == null) {
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
    } catch (e) {
      print(
        "Błąd - Nie udało się stworzyć lobby: $e"
      );
    }
  }

  void _connectToLobby() {
    socketService.connect(
      jwtToken: jwtToken,
      lobbyId: gamebook.id.toString(),
      onLog: (msg) => print("🧾 $msg"),
      onError: (err) => Get.snackbar("Błąd", err, backgroundColor: Get.theme.colorScheme.error),
      onUsersReceived: (userList) {
        users.assignAll(userList);
      },
    );
    isConnected.value = socketService.isConnected;
  }

  void disconnect() {
    socketService.disconnect(() {
      isConnected.value = false;
    });
  }

  void requestUserList() {
    socketService.requestUserList(gamebook.id.toString());
  }

  void sendMessage(String msg) {
    socketService.sendMessage(gamebook.id.toString(), msg);
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
