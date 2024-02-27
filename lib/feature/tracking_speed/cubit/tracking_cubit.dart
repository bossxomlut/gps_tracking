//tracking speed
//max speed
//average speed
//tracking moving
//total distance

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mp3_convert/base_presentation/cubit/base_cubit.dart';
import 'package:mp3_convert/util/gps/gps.dart';
import 'package:mp3_convert/util/gps/gps_util.dart';
import 'package:mp3_convert/util/gps/speed_util.dart';
import 'package:mp3_convert/util/task_runner.dart';
import 'package:mp3_convert/util/timer/moving_time.dart';

abstract class CalculateDistance {
  //meter
  double get distance;

  void setPosition(GPSEntity position);

  void reset();
}

class CalculateDistanceImpl extends CalculateDistance {
  GPSEntity? _position;

  @override
  void setPosition(GPSEntity position) {
    _totalDistance += _calNewDistance(position);
    _position = position;
  }

  double _totalDistance = 0;

  @override
  void reset() {
    _position = null;
    _totalDistance = 0;
  }

  double _calNewDistance(GPSEntity position) {
    if (_position == null) {
      return 0;
    }

    return Geolocator.distanceBetween(
      _position!.latitude,
      _position!.longitude,
      position.latitude,
      position.longitude,
    );
  }

  @override
  double get distance => _totalDistance;
}

extension _CancelPositionTrackingMovingCubit on PositionTrackingMovingCubit {
  void _cancelGPSListener() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }
}

class PositionTrackingMovingCubit extends SpeedTrackingMovingCubit {
  StreamSubscription? _positionStreamSubscription;

  final CalculateDistance _calDistance = CalculateDistanceImpl();

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

class SpeedTrackingMovingCubit extends Cubit<TrackingMovingState>
    with SafeEmit<TrackingMovingState>
    implements MovingControl {
  SpeedTrackingMovingCubit() : super(TrackingMovingState.ready());

  final TaskRunner _queueTask = TaskRunner();

  final GPSUtil gps = GPSUtil.instance;

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
        break;
      case InProgressTrackingMovingState():
        break;
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
  void init() {
    gps.requestLocationPermission().then((value) {
      gps.checkEnableLocationService().then((value) {});
    });
  }

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

abstract class MovingControl {
  void reset();
  void start();
  void pause();
  void stop();
  void resume();
}

sealed class TrackingMovingState extends Equatable implements SpeedData, DistanceData {
  final SpeedEntity speed;
  final DistanceEntity distance;

  const TrackingMovingState({required this.speed, required this.distance});

  factory TrackingMovingState.ready() {
    return ReadyTrackingMovingState();
  }

  factory TrackingMovingState.stop(TrackingMovingState current) {
    return StopTrackingMovingState(speed: current.speed.copyWith(currentSpeed: 0), distance: current.distance);
  }

  TrackingMovingState stop() {
    return StopTrackingMovingState(speed: speed, distance: distance);
  }

  factory TrackingMovingState.pause(TrackingMovingState current) {
    return PauseTrackingMovingState(speed: current.speed.copyWith(currentSpeed: 0), distance: current.distance);
  }

  TrackingMovingState pause() {
    return PauseTrackingMovingState(speed: speed.copyWith(currentSpeed: 0), distance: distance);
  }

  factory TrackingMovingState.resume(TrackingMovingState current) {
    return InProgressTrackingMovingState(speed: current.speed, distance: current.distance);
  }

  TrackingMovingState resume() {
    return InProgressTrackingMovingState(speed: speed, distance: distance);
  }

  @override
  double get averageSpeed => speed.averageSpeed;

  @override
  double get currentSpeed => speed.currentSpeed;

  @override
  double get maxSpeed => speed.maxSpeed;

  @override
  double get totalDistance => distance.totalDistance;

  @override
  List<Object?> get props => [
        speed,
        distance,
      ];
}

class ReadyTrackingMovingState extends TrackingMovingState {
  ReadyTrackingMovingState() : super(distance: DistanceEntity.zero(), speed: SpeedEntity.zero());
}

class InProgressTrackingMovingState extends TrackingMovingState {
  const InProgressTrackingMovingState({required super.speed, required super.distance});
}

class PauseTrackingMovingState extends TrackingMovingState {
  const PauseTrackingMovingState({required super.speed, required super.distance});
}

class StopTrackingMovingState extends TrackingMovingState {
  const StopTrackingMovingState({required super.speed, required super.distance});
}

abstract class SpeedData {
  double get currentSpeed;
  double get maxSpeed;
  double get averageSpeed;
}

abstract class DistanceData {
  double get totalDistance;
}

class SpeedEntity extends Equatable {
  final double currentSpeed;
  final double maxSpeed;
  final double averageSpeed;

  const SpeedEntity({
    required this.currentSpeed,
    required this.maxSpeed,
    required this.averageSpeed,
  });

  factory SpeedEntity.zero() {
    return const SpeedEntity(currentSpeed: 0, maxSpeed: 0, averageSpeed: 0);
  }

  @override
  List<Object?> get props => [
        currentSpeed,
        maxSpeed,
        averageSpeed,
      ];

  SpeedEntity copyWith({
    double? currentSpeed,
    double? maxSpeed,
    double? averageSpeed,
  }) {
    return SpeedEntity(
      currentSpeed: currentSpeed ?? this.currentSpeed,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      averageSpeed: averageSpeed ?? this.averageSpeed,
    );
  }
}

class DistanceEntity extends Equatable {
  //meter
  final double totalDistance;

  const DistanceEntity({required this.totalDistance});
  factory DistanceEntity.zero() {
    return const DistanceEntity(totalDistance: 0);
  }
  @override
  List<Object?> get props => [
        totalDistance,
      ];

  DistanceEntity copyWith({
    double? totalDistance,
  }) {
    return DistanceEntity(
      totalDistance: totalDistance ?? this.totalDistance,
    );
  }
}
