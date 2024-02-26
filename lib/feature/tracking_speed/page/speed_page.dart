import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_convert/base_presentation/page/base_page.dart';
import 'package:mp3_convert/feature/tracking_speed/cubit/tracking_cubit.dart';

class SpeedPage extends StatefulWidget {
  const SpeedPage({super.key});

  @override
  State<SpeedPage> createState() => _SpeedPageState();
}

class _SpeedPageState extends BasePageState<SpeedPage> {
  bool isInit = false;

  final TrackingMovingCubit trackingMovingCubit = TrackingMovingCubit();

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
            child: BlocSelector<TrackingMovingCubit, TrackingMovingState, double>(
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
          _MovingController(),
        ],
      ),
    );
  }
}

class _MovingController extends StatelessWidget {
  const _MovingController({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackingMovingCubit, TrackingMovingState>(
      builder: (context, state) {
        switch (state) {
          case ReadyTrackingMovingState():
            return GestureDetector(
              onTap: () {
                context.read<TrackingMovingCubit>().start();
              },
              child: Text("Start"),
            );
          case InProgressTrackingMovingState():
            return Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<TrackingMovingCubit>().pause();
                  },
                  child: Text("Pause"),
                ),
                GestureDetector(
                  onTap: () {
                    context.read<TrackingMovingCubit>().stop();
                  },
                  child: Text("Stop"),
                ),
              ],
            );
          case PauseTrackingMovingState():
            return Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<TrackingMovingCubit>().resume();
                  },
                  child: Text("Resume"),
                ),
                GestureDetector(
                  onTap: () {
                    context.read<TrackingMovingCubit>().stop();
                  },
                  child: Text("Stop"),
                ),
              ],
            );

          case StopTrackingMovingState():
            return Text(" Stopped");
        }
      },
    );
  }
}
