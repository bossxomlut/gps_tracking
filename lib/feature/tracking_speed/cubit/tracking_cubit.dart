//tracking speed
//max speed
//average speed
//tracking moving
//total distance

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_convert/base_presentation/cubit/base_cubit.dart';
import 'package:mp3_convert/util/gps/gps_util.dart';
import 'package:mp3_convert/util/gps/speed_util.dart';

class TrackingMovingCubit extends Cubit<TrackingMovingState>
    with SafeEmit<TrackingMovingState>
    implements MovingControl {
  TrackingMovingCubit() : super(TrackingMovingState.ready());

  final GPSUtil gps = GPSUtil.instance;

  final SpeedListener speedListener = SpeedListener();

  StreamSubscription? speedStreamSubscription;

  void init() {
    gps.requestLocationPermission().then((value) {
      gps.checkEnableLocationService().then((value) {
        //todo:
        //gps.listenGPSChanged().listen((event) { });
      });
    });
  }

  @override
  Future<void> close() {
    _cancelSpeedListener();
    return super.close();
  }

  @override
  void pause() {
    _cancelSpeedListener();
    emit(state.pause());
  }

  @override
  void resume() {
    emit(state.resume());

    start();
  }

  @override
  void start() {
    speedStreamSubscription = speedListener.listenSpeedChanged().listen((v) {
      // emit(state.copyWith(speed: state.speed.copyWith(averageSpeed: v)));
      emit(
        InProgressTrackingMovingState(
          speed: SpeedEntity(currentSpeed: v, maxSpeed: 2, averageSpeed: 2),
          distance: distanceState,
        ),
      );
    });
  }

  @override
  void stop() {
    _cancelSpeedListener();
    emit(state.stop());
  }
}

extension _GetStateData on TrackingMovingCubit {
  SpeedEntity get speedState => state.speed;

  DistanceEntity get distanceState => state.distance;
}

extension _CancelSpeedListener on TrackingMovingCubit {
  void _cancelSpeedListener() {
    speedListener.cancel();
    speedStreamSubscription?.cancel();
    speedStreamSubscription = null;
  }
}

abstract class MovingControl {
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
