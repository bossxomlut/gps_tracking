import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_speed/base_presentation/cubit/base_cubit.dart';
import 'package:gps_speed/feature/setting/cubit/cubit.dart';
import 'package:gps_speed/feature/tracking_speed/cubit/tracking_cubit.dart';
import 'package:rxdart/rxdart.dart';

class WarningSpeedBloc extends Cubit<WarningSpeedState> with SafeEmit {
  WarningSpeedBloc(
    this.positionTrackingMovingCubit,
    this.maxSpeedCubit,
  ) : super(const WarningSpeedState(showWarning: false)) {
    init();
  }

  final PositionTrackingMovingCubit positionTrackingMovingCubit;
  final MaxSpeedCubit maxSpeedCubit;

  late final StreamSubscription _streamSubscription;

  void init() {
    _streamSubscription = Rx.merge([
      positionTrackingMovingCubit.stream,
      maxSpeedCubit.stream,
    ])
        .map((event) {
          final a = positionTrackingMovingCubit.state;
          final b = maxSpeedCubit.state;
          if (b.haveMaxSpeed) {
            if (a.currentSpeed > b.maxSpeed!) {
              return true;
            }
          }

          return false;
        })
        .distinct()
        .listen((showWarning) {
          emit(state.copyWith(showWarning: showWarning));
        });
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
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
