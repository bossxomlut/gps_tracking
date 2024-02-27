import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_convert/base_presentation/page/base_page.dart';
import 'package:mp3_convert/feature/tracking_speed/cubit/tracking_cubit.dart';
import 'package:mp3_convert/feature/tracking_speed/widgets/button.dart';
import 'package:mp3_convert/feature/tracking_speed/widgets/cycling_background.dart';
import 'package:mp3_convert/widget/button/go_button.dart';

extension TimeFormat on Duration {
  String getMinuteFormat() {
    int sec = inSeconds % 60;
    int min = (inSeconds / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return '$minute’ $second‘’';
  }
}

class SpeedPage extends StatefulWidget {
  const SpeedPage({super.key});

  @override
  State<SpeedPage> createState() => _SpeedPageState();
}

const Duration _switcherDuration = Duration(milliseconds: 800);

class _SpeedPageState extends BasePageState<SpeedPage> {
  bool isInit = false;

  final PositionTrackingMovingCubit trackingMovingCubit = PositionTrackingMovingCubit();

  @override
  void initState() {
    super.initState();
    trackingMovingCubit.init();
  }

  bool _buildWhen(TrackingMovingState p, TrackingMovingState c) {
    return (p is ReadyTrackingMovingState && c is! ReadyTrackingMovingState) ||
        (c is ReadyTrackingMovingState && p is! ReadyTrackingMovingState);
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Builder(builder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text("Start at: ${DateTime.now()}"),
            BlocBuilder<PositionTrackingMovingCubit, TrackingMovingState>(
                buildWhen: _buildWhen,
                builder: (c, s) {
                  if (s is ReadyTrackingMovingState) {
                    return const SizedBox();
                  }
                  return StreamBuilder(
                      stream: context.read<PositionTrackingMovingCubit>().timerStream,
                      builder: (c, d) {
                        if (d.hasData) {
                          final duration = d.data!;

                          return Text(duration.getMinuteFormat());
                        }
                        return const SizedBox();
                      });
                }),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => trackingMovingCubit,
      child: super.build(context),
    );
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
              return AnimatedSwitcher(
                duration: _switcherDuration,
                child: CyclingBackground(
                  child: Center(
                    child: GoButton(
                      onTap: () {
                        trackingMovingCubit.start();
                      },
                    ),
                  ),
                ),
              );
            }

            return AnimatedSwitcher(
              duration: _switcherDuration,
              child: Column(
                children: [
                  Expanded(
                    child: CyclingBackground(
                      child: Center(
                        child: BlocSelector<PositionTrackingMovingCubit, TrackingMovingState, double>(
                          selector: (state) => state.currentSpeed,
                          builder: (context, speed) {
                            return Text(
                              "${speed.toStringAsFixed(0)}",
                              maxLines: 1,
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    fontSize: 180,
                                  ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  _MovingInfo(),
                  _MovingController(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MovingInfo extends StatelessWidget {
  const _MovingInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                    title: "Avarage",
                    content: "${state.speed.averageSpeed.toStringAsFixed(1)}",
                  ),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.white12,
                ),
                Expanded(
                  child: _TitleAndContent(
                    title: "Distance",
                    content: "${state.distance.totalDistance.toStringAsFixed(1)}",
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
                    content: "${state.speed.maxSpeed.toStringAsFixed(1)}",
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
                context.read<PositionTrackingMovingCubit>().start();
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
                    context.read<PositionTrackingMovingCubit>().resume();
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
              child: Text("OKE"),
              onTap: () {
                context.read<PositionTrackingMovingCubit>().reset();
              },
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
