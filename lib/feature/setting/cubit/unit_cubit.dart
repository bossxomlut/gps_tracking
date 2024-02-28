import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_speed/base_presentation/cubit/base_cubit.dart';
import 'package:gps_speed/data/unit.dart';

const speedFractionDigits = 0;
const distanceFractionDigits = 1;

class UnitCubit extends Cubit<UnitState> with SafeEmit {
  UnitCubit() : super(UnitState.defaultValue());

  void setSpeedUnit(SpeedUnit speedUnit) {
    emit(state.copyWith(speedUnit: speedUnit));
  }

  void setDistanceUnit(DistanceUnit distanceUnit) {
    emit(state.copyWith(distanceUnit: distanceUnit));
  }

  String getDistanceSymbol() {
    return state.distanceUnit.getStringUnit();
  }

  String getSpeedString(double speedKphValue, {int fractionDigits = speedFractionDigits}) {
    switch (state.speedUnit) {
      case SpeedUnit.mps:
        return (speedKphValue / 3.6).toStringAsFixed(fractionDigits);
      case SpeedUnit.kph:
        return speedKphValue.toStringAsFixed(fractionDigits);
    }
  }

  String getDistanceString(double meters, {int fractionDigits = distanceFractionDigits}) {
    switch (state.distanceUnit) {
      case DistanceUnit.m:
        return meters.toStringAsFixed(fractionDigits);
      case DistanceUnit.km:
        return (meters / 1000).toStringAsFixed(fractionDigits);
    }
  }

  String getSpeedSymbol() {
    return state.speedUnit.getStringUnit();
  }
}

class UnitState extends Equatable {
  final SpeedUnit speedUnit;
  final DistanceUnit distanceUnit;

  factory UnitState.defaultValue() {
    return UnitState(
      distanceUnit: DistanceUnit.km,
      speedUnit: SpeedUnit.kph,
    );
  }

  UnitState({required this.speedUnit, required this.distanceUnit});

  UnitState copyWith({
    SpeedUnit? speedUnit,
    DistanceUnit? distanceUnit,
  }) {
    return UnitState(
      speedUnit: speedUnit ?? this.speedUnit,
      distanceUnit: distanceUnit ?? this.distanceUnit,
    );
  }

  @override
  List<Object?> get props => [
        speedUnit,
        distanceUnit,
      ];
}
