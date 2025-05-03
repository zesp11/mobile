import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/gameplay_controller.dart';
import 'package:gotale/app/controllers/settings_controller.dart';
import 'package:gotale/app/models/game_history_record.dart';
import 'package:gotale/app/models/game_step.dart';
import 'package:gotale/app/routes/app_routes.dart';
import 'package:gotale/app/ui/widgets/decision_buttons.dart';
import 'package:intl/intl.dart';
import 'package:logger/web.dart';
import 'package:latlong2/latlong.dart' as latlong2;
import 'dart:math' as math;

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

class GamePlayScreen extends StatelessWidget {
  final GamePlayController controller = Get.find();
  final Logger logger = Get.find<Logger>();

  GamePlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gamebookId = Get.parameters['id']!;
    controller.fetchGameWithId(int.parse(gamebookId));

    final TabController tabController =
        TabController(length: 3, vsync: Navigator.of(context));

    Get.put(tabController);

    logger.i("[DEV_DEBUG] GamePlayScreen built with gamebookId: $gamebookId");
    logger.d("Current gamebook: ${controller.currentGame.value}");
    logger.d("Current step: ${controller.currentStep.value}");

    return DefaultTabController(
      length: 3,
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
            ],
          ),
        ),
        body: SafeArea(
          child: controller.obx(
            (state) => TabBarView(
              children: [
                DecisionTab(),
                StoryTab(),
                MapWidget(),
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
  int _devSwipeCount = 0;
  DateTime? _lastSwipeTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _showButtons = true);
    });
  }

  void _handleDevModeSwipe(DragEndDetails details) {
    final now = DateTime.now();
    if (_lastSwipeTime != null && now.difference(_lastSwipeTime!) > 2.seconds) {
      _devSwipeCount = 0; // Reset counter if more than 2 seconds between swipes
    }

    if (details.primaryVelocity != null && details.primaryVelocity! > 1000) {
      _devSwipeCount++;
      _lastSwipeTime = now;

      if (_devSwipeCount >= 5) {
        controller.toggleDevBypassLocation(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.isDevMode
                ? 'Developer mode activated'
                : 'Developer mode deactivated'),
            duration: 2.seconds,
          ),
        );
        _devSwipeCount = 0;
      }
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
            "Swipe up for choices",
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
          "Swipe down to close",
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
            "Decision Recorded!",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
          const SizedBox(height: 15),
          Text(
            "Proceed to the next location\nto continue your adventure",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            icon: Icon(Icons.map,
                color: Theme.of(context).colorScheme.onSecondary),
            label: Text(
              "Navigate to Next Location",
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
            "Congratulations!",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
          const SizedBox(height: 15),
          Text(
            "You have completed the game",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            icon: Icon(Icons.replay,
                color: Theme.of(context).colorScheme.onSecondary),
            label: Text(
              "Play Again",
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
      onVerticalDragEnd: _handleDevModeSwipe,
      behavior: HitTestBehavior.translucent,
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
              "Location Required",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              "Confirm your arrival at the current location\nin the Map tab to continue",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              icon: Icon(Icons.map,
                  color: Theme.of(context).colorScheme.onSecondary),
              label: Text(
                "Go to Map",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              onPressed: () => DefaultTabController.of(context).animateTo(2),
            ),
          ],
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
                          child: Text(
                            currentStep.text ?? "Game End",
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
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
        if (decisions.isNotEmpty)
          AnimatedPositioned(
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
                        controller.makeDecision(decision);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
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

  @override
  bool get wantKeepAlive => true;
  bool arrived = false;
  LatLng? currentPosition;
  double currentZoom = 14.0;
  bool _isTracking = false;
  static const double _waypointZoomThreshold = 16.0;
  static const double _arrowOffsetDistance = 10.0;
  static const double _arrivalRadiusMeters = 50.0;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _startTracking();
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
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
    const distance = latlong2.Distance();
    return distance.offset(start, _arrowOffsetDistance, bearing);
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
          color: Colors.orange.withOpacity(0.3),
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
      final eastPoint = distance.offset(point, _arrivalRadiusMeters, 90);
      final p1 = mapController.camera.project(point);
      final p2 = mapController.camera.project(eastPoint);
      return (p2.x - p1.x).abs();
    } catch (e) {
      return _arrivalRadiusMeters;
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
    if (distance > _arrivalRadiusMeters ||
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
        "You've arrived!",
        style: TextStyle(color: theme.colorScheme.onSurface),
      ),
      content: Text(
        "Proceed with your adventure.",
        style: TextStyle(color: theme.colorScheme.onSurface),
      ),
      actions: [
        TextButton(
          onPressed: () {
            gamePlayController.hasArrivedAtLocation.value = true;
            Navigator.of(context).pop();
            if (savedTabContext?.mounted ?? false) {
              DefaultTabController.of(savedTabContext!).animateTo(0);
            }
          },
          child: Text(
            "Continue",
            style: TextStyle(color: theme.colorScheme.secondary),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    savedTabContext = context;
    final colorScheme = Theme.of(context).colorScheme;

    if (currentPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

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

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: currentPosition!,
              initialZoom: currentZoom,
              minZoom: 5,
              maxZoom: 19,
              onPositionChanged: (pos, _) =>
                  setState(() => currentZoom = pos.zoom),
            ),
            mapController: mapController,
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              CurrentLocationLayer(
                alignPositionOnUpdate: AlignOnUpdate.never,
                alignDirectionOnUpdate: AlignOnUpdate.never,
                style: LocationMarkerStyle(
                  marker: DefaultLocationMarker(
                    color: colorScheme.secondary,
                  ),
                  markerDirection: MarkerDirection.heading,
                ),
              ),
              _buildWaypointVisualization(),
              if (distance > _arrivalRadiusMeters)
                MarkerLayer(
                  markers: [
                    Marker(
                        point:
                            _calculateArrowPosition(currentPosition!, bearing),
                        child: _buildDirectionArrow(bearing, colorScheme)),
                  ],
                ),
            ],
          ),
          _buildControlButtons(colorScheme),
          _buildDistanceIndicator(distance, colorScheme),
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
              _isTracking =
                  false; // Disable tracking when focusing on destination
              if (gamePlayController.waypoints.isNotEmpty) {
                _moveCamera(gamePlayController.waypoints.last);
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Text(
                  '${distance.toStringAsFixed(0)} m',
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
}

class StoryTab extends StatelessWidget {
  StoryTab({super.key});
  final controller = Get.find<GamePlayController>();
  final ScrollController _scrollController = ScrollController();
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy • HH:mm');

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
            .where((entry) => entry.previousStepText != null)
            .toList();

        final hasCurrentStep = controller.currentStep.value != null;

        if (filteredHistory.isEmpty && !hasCurrentStep) {
          return Center(
            child: Text(
              "Your story begins here...\nMake choices to fill this page.",
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

  // Removed isStartEntry parameter as it's no longer needed
  Widget _buildStoryEntry(BuildContext context, GameHistoryRecord entry) {
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
                        entry.previousStepText!,
                        softWrap: true,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              height: 1.5,
                            ),
                      ),
                    ),
                  ],
                ),
                if (entry.choiceText != null) ...[
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
                                entry.choiceText!,
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
              currentStep.text ?? "Awaiting your next decision...",
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
