import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_speed/feature/setting/cubit/monitor_cubit.dart';
import 'package:gps_speed/feature/setting/cubit/unit_cubit.dart';
import 'package:gps_speed/feature/tracking_speed/cubit/tracking_cubit.dart';
import 'package:gps_speed/feature/tracking_speed/cubit/tracking_state.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'cycling_background.dart';

class SpeedMonitorView extends StatelessWidget {
  const SpeedMonitorView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CyclingBackground(
      child: Center(
        child: BlocSelector<MonitorCubit, MonitorState, MonitorViewType?>(
            selector: (state) => state.viewType,
            builder: (context, viewType) {
              if (viewType == null) {
                return const SizedBox();
              }

              switch (viewType) {
                case MonitorViewType.number:
                  return BlocSelector<PositionTrackingMovingCubit, TrackingMovingState, double>(
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
                  );

                case MonitorViewType.gauge:
                  return BlocSelector<PositionTrackingMovingCubit, TrackingMovingState, double>(
                    selector: (state) => state.currentSpeed,
                    builder: (context, speed) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SfRadialGauge(
                          title: const GaugeTitle(text: ""),
                          enableLoadingAnimation: true,
                          axes: <RadialAxis>[
                            RadialAxis(minimum: 0, maximum: 150, ranges: <GaugeRange>[
                              GaugeRange(
                                  startValue: 0, endValue: 50, color: Colors.green, startWidth: 10, endWidth: 10),
                              GaugeRange(
                                  startValue: 50, endValue: 100, color: Colors.orange, startWidth: 10, endWidth: 10),
                              GaugeRange(
                                  startValue: 100, endValue: 150, color: Colors.red, startWidth: 10, endWidth: 10)
                            ], pointers: <GaugePointer>[
                              NeedlePointer(
                                value: speed,
                                animationDuration: 1000,
                                enableAnimation: true,
                              ),
                            ], annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                widget: Container(
                                  child: Text("${speed.toStringAsFixed(0)}",
                                      style: Theme.of(context).textTheme.displayLarge),
                                ),
                                angle: 90,
                                positionFactor: 0.5,
                              ),
                              GaugeAnnotation(
                                widget: Container(
                                  child: Text(context.read<UnitCubit>().getSpeedSymbol(),
                                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200)),
                                ),
                                angle: 90,
                                positionFactor: 0.8,
                              ),
                            ])
                          ],
                        ),
                      );
                    },
                  );
              }
            }),
      ),
    );
  }
}
