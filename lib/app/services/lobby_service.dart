import 'package:get/get.dart';
import 'package:gotale/app/models/lobby.dart';
import 'package:gotale/app/services/api_service/api_service.dart';
import 'package:logger/web.dart';

class LobbyService extends GetxService {
  final ApiService apiService;
  final logger = Get.find<Logger>();

  LobbyService({required this.apiService});

  Future<Lobby> createLobby(int scenarioId) async {
    try {
      return await apiService.createLobby(scenarioId);
    } catch (e) {
      logger.e("Error creating lobby: $e");
      rethrow;
    }
  }
}