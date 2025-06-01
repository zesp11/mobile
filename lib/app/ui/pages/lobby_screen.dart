import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotale/app/models/scenario.dart';
import 'package:gotale/app/routes/app_routes.dart';
import 'package:gotale/app/controllers/gameplay_controller.dart';
import 'package:gotale/app/controllers/lobby_controller.dart';

class LobbyScreen extends StatefulWidget {
  final Scenario gamebook;
  final String jwtToken;

  const LobbyScreen({
    Key? key,
    required this.gamebook,
    required this.jwtToken,
  }) : super(key: key);

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  final LobbyController controller = Get.put(LobbyController());

  @override
  void initState(){
    super.initState();
    controller.init(scenario: widget.gamebook, token: widget.jwtToken);

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
                onPressed: () {
                  final gameController = Get.find<GamePlayController>();

                  final bool isMulti = widget.gamebook.limitPlayers > 1;
                  gameController.gameType = isMulti ? GameType.multi : GameType.single;

                  Get.toNamed(AppRoutes.gameDetail.replaceFirst(
                    ":id",
                    gameController.currentGame.value!.idGame.toString(),
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
