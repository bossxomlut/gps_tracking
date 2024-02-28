import 'package:equatable/equatable.dart';

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
