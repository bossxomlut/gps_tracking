import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_speed/base_presentation/cubit/event_mixin.dart';
import 'package:gps_speed/base_presentation/page/base_page.dart';
import 'package:gps_speed/feature/setting/cubit/unit_cubit.dart';
import 'package:gps_speed/feature/tracking_speed/cubit/location_service_cubit.dart';
import 'package:gps_speed/feature/tracking_speed/cubit/tracking_cubit.dart';
import 'package:gps_speed/feature/tracking_speed/cubit/tracking_event.dart';
import 'package:gps_speed/feature/tracking_speed/cubit/tracking_state.dart';
import 'package:gps_speed/feature/tracking_speed/widgets/button.dart';
import 'package:gps_speed/feature/tracking_speed/widgets/cycling_background.dart';
import 'package:gps_speed/util/gps/gps.dart';
import 'package:gps_speed/util/timer/custom_timer.dart';
import 'package:gps_speed/widget/button/go_button.dart';
import 'package:gps_speed/widget/gps_icon_widget.dart';
import 'package:gps_speed/widget/request_permission_dialog/request_location_permission_dialog.dart';
import 'package:gps_speed/widget/request_permission_dialog/request_location_service_dialog.dart';

const Duration _switcherDuration = Duration(milliseconds: 800);

class SpeedPage extends StatefulWidget {
  const SpeedPage({super.key});

  @override
  State<SpeedPage> createState() => _SpeedPageState();
}

class _SpeedPageState extends BasePageState<SpeedPage> {
  final PositionTrackingMovingCubit trackingMovingCubit = PositionTrackingMovingCubit();

  @override
  void initState() {
    super.initState();
    trackingMovingCubit.init().then((value) {}).catchError((error) {
      if (error is GPSException) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return LocationServiceWrapper(
      child: BlocListener<LocationServiceCubit, LocationServiceState>(
        listener: (context, state) {
          if (!state.isGranted || !state.isEnableService) {
            switch (trackingMovingCubit.state) {
              case InProgressTrackingMovingState():
                trackingMovingCubit.pause();
                break;
              case ReadyTrackingMovingState():
              case PauseTrackingMovingState():
              case StopTrackingMovingState():
            }
          }
        },
        child: BlocProvider(
          create: (_) => trackingMovingCubit,
          child: super.build(context),
        ),
      ),
    );
  }

  // @override
  // PreferredSizeWidget? buildAppBar(BuildContext context) {
  //   if (MediaQuery.of(context).orientation == Orientation.portrait) {
  //     return AppBar(
  //       centerTitle: true,
  //       title: Builder(builder: (context) {
  //         return Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             BlocBuilder<PositionTrackingMovingCubGPS_SPEED__1_-removebg-preview.pngit, TrackingMovingState>(
  //                 buildWhen: _buildWhen,
  //                 builder: (c, s) {
  //                   if (s is ReadyTrackingMovingState) {
  //                     return const SizedBox();
  //                   }
  //                   return StreamBuilder(
  //                       stream: context.read<PositionTrackingMovingCubit>().timerStream,
  //                       builder: (c, d) {
  //                         if (d.hasData) {
  //                           final duration = d.data!;
  //
  //                           return Text(duration.getMinuteFormat());
  //                         }
  //                         return const SizedBox();
  //                       });
  //                 }),
  //           ],
  //         );
  //       }),
  //     );
  //   }
  //   return null;
  // }

  bool _buildWhen(TrackingMovingState p, TrackingMovingState c) {
    return (p is ReadyTrackingMovingState && c is! ReadyTrackingMovingState) ||
        (c is ReadyTrackingMovingState && p is! ReadyTrackingMovingState);
  }

  @override
  Widget buildBody(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<PositionTrackingMovingCubit, TrackingMovingState>(
          buildWhen: _buildWhen,
          builder: (context, state) {
            if (state is ReadyTrackingMovingState) {
              return buildGoButton(context);
            }

            return buildTrackingView();
          },
        ),
      ),
    );
  }

  AnimatedSwitcher buildGoButton(BuildContext context) {
    return AnimatedSwitcher(
      duration: _switcherDuration,
      child: CyclingBackground(
        child: Center(
          child: GoButton(
            onTap: () {
              final LocationServiceCubit locationServiceCubit = context.read<LocationServiceCubit>();
              if (locationServiceCubit.canStart()) {
                trackingMovingCubit.start();
              } else {
                locationServiceCubit.requestPermissions();
              }
            },
          ),
        ),
      ),
    );
  }

  AnimatedSwitcher buildTrackingView() {
    return AnimatedSwitcher(
      duration: _switcherDuration,
      child: OrientationBuilder(builder: (context, orientation) {
        switch (orientation) {
          case Orientation.portrait:
            return Column(
              children: [
                Expanded(
                  child: CyclingBackground(
                    child: Center(
                      child: BlocSelector<PositionTrackingMovingCubit, TrackingMovingState, double>(
                        selector: (state) => state.currentSpeed,
                        builder: (context, speed) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                child: Text(
                                  "${context.read<UnitCubit>().getSpeedSymbol()}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(fontSize: 40, color: Colors.grey.withOpacity(0.3)),
                                ),
                                alignment: FractionalOffset(0.5, 0.8),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                        fontSize: 180,
                                      ),
                                  text: "${speed.toStringAsFixed(0)}",
                                  children: [
                                    // TextSpan(
                                    //   text: "${context.read<UnitCubit>().getSpeedSymbol()}",
                                    //   style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    //         fontSize: 20,
                                    //       ),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                _MovingInfo(),
                _MovingController(),
              ],
            );
          case Orientation.landscape:
            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CyclingBackground(
                    child: Center(
                      child: BlocSelector<PositionTrackingMovingCubit, TrackingMovingState, double>(
                        selector: (state) => state.currentSpeed,
                        builder: (context, speed) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                child: Text(
                                  "${context.read<UnitCubit>().getSpeedSymbol()}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(fontSize: 40, color: Colors.grey.withOpacity(0.3)),
                                ),
                                alignment: FractionalOffset(0.5, 0.8),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                        fontSize: 180,
                                      ),
                                  text: "${speed.toStringAsFixed(0)}",
                                  children: [
                                    // TextSpan(
                                    //   text: "${context.read<UnitCubit>().getSpeedSymbol()}",
                                    //   style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    //         fontSize: 20,
                                    //       ),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _HMovingInfo(),
                        _MovingController(),
                      ],
                    )),
              ],
            );
        }
      }),
    );
  }
}

class LocationServiceWrapper extends StatefulWidget {
  const LocationServiceWrapper({super.key, required this.child});

  final Widget child;

  @override
  State<LocationServiceWrapper> createState() => _LocationServiceWrapperState();
}

class _LocationServiceWrapperState extends State<LocationServiceWrapper>
    with EventStateMixin<LocationServiceWrapper, LocationServiceEvent> {
  @override
  Stream<LocationServiceEvent> get eventStream => context.read<LocationServiceCubit>().$eventStream;

  @override
  void eventListener(LocationServiceEvent event) {
    switch (event) {
      case DisableLocationServiceEvent():
        RequestLocationServiceDialog(
          onEnableLocationService: (bool isEnable) {},
        ).show(context);
        break;

      case DeniedLocationPermissionEvent():
        GPSUtil.instance.requestLocationPermission().then((value) {}).catchError((error) {
          print('error: ${error}');
        });
        break;

      case DeniedForeverLocationPermissionEvent():
        RequestLocationPermissionDialog(
          onEnableLocationPermission: (value) {},
        ).show(context).then((value) {});

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        const SafeArea(
            child: Padding(
          padding: EdgeInsets.all(8.0),
          child: LocationServiceInfoWidget(),
        )),
      ],
    );
  }
}

class _MovingInfo extends StatelessWidget {
  const _MovingInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final UnitCubit unitCubit = context.read<UnitCubit>();

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.highlightColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: BlocBuilder<PositionTrackingMovingCubit, TrackingMovingState>(builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _TitleAndContent(
                    title: "Avg Speed",
                    content: unitCubit.getSpeedString(state.averageSpeed, fractionDigits: 1),
                  ),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.white12,
                ),
                Expanded(
                  child: _TitleAndContent(
                    title: "Distance (${unitCubit.getDistanceSymbol()})",
                    content: unitCubit.getDistanceString(state.totalDistance),
                  ),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.white12,
                ),
                Expanded(
                  child: _TitleAndContent(
                    title: "Max Speed",
                    content: unitCubit.getSpeedString(state.maxSpeed, fractionDigits: 1),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class _HMovingInfo extends StatelessWidget {
  const _HMovingInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final UnitCubit unitCubit = context.read<UnitCubit>();

    return BlocBuilder<PositionTrackingMovingCubit, TrackingMovingState>(builder: (context, state) {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.highlightColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _TitleAndContent(
                    title: "Avg Speed",
                    content: unitCubit.getSpeedString(state.averageSpeed, fractionDigits: 1),
                  ),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.white12,
                ),
                Expanded(
                  child: _TitleAndContent(
                    title: "Max Speed",
                    content: unitCubit.getSpeedString(state.maxSpeed, fractionDigits: 1),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.highlightColor,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: _TitleAndContent(
              title: "Distance (${unitCubit.getDistanceSymbol()})",
              content: unitCubit.getDistanceString(state.totalDistance),
            ),
          ),
        ],
      );
    });
  }
}

class _MovingController extends StatelessWidget {
  const _MovingController({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PositionTrackingMovingCubit, TrackingMovingState>(
      builder: (context, state) {
        switch (state) {
          case ReadyTrackingMovingState():
            return PlayButton(
              onTap: () async {
                if (context.read<LocationServiceCubit>().canStart()) {
                  context.read<PositionTrackingMovingCubit>().start();
                } else {
                  context.read<LocationServiceCubit>().requestPermissions();
                }
              },
            );

          case InProgressTrackingMovingState():
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PauseButton(
                  onTap: () {
                    context.read<PositionTrackingMovingCubit>().pause();
                  },
                ),
                const SizedBox(width: 16),
                StopButton(
                  onTap: () {
                    context.read<PositionTrackingMovingCubit>().stop();
                  },
                ),
              ],
            );
          case PauseTrackingMovingState():
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlayButton(
                  onTap: () async {
                    if (context.read<LocationServiceCubit>().canStart()) {
                      context.read<PositionTrackingMovingCubit>().resume();
                    } else {
                      context.read<LocationServiceCubit>().requestPermissions();
                    }
                  },
                ),
                const SizedBox(width: 16),
                StopButton(
                  onTap: () {
                    context.read<PositionTrackingMovingCubit>().stop();
                  },
                ),
              ],
            );

          case StopTrackingMovingState():
            return CycleButton(
              backgroundColor: Theme.of(context).highlightColor,
              onTap: () {
                context.read<PositionTrackingMovingCubit>().reset();
              },
              child: Container(
                width: 76,
                height: 76,
                alignment: Alignment.center,
                child: Text(
                  "Reset",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            );
            return ElevatedButton(
              onPressed: () {
                context.read<PositionTrackingMovingCubit>().reset();
              },
              child: Text("Reset"),
            );
        }
      },
    );
  }
}

class _TitleAndContent extends StatelessWidget {
  const _TitleAndContent({super.key, required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          title,
          style: textTheme.labelLarge,
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
