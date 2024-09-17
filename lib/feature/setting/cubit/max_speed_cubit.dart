import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_speed/base_presentation/cubit/base_cubit.dart';
import 'package:gps_speed/storage/key_value_storage.dart';
import 'package:gps_speed/storage/storage_key.dart';

class MaxSpeedCubit extends Cubit<MaxSpeedState> with SafeEmit {
  MaxSpeedCubit() : super(const MaxSpeedState());

  final KeyValueStorage _keyValueStorage = KeyValueStorage.i();

  Future init() async {
    _keyValueStorage.get<double>(StorageKey.maxSpeed, tryParse: (value) {
      return double.tryParse(value);
    }).then((maxSpeed) {
      emit(
        state.copyWith(
          maxSpeedList: [50, 60],
          maxSpeed: maxSpeed ?? 50,
        ),
      );
    });
  }

  void setMaxSpeed(double d) {
    _keyValueStorage.set(StorageKey.maxSpeed, d);
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
