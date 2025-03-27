import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotale/app/controllers/gameplay_controller.dart';
import 'package:gotale/app/controllers/settings_controller.dart';
import 'package:gotale/app/models/game_history_record.dart';
import 'package:gotale/app/models/game_step.dart';
import 'package:gotale/app/routes/app_routes.dart';
import 'package:gotale/app/ui/widgets/decision_buttons.dart';
import 'package:intl/intl.dart';
import 'package:logger/web.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

/*
- TODO: the game should have in top left corner somekind of icon/title that is
  clickable and allows to see main page of given game
- TODO: list players that participate in given game (only in version 3.0)
- TODO: remember game after switching tabs.
- TODO: maybe show skeleton instead of loading circle
 */
class GamePlayScreen extends StatelessWidget {
  final GamePlayController controller = Get.find();
  final Logger logger = Get.find<Logger>();
  final VoidCallback onReturnToSelection;

  GamePlayScreen({required this.onReturnToSelection});

  @override
  Widget build(BuildContext context) {
    final gamebookId = Get.parameters['id']!;
    controller.fetchGameWithId(int.parse(gamebookId));

    logger.i("[DEV_DEBUG] GamePlayScreen built with gamebookId: $gamebookId");
    logger.d("[DEV_DEBUG] Current gamebook: ${controller.currentGame.value}");
    logger.d("[DEV_DEBUG] Current step: ${controller.currentStep.value}");

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
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app,
                  color: Theme.of(context).colorScheme.secondary),
              onPressed: onReturnToSelection,
            ),
          ],
        ),
        body: controller.obx(
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

class DecisionTab extends StatelessWidget {
  DecisionTab({super.key});
  final controller = Get.find<GamePlayController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.showPostDecisionMessage.value) {
        return _buildDecisionSuccessMessage(context);
      }

      // TODO: uncomment in production
      // if (!controller.hasArrivedAtLocation.value) {
      //   return _buildArrivalRequiredMessage(context);
      // }
      return _buildDecisionContent(context);
    });
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

  Widget _buildArrivalRequiredMessage(BuildContext context) {
    return Center(
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
    );
  }

  Widget _buildDecisionContent(BuildContext context) {
    final currentStep = controller.currentStep.value;
    if (currentStep == null) {
      return Center(
        child: Text(
          "No steps available",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    // Check if game has ended
    if (controller.isGameEnded.value) {
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

    final decisions = currentStep.choices;
    final buttonLayout = Get.find<SettingsController>().layoutStyle.value;

    if (decisions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Text(
                  currentStep.text ?? "Game End",
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              // onPressed: () => controller
              //     .fetchGamebookData(controller.currentGamebook.value!.id),
              onPressed: () {
                throw UnimplementedError(
                    'starting from scratch is not implemented yet');
              },
              child: Text(
                "Start From the Beginning",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Text(
                currentStep.text ?? "Game End",
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: DecisionButtonLayout(
              decisions: decisions,
              layoutStyle: buttonLayout,
              onDecisionMade: controller.makeDecision,
            ),
          ),
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

/*class MapWidget extends StatelessWidget {
  const MapWidget({super.key});
*/

class _OSMFlutterMapState extends State<MapWidget>
    with AutomaticKeepAliveClientMixin {
  late MapController mapController;

  final GamePlayController gamePlayController = Get.find<GamePlayController>();

  @override
  bool get wantKeepAlive => true;

  LatLng? currentPosition;
  double currentZoom = 8.0;
  List<Marker> markers = [];
  double distanceToWaypoint = 0;
  @override
  void initState() {
    super.initState();
    mapController = MapController();

    _startTracking();
  }

  void _startTracking() {
    final stream =
        const LocationMarkerDataStreamFactory().fromGeolocatorPositionStream();

    stream.listen((LocationMarkerPosition? position) {
      if (position != null) {
        setState(() {
          currentPosition = position.latLng;
        });
      }
    });
  }

  void moveToCurrentPosition() async {
    final stream =
        const LocationMarkerDataStreamFactory().fromGeolocatorPositionStream();

    final LocationMarkerPosition? position = await stream.first;

    if (position != null) {
      mapController.move(position.latLng, currentZoom);
    }
  }

  void addWaypoint(LatLng point, Color markerColor) {
    setState(() {
      /*print(markers.length);
      markers.clear();
      markers.add(
        Marker(
          point: point,
          width: 37,
          height: 37,
          rotate: true,
          //anchorPos: AnchorPos.align(AnchorAlign.center),
          child: Icon(
            Icons.location_pin,
            color: markerColor, //Colors.red,
            size: 40,
          ),
          alignment: Alignment.topCenter,
          //anchorPos: const Offset(0.5, 0.5)
        ),
      );*/

      gamePlayController.waypoints.add(point);
    });
  }

  double calculateDistance(LatLng point1, LatLng point2) {
    final Distance distance = const Distance();
    return distance.as(LengthUnit.Meter, point1, point2);
  }
/*
  void updatePosition(LatLng position)
  {
    setState(() {
      currentPosition = position;
    });
  }*/

  //bool isLocationPressed = false;
  bool isTracking = false;
  bool headingReset = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      Color secondaryColor = Theme.of(context).colorScheme.secondary;
      Color primaryColor = Theme.of(context).colorScheme.primary;

      final double distanceToWaypoint =
          (currentPosition != null && gamePlayController.waypoints.isNotEmpty)
              ? calculateDistance(
                  currentPosition!, gamePlayController.waypoints.last)
              : 0.0;

      return Scaffold(
        body: Stack(children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(52.06516, 19.25248),
              initialZoom: 7,
              minZoom: 0,
              maxZoom: 19,
              onLongPress: (tapPosition, point) {
                addWaypoint(point, secondaryColor);
              },
              onPositionChanged: (position, hasGesture) {
                setState(() {
                  currentZoom = position.zoom;
                });
              },
            ),
            mapController: mapController,
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName:
                    'net.tlserver6y.flutter_map_location_marker.example',
                maxZoom: 19,
              ),
              if (isTracking)
                CurrentLocationLayer(
                  alignPositionOnUpdate: AlignOnUpdate.once,
                  alignDirectionOnUpdate: AlignOnUpdate.never,
                  style: LocationMarkerStyle(
                    marker: DefaultLocationMarker(),
                    markerDirection: MarkerDirection.heading,
                  ),
                ),
              MarkerLayer(
                markers: gamePlayController.waypoints.map((waypoint) {
                  return Marker(
                    point: waypoint,
                    width: 37,
                    height: 37,
                    rotate: true,
                    child: Icon(
                      Icons.location_pin,
                      color: Get.theme.colorScheme.secondary, //Colors.red,
                      size: 40,
                    ),
                    alignment: Alignment.topCenter,
                  );
                }).toList(),
              ),
            ],
          ),
          Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                backgroundColor: isTracking ? primaryColor : secondaryColor,
                onPressed: () {
                  //backgroundColor: Colors.blue;

                  //print("thing happened");

                  setState(() {
                    isTracking = !isTracking;
                  });
                },
                child: Icon(
                  isTracking
                      ? Icons.location_searching
                      : Icons.location_disabled,
                  color: isTracking ? secondaryColor : primaryColor,
                ),
              )),
          Positioned(
              bottom: 100,
              right: 20,
              child: FloatingActionButton(
                backgroundColor: isTracking ? primaryColor : secondaryColor,
                onPressed: () {
                  //print("another thing happened");

                  if (isTracking) {
                    moveToCurrentPosition();
                  }
                },
                child: Icon(
                  isTracking ? Icons.location_on : Icons.location_off,
                  color: isTracking ? secondaryColor : primaryColor,
                ),
              )),
          Positioned(
              bottom: 180,
              right: 20,
              child: FloatingActionButton(
                backgroundColor: isTracking ? primaryColor : secondaryColor,
                onPressed: () {
                  markers.clear();
                  mapController.rotate(0.0);
                },
                child: Transform.rotate(
                  angle: 135 * pi / 180,
                  child: Icon(
                    Icons.explore,
                    color: isTracking ? secondaryColor : primaryColor,
                  ),
                ),
              )),
          AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom:
                  isTracking && gamePlayController.waypoints.isNotEmpty == true
                      ? 20
                      : -100,
              left: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ]),
                child: Text(
                  '${distanceToWaypoint.toStringAsFixed(0)} m',
                  //'${currentPosition!.latitude.toStringAsFixed(4)}, ${currentPosition!.longitude.toStringAsFixed(4)}',
                  style: TextStyle(color: secondaryColor, fontSize: 16),
                ),
              )),
        ]),
      );
    });
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
                        .onBackground
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
                    Text(
                      entry.previousStepText!,
                      softWrap: true,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            height: 1.5,
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
