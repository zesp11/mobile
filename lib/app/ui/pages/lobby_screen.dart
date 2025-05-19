import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gotale/app/models/lobby.dart';
import 'package:gotale/app/models/scenario.dart';
import 'package:gotale/app/models/user.dart';
import 'package:gotale/app/models/user_location.dart';
import 'package:gotale/app/routes/app_routes.dart';
import 'package:gotale/app/controllers/gameplay_controller.dart';
import 'package:gotale/app/controllers/lobby_controller.dart';
import 'package:gotale/app/services/user_service.dart';

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
  final LobbyController controller = Get.put(LobbyController());

  final UserService userService = Get.find<UserService>();

  @override
  void initState() {
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
    Get.delete<LobbyController>();
    super.dispose();
  }

/*
  User getUser(String userId) async {
    try {
      
      return user;
    } catch (e) {
      print("❌ Failed to load user $userId: $e");
      return null;
    }
  }*/

  //final RxList<User> users = <User>[].obs;

  @override
  Widget build(BuildContext context) {
    print("LobbyScreen build");
    print(controller.users);
    print(widget.gamebook.name);
    final theme = Theme.of(context);
    //final RxList<User> users = <User>[].obs;

    return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(widget.gamebook.name ?? "Lobby"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              controller.disconnect();
              Future.delayed(Duration(milliseconds: 200), () {
                Get.back();
              });
            },
          ),
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
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
                      const Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 12),
                              Text(
                                "Ładowanie...",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.users.length,
                          itemBuilder: (context, index) {
                            final id = controller.users[index]['id_user'];

                            return FutureBuilder<User>(
                              future:
                                  userService.fetchUserProfile(id.toString()),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }

                                final user = snapshot.data!;

                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 4,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 4),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundImage: user.photoUrl != null
                                              ? NetworkImage(user.photoUrl!)
                                              : null,
                                          child: user.photoUrl == null
                                              ? const Icon(Icons.person)
                                              : null,
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                user.login,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "ID: ${user.id}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 25),
                                        Text(
                                          controller.users[index]['id_player']
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge
                                              ?.copyWith(
                                                color: theme
                                                    .secondaryHeaderColor, //Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  /*child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: user.photoUrl != null
                                ? NetworkImage(user.photoUrl!)
                                : null,
                              child: user.photoUrl == null ? const Icon(Icons.person) : null,
                            ),
                            title: Text(user.login),
                            subtitle: Text("ID: ${user.id}"),
                          ),*/
                                );
                              },
                            );
                          },
                        ),
                      ),
                    const Spacer(),
                    //const SizedBox(height: 10),
                    if (widget.type == "create")
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final gameController =
                                  Get.find<GamePlayController>();

                              Lobby lobby = await controller.startGame();
                              print(
                                  "🟢 Gra wystartowała z ID: ${lobby.idLobby}, Status: ${lobby.status}");
                              //lobby.idGame;

                              final bool isMulti =
                                  widget.gamebook.limitPlayers > 1;
                              gameController.gameType =
                                  isMulti ? GameType.multi : GameType.single;

                              Get.toNamed(AppRoutes.gameDetail.replaceFirst(
                                ":id",
                                lobby.idGame.toString(),
                                //gameController.currentGame.value!.idGame.toString(),
                              ));
                            },
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: Text("Rozpocznij grę"),
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
                      )
                  ],
                )),
          ),
        ));
  }
}
