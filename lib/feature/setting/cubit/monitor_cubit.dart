import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_speed/base_presentation/cubit/base_cubit.dart';
import 'package:gps_speed/storage/key_value_storage.dart';
import 'package:gps_speed/storage/storage_key.dart';

enum MonitorViewType {
  number,
  gauge;

  static MonitorViewType fromString(String value) {
    switch (value) {
      case 'number':
        return MonitorViewType.number;
      case 'gauge':
        return MonitorViewType.gauge;
      default:
        return MonitorViewType.number;
    }
  }
}

class MonitorCubit extends Cubit<MonitorState> with SafeEmit {
  MonitorCubit() : super(const MonitorState()) {
    init();
  }

  final KeyValueStorage _keyValueStorage = KeyValueStorage.i();

  Future init() async {
    _keyValueStorage.get<MonitorViewType>(StorageKey.monitorViewType, tryParse: (value) {
      return MonitorViewType.fromString(value);
    }).then((viewType) {
      emit(
        state.copyWith(
          viewType: viewType ?? MonitorViewType.number,
        ),
      );
    });
  }

  List<MonitorViewType> get viewTypeList => MonitorViewType.values;

  void setViewType(MonitorViewType sp) {
    _keyValueStorage.set(StorageKey.monitorViewType, sp.name.toString());
    emit(state.copyWith(viewType: sp));
  }
}

class MonitorState extends Equatable {
  final MonitorViewType? viewType;

  const MonitorState({
    this.viewType,
  });

  @override
  List<Object?> get props => [
        viewType,
      ];

  MonitorState copyWith({
    MonitorViewType? viewType,
  }) {
    return MonitorState(
      viewType: viewType ?? this.viewType,
    );
  }
}
