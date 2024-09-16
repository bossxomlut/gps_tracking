import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_speed/base_presentation/cubit/base_cubit.dart';

class MaxSpeedCubit extends Cubit<MaxSpeedState> with SafeEmit {
  MaxSpeedCubit() : super(const MaxSpeedState());

  Future init() async {
    //load max speed list
    emit(
      state.copyWith(
        maxSpeedList: [50, 60],
        maxSpeed: 50,
      ),
    );

    //load max speed

    //emit state
  }

  void setMaxSpeed(double d) {
    emit(state.copyWith(maxSpeed: d));
  }
}

class MaxSpeedState extends Equatable {
  final double? maxSpeed;
  final List<double>? maxSpeedList;

  bool get haveMaxSpeed => maxSpeed != null;

  const MaxSpeedState({
    this.maxSpeed,
    this.maxSpeedList,
  });

  @override
  List<Object?> get props => [
        maxSpeed,
        maxSpeedList,
      ];

  MaxSpeedState copyWith({
    double? maxSpeed,
    List<double>? maxSpeedList,
  }) {
    return MaxSpeedState(
      maxSpeed: maxSpeed ?? this.maxSpeed,
      maxSpeedList: maxSpeedList ?? this.maxSpeedList,
    );
  }
}
