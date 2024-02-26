import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_convert/base_presentation/page/base_page.dart';
import 'package:mp3_convert/feature/tracking_speed/cubit/tracking_cubit.dart';
import 'package:mp3_convert/feature/tracking_speed/widgets/button.dart';
import 'package:mp3_convert/feature/tracking_speed/widgets/cycling_background.dart';

class SpeedPage extends StatefulWidget {
  const SpeedPage({super.key});

  @override
  State<SpeedPage> createState() => _SpeedPageState();
}

class _SpeedPageState extends BasePageState<SpeedPage> {
  bool isInit = false;

  final PositionTrackingMovingCubit trackingMovingCubit = PositionTrackingMovingCubit();

  @override
  void initState() {
    super.initState();
    trackingMovingCubit.init();
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
      child: Column(
        children: [
          Expanded(
            child: CyclingBackground(
              child: Center(
                child: BlocSelector<PositionTrackingMovingCubit, TrackingMovingState, double>(
                  selector: (state) => state.currentSpeed,
                  builder: (context, speed) {
                    return Text(
                      "$speed",
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
          StreamBuilder(
              stream: trackingMovingCubit.timerStream,
              builder: (c, d) {
                if (d.hasData) {
                  return Text(d.toString());
                }
                return const SizedBox();
              }),
          _MovingInfo(),
          _MovingController(),
        ],
      ),
    );
  }
}

class _MovingInfo extends StatelessWidget {
  const _MovingInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PositionTrackingMovingCubit, TrackingMovingState>(builder: (context, state) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [Text("Avarage"), Text("${state.speed.averageSpeed}")],
          ),
          Column(
            children: [Text("Distance"), Text("${state.distance.totalDistance}")],
          ),
          Column(
            children: [Text("Max Speed"), Text("${state.speed.maxSpeed}")],
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
                context.read<PositionTrackingMovingCubit>().start();
              },
            );

          case InProgressTrackingMovingState():
            return Row(
              children: [
                PauseButton(
                  onTap: () {
                    context.read<PositionTrackingMovingCubit>().pause();
                  },
                ),
                StopButton(
                  onTap: () {
                    context.read<PositionTrackingMovingCubit>().stop();
                  },
                ),
              ],
            );
          case PauseTrackingMovingState():
            return Row(
              children: [
                PlayButton(
                  onTap: () async {
                    context.read<PositionTrackingMovingCubit>().resume();
                  },
                ),
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
