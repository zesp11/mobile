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
  bool isAlreadyStarted = false;
  String? currentUserId;

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
    Future(() async {
      final currentUser = await userService.fetchCurrentUserProfile();
      setState(() {
        currentUserId = currentUser.id.toString();
      });
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
            child: Obx(() {
              final sortedUsers = [...controller.users];
              sortedUsers.sort((a, b) => a['id_player'].compareTo(b['id_player']));

              return Column(
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
                          itemCount: sortedUsers.length,
                          itemBuilder: (context, index) {
                            final id = sortedUsers[index]['id_user'];

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
                                          backgroundColor: theme.primaryColor,
                                          backgroundImage: user.photoUrl != null
                                              ? NetworkImage(user.photoUrl!)
                                              : null,
                                          child: user.photoUrl == null
                                              ? Text(
                                                  user.login.isNotEmpty ? user.login[0].toUpperCase() : '?',
                                                  style: theme.textTheme.titleLarge?.copyWith(
                                                    
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
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
                                          sortedUsers[index]['id_player']
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
                                        if (widget.type == "create" && user.id.toString() != currentUserId)
                                          IconButton(
                                            icon: const Icon(Icons.close, color: Colors.red),
                                            onPressed: () {
                                              controller.deleteUser(user.id);
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    if (widget.type == "create")
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: isAlreadyStarted
                            ? ElevatedButton.icon(
                                onPressed: () {
                                  controller.joinGame();
                                },
                                label: const Text("Return to game"),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  backgroundColor: theme.colorScheme.secondary,
                                  foregroundColor: theme.colorScheme.onSecondary,
                                ),
                              )
                            : ElevatedButton.icon(
                                onPressed: controller.users.length < widget.gamebook.limitPlayers
                                  ? null
                                  : () async {
                                  final gameController = Get.find<GamePlayController>();

                                  Lobby lobby = await controller.startGame();
                                  print("🟢 Gra wystartowała z ID: ${lobby.idLobby}, Status: ${lobby.status}");

                                  final bool isMulti = widget.gamebook.limitPlayers > 1;
                                  gameController.gameType = isMulti ? GameType.multi : GameType.single;

                                  setState(() {
                                    isAlreadyStarted = true;
                                  });

                                  Get.toNamed(AppRoutes.gameDetail.replaceFirst(
                                    ":id",
                                    lobby.idGame.toString(),
                                  ));
                                },
                                icon: const Icon(Icons.play_arrow_rounded),
                                label: Text(
                                  "Rozpocznij grę",
                                  style: TextStyle(
                                    color: controller.users.length < widget.gamebook.limitPlayers
                                        ? Colors.grey.shade300
                                        : theme.colorScheme.onSecondary,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  backgroundColor: controller.users.length < widget.gamebook.limitPlayers
                                    ? theme.disabledColor.withOpacity(0.3)
                                    : theme.colorScheme.secondary,
                                  foregroundColor: theme.colorScheme.onSecondary,
                                ),
                              ),
                        ),
                      )
                  ],
              );
            })
          ),
        ));
  }
}
