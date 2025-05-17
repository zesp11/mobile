import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gotale/app/models/lobby.dart';
import 'package:gotale/app/models/scenario.dart';
import 'package:gotale/app/routes/app_routes.dart';
import 'package:gotale/app/controllers/gameplay_controller.dart';
import 'package:gotale/app/controllers/lobby_controller.dart';

class LobbyScreen extends StatefulWidget {
  final Scenario gamebook;
  final String jwtToken;
  final String type;
  final int id;

  const LobbyScreen({
    Key? key,
    required this.gamebook,
    required this.jwtToken,
    required this.type,
    required this.id,
  }) : super(key: key);

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  final LobbyController controller = Get.put(LobbyController(), permanent: true);

  @override
  void initState(){
    super.initState();
    //controller.init(scenario: widget.gamebook, token: widget.jwtToken, type: widget.type, lobbyId: widget.id);
    Future.microtask(() {
      controller.init(
        scenario: widget.gamebook,
        token: widget.jwtToken,
        type: widget.type,
        lobbyId: widget.id,
      );
    });
    /*final gameController = Get.find<GamePlayController>();
    await gameController.createGameFromScenario(widget.gamebook.id);
    final bool isMulti = widget.gamebook.limitPlayers > 1;
    gameController.gameType = isMulti ? GameType.multi : GameType.single;*/
  }

  @override
  void dispose() {
    controller.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("LobbyScreen build");
    print(controller.users);
    print(widget.gamebook.name);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.gamebook.name ?? "Lobby"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Gracze w lobby:",
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (controller.users.isEmpty)
              Text(
                "🔎 Brak graczy... jeszcze.",
                style: theme.textTheme.bodyMedium,
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: controller.users.length,
                  itemBuilder: (context, index) {
                    final user = controller.users[index];
                    return Card(
                      child: ListTile(
                        title: Text(user.toString()),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final gameController = Get.find<GamePlayController>();

                  Lobby lobby = await controller.startGame();
                  print("🟢 Gra wystartowała z ID: ${lobby.idLobby}, Status: ${lobby.status}");
                  //lobby.idGame;

                  final bool isMulti = widget.gamebook.limitPlayers > 1;
                  gameController.gameType = isMulti ? GameType.multi : GameType.single;

                  Get.toNamed(AppRoutes.gameDetail.replaceFirst(
                    ":id",
                    lobby.idGame.toString(),
                    //gameController.currentGame.value!.idGame.toString(),
                  ));
                },
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(widget.gamebook.limitPlayers > 1 ? "Rozpocznij grę" : "Zagraj"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: theme.colorScheme.onSecondary,
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
