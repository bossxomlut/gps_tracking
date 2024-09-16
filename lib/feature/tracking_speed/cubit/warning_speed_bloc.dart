import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_speed/base_presentation/cubit/base_cubit.dart';
import 'package:gps_speed/feature/setting/cubit/cubit.dart';
import 'package:gps_speed/feature/tracking_speed/cubit/tracking_cubit.dart';
import 'package:rxdart/rxdart.dart';

class WarningSpeedBloc extends Cubit<WarningSpeedState> with SafeEmit {
  WarningSpeedBloc(
    PositionTrackingMovingCubit positionTrackingMovingCubit,
    MaxSpeedCubit maxSpeedCubit,
  ) : super(WarningSpeedState(showWarning: false)) {
    Rx.combineLatest2(positionTrackingMovingCubit.stream, maxSpeedCubit.stream, (a, b) {
      if (b.haveMaxSpeed) {
        if (a.currentSpeed > b.maxSpeed!) {
          emit(state.copyWith(showWarning: true));
          return;
        }
      }

      emit(state.copyWith(showWarning: true));
    });
  }
}

class WarningSpeedState extends Equatable {
  final bool showWarning;

  const WarningSpeedState({required this.showWarning});

  @override
  List<Object?> get props => [
        showWarning,
      ];

  WarningSpeedState copyWith({
    bool? showWarning,
  }) {
    return WarningSpeedState(
      showWarning: showWarning ?? this.showWarning,
    );
  }
}
