import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/gameplay_controller.dart';
import 'package:gotale/app/controllers/lobby_controller.dart';
import 'package:gotale/app/controllers/settings_controller.dart';
import 'package:gotale/app/models/game_history_record.dart';
import 'package:gotale/app/models/game_step.dart';
import 'package:gotale/app/models/lobby.dart';
import 'package:gotale/app/models/user.dart';
import 'package:gotale/app/models/user_location.dart';
import 'package:gotale/app/routes/app_routes.dart';
import 'package:gotale/app/services/user_service.dart';
import 'package:gotale/app/ui/widgets/decision_buttons.dart';
import 'package:gotale/app/ui/widgets/lobby_socket_panel.dart';
import 'package:intl/intl.dart';
import 'package:logger/web.dart';
import 'package:latlong2/latlong.dart' as latlong2;
import 'dart:math' as math;

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:gotale/app/services/location_service.dart';

bool isMulti = false;

class GamePlayScreen extends StatefulWidget {
  const GamePlayScreen({super.key});

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen>
    with TickerProviderStateMixin {
  final GamePlayController controller = Get.find();
  final Logger logger = Get.find<Logger>();
  late int tabCount;
  late TabController _tabController;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  String? userId;
  LobbyController? lobbyController;
  UserService? userService;

  @override
  void initState() {
    super.initState();
    final gamebookId = Get.parameters['id']!;
    controller.fetchGameWithId(int.parse(gamebookId));

    // Initialize with default values
    isMulti = controller.gameType == GameType.multi;
    tabCount = isMulti ? 4 : 3;

    _tabController = TabController(
      length: tabCount,
      vsync: this,
      initialIndex: 0,
    );

    _tabController.addListener(_handleTabChange);

    if (isMulti) {
      _initializeLobbyFunctionality();
    }
  }

  Future<void> _initializeLobbyFunctionality() async {
    try {
      // Get controllers
      lobbyController = Get.find<LobbyController>();
      userService = Get.find<UserService>();

      // Get current user ID
      await _getCurrentUserId();

      // Set up listener for user updates
      if (lobbyController != null) {
        ever(lobbyController!.users, (_) {
          _updateUserMarkers();
        });
      }
    } catch (e) {
      logger.e("Error initializing lobby functionality: $e");
    }
  }

  Future<void> _getCurrentUserId() async {
    final id = await secureStorage.read(key: 'userId');
    setState(() {
      userId = id;
    });
  }

  void _updateUserMarkers() {
    if (lobbyController == null || userId == null) return;

    Map<String, LatLng> coords = {};

    for (var user in lobbyController!.users) {
      final id = user['id_user'].toString();
      if (id == userId) continue;
      final lat = double.tryParse(user['latitude'].toString());
      final lng = double.tryParse(user['longitude'].toString());
      if (lat != null && lng != null) {
        coords[id] = LatLng(lat, lng);
      }
    }

    controller.displayUserMarkers(coords);
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging && _tabController.index == 1) {
      logger.d("StoryTab entered - refreshing data");
      controller.fetchGameHistory(controller.currentGame.value!.idGame);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gamebookId = Get.parameters['id']!;
    controller.fetchGameWithId(int.parse(gamebookId));
    isMulti = controller.gameType == GameType.multi;
    final tabCount = isMulti ? 4 : 3;

    Get.put(_tabController);

    logger.i("[DEV_DEBUG] GamePlayScreen built with gamebookId: $gamebookId");
    logger.d("Current gamebook: ${controller.currentGame.value}");
    logger.d("Current step: ${controller.currentStep.value}");

    return DefaultTabController(
      length: tabCount,
      child: Scaffold(
        appBar: AppBar(
          title: controller.obx(
            (state) => GameTitle(logger: logger, controller: controller),
            onLoading: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Theme.of(context).colorScheme.secondary,
            labelColor: Theme.of(context).colorScheme.secondary,
            unselectedLabelColor:
                Theme.of(context).colorScheme.secondary.withOpacity(0.6),
            tabs: [
              Obx(
                () => Tab(
                  text: 'decision'.tr,
                  icon: Icon(
                    controller.hasArrivedAtLocation.value
                        ? Icons.check_circle
                        : Icons.location_disabled,
                    color: controller.hasArrivedAtLocation.value
                        ? Theme.of(context)
                            .colorScheme
                            .secondary // Use accent color when active
                        : Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.3), // Use muted accent when disabled
                  ),
                ),
              ),
              Tab(
                text: 'history'.tr,
                icon: Icon(Icons.article,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              Tab(
                text: 'map'.tr,
                icon: Icon(Icons.map,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              if (isMulti)
                Tab(
                  text: 'Lobby',
                  icon: Icon(Icons.groups,
                      color: Theme.of(context).colorScheme.secondary),
                ),
            ],
          ),
        ),
        body: SafeArea(
          child: controller.obx(
            (state) => TabBarView(
              controller: _tabController,
              children: [
                DecisionTab(),
                StoryTab(),
                MapWidget(),
                if (isMulti) LobbyTab(),
              ],
            ),
            onLoading: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            onEmpty: Center(
              child: Text(
                'No gamebook found',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            onError: (error) => Center(
              child: Text(
                error ?? 'Error occurred',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LobbyTab extends StatefulWidget {
  @override
  _LobbyTabState createState() => _LobbyTabState();
}

class _LobbyTabState extends State<LobbyTab> {
  final LobbyController lobbyController = Get.find<LobbyController>();
  final UserService userService = Get.find<UserService>();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  String? userId;

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
  }

  Future<void> getCurrentUserId() async {
    final id = await secureStorage.read(key: 'userId');
    setState(() {
      userId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (userId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Obx(() {
      final sortedUsers =
          List<Map<String, dynamic>>.from(lobbyController.users);
      sortedUsers.sort(
          (a, b) => (a['id_player'] as int).compareTo(b['id_player'] as int));
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'players_in_lobby'.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: sortedUsers.length,
            itemBuilder: (context, index) {
              final id = sortedUsers[index]['id_user'];

              return FutureBuilder<User>(
                future: userService.fetchUserProfile(id.toString()),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final user = snapshot.data!;
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                                ? Text(
                                    user.login.isNotEmpty
                                        ? user.login[0].toUpperCase()
                                        : '?',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.login,
                                  style: theme.textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "ID: ${user.id}",
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 25),
                          Text(
                            sortedUsers[index]['id_player'].toString(),
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: theme.secondaryHeaderColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ))
        ],
      );
    });
  }
}

class GameTitle extends StatelessWidget {
  const GameTitle({
    super.key,
    required this.logger,
    required this.controller,
  });

  final Logger logger;
  final GamePlayController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        logger.i(
            "User wants to see /scenario/${controller.currentGame.value!.idScen}");
        if (controller.currentGame.value == null) return;

        final scenarioId = controller.currentGame.value!.idScen;
        final scenarioLink =
            AppRoutes.scenarioDetail.replaceFirst(":id", scenarioId.toString());
        Get.toNamed(scenarioLink, arguments: controller.currentGame.value);
      },
      child: Obx(() {
        return Text(
          controller.currentGame.value!.scenarioName,
          style: Theme.of(context).textTheme.titleLarge,
        );
      }),
    );
  }
}

class DecisionTab extends StatefulWidget {
  DecisionTab({super.key});

  @override
  State<DecisionTab> createState() => _DecisionTabState();
}

class _DecisionTabState extends State<DecisionTab> {
  final controller = Get.find<GamePlayController>();
  bool _showButtons = false;
  int _devTapCount = 0;
  DateTime? _lastTapTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _showButtons = true);
    });
  }

  void _handleDevModeTap() {
    final now = DateTime.now();
    if (_lastTapTime != null && now.difference(_lastTapTime!) > 2.seconds) {
      _devTapCount = 0; // Reset counter if more than 2 seconds between taps
    }

    _devTapCount++;
    _lastTapTime = now;

    if (_devTapCount >= 5) {
      controller.toggleDevBypassLocation(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.isDevMode
              ? 'Developer mode activated'
              : 'Developer mode deactivated'),
          duration: 2.seconds,
        ),
      );
      _devTapCount = 0;
    }
  }

  Widget _buildSwipeUpIndicator() {
    return TweenAnimationBuilder<Offset>(
      duration: const Duration(milliseconds: 0),
      tween: Tween<Offset>(
        begin: const Offset(0, -0.5),
        end: const Offset(0, 0.5),
      ),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: value * 5,
          child: child,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.keyboard_arrow_up,
            size: 40,
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
          ),
          Text(
            "swipe_up_to_show_buttons".tr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPanelDragHandle(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.keyboard_arrow_down,
          size: 32,
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
        ),
        Text(
          "swipe_down_to_hide_buttons".tr,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontStyle: FontStyle.italic,
              ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDecisionSuccessMessage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 60,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 20),
          Text(
            'decision_recorded'.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
          const SizedBox(height: 15),
          Text(
            'proceed_to_location'.tr,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            icon: Icon(Icons.map,
                color: Theme.of(context).colorScheme.onSecondary),
            label: Text(
              'navigate_to_location'.tr,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            onPressed: () => DefaultTabController.of(context).animateTo(2),
          ),
        ],
      ),
    );
  }

  Widget _buildGameEndScreen(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.celebration,
            size: 60,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 20),
          Text(
            'congratulations'.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
          const SizedBox(height: 15),
          Text(
            'completed_the_game'.tr,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            icon: Icon(Icons.replay,
                color: Theme.of(context).colorScheme.onSecondary),
            label: Text(
              'play_again'.tr,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            onPressed: () => controller.onReturnToSelection(),
          ),
        ],
      ),
    );
  }

  Widget _buildArrivalRequiredMessage(BuildContext context) {
    return GestureDetector(
      onTap: _handleDevModeTap,
      behavior: HitTestBehavior.translucent,
      child: RefreshIndicator(
        onRefresh: () async {
          // This will trigger a location check
          await controller.checkLocation();
        },
        color: Theme.of(context).colorScheme.secondary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_off,
                    size: 50,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "location_required".tr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "location_required_description".tr,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton.icon(
                      icon: Icon(Icons.map,
                          color: Theme.of(context).colorScheme.onSecondary),
                      label: Text(
                        "go_to_map".tr,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      onPressed: () {
                        Get.find<TabController>().animateTo(2);
                      }),
                  const SizedBox(height: 15),
                  Text(
                    "refresh_message".tr,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.7),
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.showPostDecisionMessage.value) {
        return _buildDecisionSuccessMessage(context);
      }
      if (!controller.isDevMode && !controller.hasArrivedAtLocation.value) {
        return _buildArrivalRequiredMessage(context);
      }

      return _buildDecisionContent(context);
    });
  }

  Widget _buildDecisionContent(BuildContext context) {
    final currentStep = controller.currentStep.value;
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.padding.bottom;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: currentStep == null
          ? Center(
              child: Text(
                "No steps available",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          : controller.isGameEnded.value
              ? _buildGameEndScreen(context)
              : _buildMainContent(
                  context,
                  currentStep,
                  bottomPadding,
                ),
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    GameStep currentStep,
    double bottomPadding,
  ) {
    final decisions = currentStep.choices;
    final buttonLayout = Get.find<SettingsController>().layoutStyle.value;

    return Stack(
      children: [
        GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity != null) {
              // Only hide on swipe down
              if (details.primaryVelocity! > 10) {
                setState(() => _showButtons = false);
              }
            }
          },
          child: CustomScrollView(
            physics: _showButtons
                ? const NeverScrollableScrollPhysics()
                : const BouncingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      if (currentStep.photoUrl != null)
                        Flexible(
                          flex: 2,
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(currentStep.photoUrl!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      if (currentStep.title != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            currentStep.title!,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      Expanded(
                        flex: 3,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text(
                                currentStep.text ?? "Game End",
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                              if (decisions.isEmpty) ...[
                                const SizedBox(height: 32),
                                Icon(
                                  Icons.menu_book_rounded,
                                  size: 48,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "your_journey_has_ended".tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Theme.of(context).colorScheme.secondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    Get.find<TabController>().animateTo(1);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondaryContainer,
                                    foregroundColor: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 14),
                                    shadowColor: Colors.black.withOpacity(0.1),
                                  ),
                                  child: Text(
                                    "check_story_tab".tr,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondaryContainer
                                                  .withOpacity(0.9),
                                            ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: decisions.isEmpty ? 0 : 200 + bottomPadding),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        (decisions.isNotEmpty)
            ? AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
                bottom: _showButtons ? 0 : -300,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onVerticalDragEnd: (details) {
                    // Swipe down on buttons to hide
                    if (details.primaryVelocity! > 10) {
                      setState(() => _showButtons = false);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: bottomPadding, left: 16, right: 16, top: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildPanelDragHandle(context),
                        DecisionButtonLayout(
                          decisions: decisions,
                          layoutStyle: buttonLayout,
                          onDecisionMade: (decision) {
                            // setState(() => _showButtons = True);
                            controller.hasArrivedAtLocation.value =
                                false; //important part
                            controller.makeDecision(decision);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),

        // Swipe-up detector when buttons are hidden
        if (!_showButtons && decisions.isNotEmpty)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height *
                0.25, // Capture bottom 25% of screen
            child: GestureDetector(
                onVerticalDragEnd: (details) {
                  // Detect upward swipe (negative velocity)
                  if (details.primaryVelocity! < -10) {
                    setState(() => _showButtons = true);
                  }
                },
                behavior: HitTestBehavior.translucent,
                child: Center(
                  child: _buildSwipeUpIndicator(),
                )),
          ),
      ],
    );
  }
}

class MapWidget extends StatefulWidget {
  //final LatLng initialPosition;
  static const double arrivalRadiusMeters = 20.0;

  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _OSMFlutterMapState();
}

class _OSMFlutterMapState extends State<MapWidget>
    with AutomaticKeepAliveClientMixin {
  late final MapController mapController;
  final GamePlayController gamePlayController = Get.find<GamePlayController>();
  BuildContext? savedTabContext;
  late StreamSubscription<LocationMarkerPosition?> _positionSubscription;
  bool _isMapReady = false;
  final LocationService locationService = Get.find<LocationService>();
  RxString destinationName = ''.obs;
  bool _showDestinationName = false;
  Timer? _destinationNameTimer;
  bool _wasDestinationVisible = false;

  @override
  bool get wantKeepAlive => true;
  bool arrived = false;
  LatLng? currentPosition;
  double currentZoom = 18.0;
  bool _isTracking = false;
  static const double _waypointZoomThreshold = 16.0;
  static const double _arrowPixelOffset = 30.0;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _startTracking();
    _updateDestinationName();

    /*displayUserMarkers({
      '45': LatLng(52.23, 21.01),
      '69': LatLng(50.06, 19.94),
    });*/

    mapController.mapEventStream.listen((event) {
      if (!_isMapReady) {
        setState(() => _isMapReady = true);
      }
    });
  }

  void _updateDestinationName() async {
    if (gamePlayController.waypoints.isNotEmpty) {
      final name =
          await locationService.getPlaceName(gamePlayController.waypoints.last);
      destinationName.value = name;
    } else {
      destinationName.value = '';
    }
  }

  @override
  void didUpdateWidget(covariant MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateDestinationName();
  }

  @override
  void dispose() {
    _destinationNameTimer?.cancel();
    super.dispose();
  }

  void _startTracking() {
    final stream =
        const LocationMarkerDataStreamFactory().fromGeolocatorPositionStream();
    _positionSubscription = stream.listen((position) {
      if (position != null && mounted) {
        setState(() {
          currentPosition = position.latLng;
          // If tracking is enabled, move camera to new position
          if (_isTracking) {
            _moveCamera(position.latLng);
          }
        });
      }
    });
  }

  LatLng _calculateArrowPosition(LatLng start, double bearing) {
    if (!_isMapReady) return start;

    final screenPoint = mapController.camera.project(start);
    final radians = bearing * (math.pi / 180);

    // Calculate offset components
    final dx = _arrowPixelOffset * math.sin(radians);
    final dy = -_arrowPixelOffset * math.cos(radians);

    final newScreenPoint = math.Point(
      screenPoint.x + dx,
      screenPoint.y + dy,
    );

    return mapController.camera.unproject(newScreenPoint);
  }

  Widget _buildWaypointVisualization() {
    if (gamePlayController.waypoints.isEmpty) return const SizedBox.shrink();

    final waypoint = gamePlayController.waypoints.last;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: currentZoom >= _waypointZoomThreshold
          ? _buildDynamicCircle(waypoint)
          : _buildWaypointMarker(waypoint),
    );
  }

  Widget _buildWaypointMarker(LatLng waypoint) {
    return MarkerLayer(
      markers: [
        Marker(
          point: waypoint,
          width: 37,
          height: 37,
          child: Icon(
            Icons.location_pin,
            color: Theme.of(context).colorScheme.secondary,
            size: 40,
          ),
          alignment: Alignment.topCenter,
          rotate: true,
        ),
      ],
    );
  }

  Widget _buildDynamicCircle(LatLng waypoint) {
    final radius = _calculateCircleRadius(waypoint);
    return CircleLayer(
      circles: [
        CircleMarker(
          point: waypoint,
          color: Colors.orange.withOpacity(0.4),
          borderColor: Colors.orange,
          borderStrokeWidth: 2,
          radius: radius,
        ),
      ],
    );
  }

  double _calculateCircleRadius(LatLng point) {
    try {
      const distance = latlong2.Distance();
      final eastPoint =
          distance.offset(point, MapWidget.arrivalRadiusMeters, 90);
      final p1 = mapController.camera.project(point);
      final p2 = mapController.camera.project(eastPoint);
      return (p2.x - p1.x).abs();
    } catch (e) {
      return MapWidget.arrivalRadiusMeters;
    }
  }

  void _moveCamera(LatLng target) {
    mapController.move(target, currentZoom);
  }

  Future<void> moveToCurrentPosition() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      if (position != null) {
        _moveCamera(LatLng(position.latitude, position.longitude));
      }
    } catch (e) {
      debugPrint('Error getting current position: $e');
    }
  }

  void checkDistance(double distance) {
    if (distance > MapWidget.arrivalRadiusMeters ||
        !mounted ||
        arrived ||
        gamePlayController.hasArrivedAtLocation.value) {
      return;
    }

    arrived = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (savedTabContext == null) return;

      showDialog(
        context: savedTabContext!,
        barrierDismissible: false,
        builder: (context) => _buildArrivalDialog(context),
      );
    });
  }

  Widget _buildArrivalDialog(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: theme.colorScheme.primary,
      title: Text(
        "arrived_message".tr,
        style: TextStyle(color: theme.colorScheme.onSurface),
      ),
      content: Text(
        "arrived_message_description".tr,
        style: TextStyle(color: theme.colorScheme.onSurface),
      ),
      actions: [
        TextButton(
          onPressed: () {
            arrived = false;
            gamePlayController.hasArrivedAtLocation.value = true;
            Navigator.of(context).pop();
            if (savedTabContext?.mounted ?? false) {
              Get.find<TabController>().animateTo(0);
            }
          },
          child: Text(
            "continue_playing".tr,
            style: TextStyle(color: theme.colorScheme.secondary),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    savedTabContext = context;
    final colorScheme = Theme.of(context).colorScheme;

    if (currentPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isMapReady) {
        setState(() {}); // Force rebuild after initial layout
      }
    });

    final distance = gamePlayController.waypoints.isEmpty
        ? 0.0
        : const latlong2.Distance().as(
            latlong2.LengthUnit.Meter,
            currentPosition!,
            gamePlayController.waypoints.last,
          );

    checkDistance(distance);

    final bearing = gamePlayController.waypoints.isEmpty
        ? 0.0
        : const latlong2.Distance().bearing(
            currentPosition!,
            gamePlayController.waypoints.last,
          );

    bool isDestinationVisible = false;
    if (_isMapReady) {
      try {
        isDestinationVisible = gamePlayController.waypoints.isNotEmpty &&
            mapController.camera.visibleBounds.contains(
              gamePlayController.waypoints.last,
            );

        // Add this check for programmatic camera moves
        if (isDestinationVisible && !_wasDestinationVisible) {
          _wasDestinationVisible = true;
          _showDestinationName = true;
          _destinationNameTimer?.cancel();
          _destinationNameTimer = Timer(const Duration(seconds: 3), () {
            if (mounted) setState(() => _showDestinationName = false);
          });
        }
      } catch (e) {
        debugPrint('Visibility check error: $e');
      }
    }
    final bool shouldShowDestination =
        isDestinationVisible && currentZoom >= _waypointZoomThreshold;

    if (shouldShowDestination) {
      if (!_wasDestinationVisible) {
        // Destination just became visible - start timer
        _wasDestinationVisible = true;
        _showDestinationName = true;
        _destinationNameTimer?.cancel();
        _destinationNameTimer = Timer(const Duration(seconds: 3), () {
          if (mounted) setState(() => _showDestinationName = false);
        });
      }
    } else {
      if (_wasDestinationVisible) {
        // Destination just left visible area - reset state
        _wasDestinationVisible = false;
        _showDestinationName = false;
        _destinationNameTimer?.cancel();
        _destinationNameTimer = null;
      }
    }
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: currentPosition!,
              initialZoom: currentZoom,
              minZoom: 5,
              maxZoom: 19,
              onPositionChanged: (pos, _) {
                if (!_isMapReady) {
                  setState(() => _isMapReady = true);
                }
                setState(() => currentZoom = pos.zoom);
              },
            ),
            mapController: mapController,
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              CurrentLocationLayer(
                alignPositionOnUpdate:
                    _isTracking ? AlignOnUpdate.always : AlignOnUpdate.never,
                alignDirectionOnUpdate:
                    _isTracking ? AlignOnUpdate.always : AlignOnUpdate.never,
                style: LocationMarkerStyle(
                  marker: DefaultLocationMarker(
                    color: colorScheme.secondary,
                  ),
                  markerDirection: MarkerDirection.heading,
                ),
              ),
              _buildWaypointVisualization(),
              if (distance > MapWidget.arrivalRadiusMeters &&
                  !isDestinationVisible)
                MarkerLayer(
                  markers: [
                    Marker(
                        point:
                            _calculateArrowPosition(currentPosition!, bearing),
                        child: _buildDirectionArrow(bearing, colorScheme)),
                  ],
                ),
              MarkerLayer(
                markers: gamePlayController.userLocations.map((user) {
                  return Marker(
                    point: user.position,
                    width: 40,
                    height: 40,
                    rotate: true,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.secondary,
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: theme.primaryColor,
                        backgroundImage: user.photoUrl != null
                            ? NetworkImage(user.photoUrl!)
                            : null,
                        child: user.photoUrl == null
                            ? Text(
                                user.login.isNotEmpty
                                    ? user.login[0].toUpperCase()
                                    : '?',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          // Show destination name at the top only if the destination is visible and the detailed circle is shown (zoomed in)
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Obx(
              () => AnimatedOpacity(
                opacity:
                    destinationName.value.isNotEmpty && _showDestinationName
                        ? 1.0
                        : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: colorScheme.surface.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Text(
                              destinationName.value,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                              softWrap: true,
                              overflow: TextOverflow
                                  .visible, // Allow text to expand vertically
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Tutorial button (only when name isn't showing)
          if (!_showDestinationName)
            Positioned(
              top: 20,
              right: 20,
              child: FloatingActionButton.small(
                heroTag: 'map_tutorial',
                backgroundColor: colorScheme.surface,
                foregroundColor: colorScheme.secondary,
                child: const Icon(Icons.help_outline),
                onPressed: () => _showMapTutorial(context, colorScheme),
                tooltip: 'Map tutorial',
              ),
            ),
          _buildControlButtons(colorScheme),
          _buildDistanceIndicator(distance, colorScheme),
          // Tutorial/help button - hide when place name is shown
          if (!isDestinationVisible || currentZoom < _waypointZoomThreshold)
            Positioned(
              top: 20,
              right: 20,
              child: FloatingActionButton.small(
                heroTag: 'map_tutorial',
                backgroundColor: colorScheme.surface,
                foregroundColor: colorScheme.secondary,
                child: const Icon(Icons.help_outline),
                onPressed: () => _showMapTutorial(context, colorScheme),
                tooltip: 'Map tutorial',
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDirectionArrow(double bearing, ColorScheme colorScheme) {
    return Transform.rotate(
      angle: bearing * (math.pi / 180),
      child: Icon(
        Icons.navigation,
        color: colorScheme.secondary,
        size: 32,
        shadows: [
          Shadow(
            color: colorScheme.primary.withOpacity(0.8),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons(ColorScheme colorScheme) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            backgroundColor: colorScheme.primary,
            onPressed: () {
              mapController.rotate(0.0);
            },
            child: Transform.rotate(
              angle: 135 * pi / 180,
              child: Icon(
                Icons.explore,
                color: colorScheme.secondary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'tracking',
            backgroundColor: colorScheme.primary,
            onPressed: () {
              setState(() {
                _isTracking = !_isTracking;
                if (_isTracking && currentPosition != null) {
                  _moveCamera(currentPosition!);
                }
              });
            },
            child: Icon(
              _isTracking ? Icons.gps_fixed : Icons.gps_not_fixed,
              color: colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceIndicator(double distance, ColorScheme colorScheme) {
    final distancePadded =
        math.max(0, distance - MapWidget.arrivalRadiusMeters);
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      bottom: gamePlayController.waypoints.isNotEmpty ? 20 : -100,
      left: 20,
      child: Material(
        borderRadius: BorderRadius.circular(8),
        elevation: 4,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            setState(() {
              _isTracking = false;
              if (gamePlayController.waypoints.isNotEmpty) {
                _moveCamera(gamePlayController.waypoints.last);
                _wasDestinationVisible = false;
                _showDestinationName = false;
                _destinationNameTimer?.cancel();
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Text(
                  '${distancePadded.toStringAsFixed(0)} m',
                  style: TextStyle(
                    color: colorScheme.secondary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.location_on,
                  color: colorScheme.secondary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMapTutorial(BuildContext context, ColorScheme colorScheme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      isScrollControlled: true, // Allow full screen height if needed
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6, // Start at 60% of screen height
        minChildSize: 0.3, // Min 30% of screen height
        maxChildSize: 0.9, // Max 90% of screen height
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.help_outline,
                        color: colorScheme.secondary, size: 28),
                    const SizedBox(width: 12),
                    Text('map_tutorial'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: colorScheme.secondary)),
                  ],
                ),
                const SizedBox(height: 20),
                _tutorialItem(Icons.touch_app, 'one_finger_drag'.tr),
                _tutorialItem(Icons.zoom_in, 'zoom_in_out'.tr),
                _tutorialItem(Icons.gps_fixed, 'gps_button'.tr),
                _tutorialItem(Icons.navigation, 'navigation_arrow'.tr),
                _tutorialItem(Icons.location_pin, 'pin_or_circle'.tr),
                _tutorialItem(Icons.label, 'destination_name'.tr),
                _tutorialItem(Icons.explore, 'compass_click'.tr),
                _tutorialItem(Icons.location_on, 'distance_label'.tr),
                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom +
                          MediaQuery.of(context).padding.bottom +
                          16),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('got_it'.tr),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tutorialItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class StoryTab extends StatelessWidget {
  StoryTab({super.key});
  final controller = Get.find<GamePlayController>();
  final ScrollController _scrollController = ScrollController();
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy • HH:mm');
  final LocationService locationService = Get.find<LocationService>();

  @override
  Widget build(BuildContext context) {
    ever(controller.gameHistory, (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.minScrollExtent);
        }
      });
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(() {
        if (controller.isHistoryLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ),
          );
        }

        // Filter out entries where previousStepText is null
        final filteredHistory = controller.gameHistory
            .where((entry) => entry.previousStep != null)
            .toList();

        final hasCurrentStep = controller.currentStep.value != null;

        if (filteredHistory.isEmpty && !hasCurrentStep) {
          return Center(
            child: Text(
              'history_text'.tr,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
              textAlign: TextAlign.center,
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          reverse: true,
          physics: const BouncingScrollPhysics(),
          itemCount: filteredHistory.length + (hasCurrentStep ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == 0 && hasCurrentStep) {
              return _buildCurrentStep(context, controller.currentStep.value!);
            }
            final historyIndex = index - (hasCurrentStep ? 1 : 0);
            final entry =
                filteredHistory[filteredHistory.length - 1 - historyIndex];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (historyIndex == 0) _buildTimelineStart(context),
                _buildStoryEntry(context, entry),
                if (historyIndex != filteredHistory.length - 1)
                  _buildTimelineConnector(context),
              ],
            );
          },
        );
      }),
    );
  }

  Widget _buildStoryEntry(BuildContext context, GameHistoryRecord entry) {
    final location =
        LatLng(entry.currentStep.latitude, entry.currentStep.longitude);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _dateFormatter.format(entry.startDate),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        entry.previousStep?.text ?? entry.currentStep.text,
                        softWrap: true,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              height: 1.5,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                FutureBuilder<String>(
                  future: locationService.getPlaceName(location),
                  builder: (context, snapshot) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              snapshot.data ??
                                  locationService.formatCoordinates(location),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                if (entry.choice?.text != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: entry.user.photoUrl != null
                              ? NetworkImage(entry.user.photoUrl!)
                              : null,
                          child: entry.user.photoUrl == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.user.login,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                              ),
                              Text(
                                entry.choice!.text,
                                softWrap: true,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStart(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.star_rounded,
            color: Theme.of(context).colorScheme.secondary, size: 24),
        const SizedBox(height: 8),
        Container(
          width: 2,
          height: 20,
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ],
    );
  }

  Widget _buildTimelineConnector(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          width: 2,
          height: 20,
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ],
    );
  }

  Widget _buildCurrentStep(BuildContext context, GameStep currentStep) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 24.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentStep.text ?? 'awaiting_decision'.tr,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
This is different look for StoryTab don't remove
*/
// class StoryTab extends StatelessWidget {
//   StoryTab({super.key});
//   final controller = Get.find<GamePlayController>();
//   final ScrollController _scrollController = ScrollController();
//   final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy • HH:mm');

//   @override
//   Widget build(BuildContext context) {
//     ever(controller.gameHistory, (_) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (_scrollController.hasClients) {
//           _scrollController.jumpTo(_scrollController.position.minScrollExtent);
//         }
//       });
//     });

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Obx(() {
//         if (controller.isHistoryLoading.value) {
//           return Center(
//             child: CircularProgressIndicator(
//               color: Theme.of(context).colorScheme.secondary,
//             ),
//           );
//         }

//         if (controller.gameHistory.isEmpty) {
//           return Center(
//             child: Text(
//               "Your chronicle awaits...\nDecisions will etch themselves here.",
//               style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                     color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
//                   ),
//               textAlign: TextAlign.center,
//             ),
//           );
//         }

//         return ListView.builder(
//           controller: _scrollController,
//           reverse: true,
//           physics: const BouncingScrollPhysics(),
//           itemCount: controller.gameHistory.length,
//           itemBuilder: (context, index) {
//             final entry = controller.gameHistory[controller.gameHistory.length - 1 - index];
//             final isStartEntry = entry.previousStepText == null;

//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // Date header
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: Text(
//                       _dateFormatter.format(entry.startDate),
//                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                             color: Theme.of(context).colorScheme.tertiary,
//                             letterSpacing: 0.3,
//                           ),
//                     ),
//                   ),

//                   // Story content
//                   Container(
//                     decoration: BoxDecoration(
//                       border: Border(
//                         left: BorderSide(
//                           color: Theme.of(context).colorScheme.secondary,
//                           width: 2.0,
//                         ),
//                       ),
//                     ),
//                     padding: const EdgeInsets.only(left: 16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         // Main story text
//                         Text(
//                           entry.previousStepText ?? "The first page turns...",
//                           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                                 color: Theme.of(context).colorScheme.onSurface,
//                                 height: 1.6,
//                               ),
//                         ),

//                         // Decision indicator
//                         if (entry.choiceText != null) ...[
//                           const SizedBox(height: 12),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Icon(
//                                 Icons.arrow_right_alt_rounded,
//                                 color: Theme.of(context).colorScheme.secondary,
//                                 size: 20,
//                               ),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   entry.choiceText!,
//                                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                                         color: Theme.of(context).colorScheme.secondary,
//                                         fontStyle: FontStyle.italic,
//                                       ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }
