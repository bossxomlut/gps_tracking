//tracking speed
//max speed
//average speed
//tracking moving
//total distance

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_speed/base_presentation/cubit/base_cubit.dart';
import 'package:gps_speed/data/entity/moving_entity.dart';
import 'package:gps_speed/data/moving_control.dart';
import 'package:gps_speed/util/gps/distance_util.dart';
import 'package:gps_speed/util/gps/gps.dart';
import 'package:gps_speed/util/task_runner.dart';
import 'package:gps_speed/util/timer/moving_time.dart';

import 'tracking_state.dart';

class PositionTrackingMovingCubit extends SpeedTrackingMovingCubit {
  StreamSubscription? _positionStreamSubscription;

  final CalculateDistance _calDistance = CalculateDistanceImpl();

  final GPSUtil gps = GPSUtil.instance;

  @override
  void reset() {
    _calDistance.reset();
    super.reset();
  }

  @override
  void start() {
    super.start();

    _positionStreamSubscription = gps.listenGPSChanged().listen((gps) {
      _calDistance.setPosition(gps);
      _queueTask.addTask(
        FunctionModel(emit, priority: 1, positionalArguments: [
          InProgressTrackingMovingState(
            speed: state.speed,
            distance: distanceState.copyWith(
              totalDistance: _calDistance.distance,
            ),
          ),
        ]),
      );
    });
  }

  @override
  void stop() {
    super.stop();
    _cancelGPSListener();
  }

  @override
  void pause() {
    super.pause();
    _cancelGPSListener();
  }

  @override
  Future<void> close() {
    _cancelGPSListener();
    return super.close();
  }
}

extension _CancelPositionTrackingMovingCubit on PositionTrackingMovingCubit {
  void _cancelGPSListener() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }
}

class SpeedTrackingMovingCubit extends Cubit<TrackingMovingState>
    with SafeEmit<TrackingMovingState>
    implements MovingControl {
  SpeedTrackingMovingCubit() : super(TrackingMovingState.ready());

  final TaskRunner _queueTask = TaskRunner();

  final SpeedListener speedListener = SpeedListener();

  StreamSubscription? _speedStreamSubscription;

  final CalculateSpeed _calMaxSpeed = CalculateMaxSpeed();

  final CalculateSpeed _calAverageSpeed = CalculateAverageSpeed();

  final MovingTime _movingTime = MovingTime();

  Stream<Duration> get timerStream => _movingTime.timerStream;

  @override
  void emit(TrackingMovingState newState) {
    switch (state) {
      case ReadyTrackingMovingState():
      case InProgressTrackingMovingState():
      case PauseTrackingMovingState():
        break;
      case StopTrackingMovingState():
        if (newState is! ReadyTrackingMovingState) {
          return;
        }
    }
    super.emit(newState);
  }

  @mustCallSuper
  Future init() async {}

  @override
  void reset() {
    emit(TrackingMovingState.ready());
    _movingTime.reset();
    _calMaxSpeed.reset();
    _calAverageSpeed.reset();
  }

  @override
  Future<void> close() {
    _cancelSpeedListener();
    return super.close();
  }

  @override
  void pause() {
    _movingTime.pause();
    _cancelSpeedListener();
    emit(state.pause());
  }

  @override
  void resume() {
    _movingTime.resume();
    emit(state.resume());

    start();
  }

  @override
  @mustCallSuper
  void start() {
    emit(InProgressTrackingMovingState(
      speed: state.speed,
      distance: state.distance,
    ));

    _movingTime.start();
    _speedStreamSubscription = speedListener.listenSpeedChanged().listen((v) {
      _queueTask.addTask(
        FunctionModel(emit, priority: 1, positionalArguments: [
          InProgressTrackingMovingState(
            speed: SpeedEntity(
              currentSpeed: v,
              maxSpeed: (_calMaxSpeed..setSpeed(v)).speed,
              averageSpeed: (_calAverageSpeed..setSpeed(v)).speed,
            ),
            distance: distanceState,
          )
        ]),
      );
    });
  }

  @override
  void stop() {
    _cancelSpeedListener();
    _movingTime.stop();
    _queueTask.clearAll();
    emit(state.stop());

    reset();
  }
}

extension _GetStateData on SpeedTrackingMovingCubit {
  SpeedEntity get speedState => state.speed;

  DistanceEntity get distanceState => state.distance;
}

extension _CancelSpeedListener on SpeedTrackingMovingCubit {
  void _cancelSpeedListener() {
    speedListener.cancel();
    _speedStreamSubscription?.cancel();
    _speedStreamSubscription = null;
  }
}
