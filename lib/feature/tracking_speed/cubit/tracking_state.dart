import 'package:equatable/equatable.dart';
import 'package:gps_speed/data/entity/moving_entity.dart';

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
