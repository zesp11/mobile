import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/auth_controller.dart';
import 'package:gotale/app/controllers/gameplay_controller.dart';
import "package:gotale/app/controllers/search_controller.dart" as goTaleSearch;
import 'package:gotale/app/models/lobby.dart';
import 'package:gotale/app/models/scenario.dart';
import 'package:gotale/app/models/user.dart';
import 'package:gotale/app/routes/app_routes.dart';
import 'package:gotale/app/services/api_service/api_service.dart';
import 'package:gotale/app/services/user_service.dart';
import 'package:gotale/app/ui/pages/error_screen.dart';
import 'package:gotale/app/ui/pages/lobby_screen.dart';
import 'package:gotale/app/ui/widgets/scenario_card.dart';

class SearchScreen extends GetView<goTaleSearch.SearchController> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBar(controller: controller),
            const SizedBox(height: 12),
            FilterButtons(controller: controller),
            const SizedBox(height: 12),
            Expanded(
              child: RefreshIndicator(
                color: theme.colorScheme.secondary,
                backgroundColor: theme.colorScheme.primary,
                onRefresh: () => controller.searchItems(controller.query.value),
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowIndicator();
                    return true;
                  },
                  child: SearchResults(controller: controller),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterButtons extends StatelessWidget {
  final goTaleSearch.SearchController controller;

  const FilterButtons({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _buildFilterButton(goTaleSearch.SearchController.userFilter, context),
          const SizedBox(width: 12),
          _buildFilterButton(
              goTaleSearch.SearchController.scenarioFilter, context),
          const SizedBox(width: 12),
          _buildFilterButton(
              goTaleSearch.SearchController.lobbyFilter, context),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String filterType, BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      bool isSelected = controller.selectedFilters.contains(filterType);
      return Expanded(
        child: ElevatedButton(
          onPressed: () {
            if (isSelected) {
              controller.selectedFilters.remove(filterType);
            } else {
              controller.selectedFilters.add(filterType);
            }
            controller.searchItems(controller.query.value);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected
                ? theme.colorScheme.secondary
                : theme.cardTheme.color,
            foregroundColor: isSelected
                ? theme.colorScheme.onSecondary
                : theme.colorScheme.onBackground,
            elevation: isSelected ? 2 : 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isSelected
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.tertiary.withOpacity(0.2),
              ),
            ),
          ),
          child: Text(
            filterType == goTaleSearch.SearchController.userFilter
                ? 'user'.tr
                : filterType == goTaleSearch.SearchController.scenarioFilter
                    ? 'scenario'.tr
                    : 'Lobby', //we wont be translating this anyways
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? theme.colorScheme.onSecondary
                  : theme.colorScheme.onBackground,
            ),
          ),
        ),
      );
    });
  }
}

class SearchBar extends StatefulWidget {
  final goTaleSearch.SearchController controller;

  SearchBar({required this.controller});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController =
        TextEditingController(text: widget.controller.query.value);
    // Update text controller when query changes
    widget.controller.query.listen((value) {
      if (_textController.text != value) {
        _textController.text = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _textController,
        decoration: InputDecoration(
          hintText: 'search_hint'.tr,
          hintStyle: theme.textTheme.bodyMedium,
          prefixIcon: Icon(Icons.search, color: theme.colorScheme.tertiary),
          filled: true,
          fillColor: theme.cardTheme.color,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                BorderSide(color: theme.colorScheme.tertiary.withOpacity(0.2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                BorderSide(color: theme.colorScheme.tertiary.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: theme.colorScheme.secondary),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        style: theme.textTheme.bodyLarge,
        onChanged: widget.controller.updateQuery,
      ),
    );
  }
}

class SearchResults extends StatelessWidget {
  final FlutterSecureStorage secureStorage = Get.find<FlutterSecureStorage>();
  late String jwtToken;

  Future<void> loadToken() async {
    final token = await secureStorage.read(key: 'accessToken');
    if (token != null) {
      jwtToken = 'Bearer $token';
    } else {
      jwtToken = "null";
    }
  }

  final goTaleSearch.SearchController controller;

  SearchResults({required this.controller});

  @override
  Widget build(BuildContext context) {
    loadToken();
    final theme = Theme.of(context);

    return controller.obx(
      (searchResult) {
        if (searchResult == null || searchResult.isEmpty) {
          return Center(
            child: Text(
              'no_results_found'.tr,
              style: theme.textTheme.bodyLarge,
            ),
          );
        }

        // Combine both lists with section headers
        final List<Widget> listItems = [];

        // Users section
        if (searchResult.users.isNotEmpty) {
          listItems.add(_buildSectionHeader(theme, 'Users'));
          listItems.addAll(
              searchResult.users.map((user) => _buildUserCard(theme, user)));
        }

        // Scenarios section
        if (searchResult.scenarios.isNotEmpty) {
          listItems.add(_buildSectionHeader(theme, 'Scenarios'));
          listItems.addAll(searchResult.scenarios
              .map((scenario) => buildScenarioCard(theme, scenario)));
        }

        final filteredLobbies = searchResult.lobbies
            .where((lobby) => lobby.status == 'Waiting for more players')
            .toList();

        // Lobbies section
        if (filteredLobbies.isNotEmpty) {
          listItems.add(_buildSectionHeader(theme, 'Lobbies'));
          listItems.addAll((filteredLobbies
                ..sort((a, b) => b.idLobby.compareTo(a.idLobby)))
              .map((lobby) => _buildLobbyCard(theme, lobby)));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: listItems.length,
          itemBuilder: (context, index) => listItems[index],
        );
      },
      onLoading: Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.secondary,
        ),
      ),
      onError: (error) => ErrorScreen(
        onRetry: () => controller.searchItems(controller.query.value),
        error: error,
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildUserCard(ThemeData theme, User user) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: CircleAvatar(
          radius: 18, // Total diameter will be 64
          backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
          backgroundImage: (user.photoUrl != null &&
                  Uri.tryParse(user.photoUrl!)?.isAbsolute == true)
              ? NetworkImage(user.photoUrl!)
              : null,
          //user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
          child: user.photoUrl == null
              ? Text(
                  user.login.isNotEmpty ? user.login[0].toUpperCase() : '?',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        title: Text(
          user.login,
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Text(
          user.email,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: theme.colorScheme.tertiary,
        ),
        onTap: () => _handleUserTap(user),
      ),
    );
  }

  final UserService userService = Get.find<UserService>();
  final ApiService apiService = Get.find<ApiService>();

  String _mapStatusToText(String status) {
    switch (status) {
      case 'Waiting for more players':
        return ('waiting_lobby'.tr);
      case 'Gaming':
        return ('gaming_lobby'.tr);
      default:
        return status;
    }
  }

  Widget _buildLobbyCard(ThemeData theme, Lobby lobby) {
    final authController = Get.find<AuthController>();

    String _shortenText(String text, int maxLength) {
      if (text.length <= maxLength) return text;
      return '${text.substring(0, maxLength)}...';
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        height: 100,
        child: Row(
          children: [
            // Lewa część – tło scenariusza + avatar
            Stack(
              children: [
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    color: theme.cardColor,
                    image: (lobby.scenario.photoUrl != null &&
                            lobby.scenario.photoUrl!.isNotEmpty)
                        ? DecorationImage(
                            image: NetworkImage(lobby.scenario.photoUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: (lobby.scenario.photoUrl == null ||
                          lobby.scenario.photoUrl!.isEmpty)
                      ? Center(
                          child: Icon(
                            Icons.auto_stories,
                            size: 40,
                            color: theme.colorScheme.tertiary.withOpacity(0.3),
                          ),
                        )
                      : null,
                ),
                Positioned(
                  left: 8,
                  bottom: 8,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: (lobby.user.photoUrl != null &&
                            lobby.user.photoUrl!.isNotEmpty)
                        ? NetworkImage(lobby.user.photoUrl!)
                        : null,
                    backgroundColor:
                        theme.colorScheme.secondary.withOpacity(0.8),
                    child: (lobby.user.photoUrl == null ||
                            lobby.user.photoUrl!.isEmpty)
                        ? Text(
                            lobby.user.login.isNotEmpty
                                ? lobby.user.login[0].toUpperCase()
                                : '?',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ),
            // Prawa część – teksty i przycisk
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lobby ID: ${lobby.idLobby}',
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      lobby.user.login,
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      _shortenText(lobby.scenario.name ?? '', 25),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    /*Text(
                      _mapStatusToText(lobby.status),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),*/
                  ],
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Builder(builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: authController.isAuthenticated
                        ? () async {
                            final fetchedLobby =
                                await apiService.getLobbyWithId(lobby.idLobby);

                            if (fetchedLobby.status != "Max players") {
                              Get.to(() => LobbyScreen(
                                    gamebook: lobby.scenario,
                                    jwtToken: jwtToken,
                                    type: "join",
                                    id: lobby.idLobby,
                                    gameId: -1,
                                  ));
                            } else {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext dialogContext) {
                                  final theme = Theme.of(context);
                                  return AlertDialog(
                                    backgroundColor: theme.colorScheme.primary,
                                    title: Text(
                                      'cant_join_lobby'.tr,
                                      style: TextStyle(
                                          color: theme.colorScheme.onSurface),
                                    ),
                                    content: Text(
                                      'lobby_is_full'.tr,
                                      style: TextStyle(
                                          color: theme.colorScheme.onSurface),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();
                                        },
                                        child: Text(
                                          "OK",
                                          style: TextStyle(
                                              color:
                                                  theme.colorScheme.secondary),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    child: Text(
                      'lobby_join_button'.tr,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  );
                }))
          ],
        ),
      ),
    );
  }

  void _handleUserTap(User user) {
    Get.toNamed('/profile/${user.id}');
  }
}
