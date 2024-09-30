import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_speed/base_presentation/cubit/base_cubit.dart';
import 'package:gps_speed/data/gps/dangerous_entity.dart';
import 'package:gps_speed/storage/key_value_storage.dart';
import 'package:gps_speed/storage/storage_key.dart';
import 'package:gps_speed/util/gps/gps_util.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DangerousCubit extends Cubit<DangerousState> with SafeEmit {
  DangerousCubit(this._gpsUtil) : super(const DangerousState(dangerousLocations: [], showMarkButton: false)) {
    _keyValueStorage.get(StorageKey.enableDangerousMarker, tryParse: (value) {
      return value == 'true';
    }).then((value) {
      emit(state.copyWith(showMarkButton: value ?? true));
    });

    Hive.openBox('dangerous_locations').then(
      (value) {
        dangerousBox = value;
        loadDangerousLocations();
        _subscription = dangerousBox?.watch().listen(
          (event) {
            loadDangerousLocations();
          },
        );
      },
    );
  }

  final GPSUtil _gpsUtil;

  Box? dangerousBox;

  StreamSubscription? _subscription;

  final KeyValueStorage _keyValueStorage = KeyValueStorage.i();

  @override
  Future<void> close() {
    _subscription?.cancel();
    dangerousBox?.close();
    return super.close();
  }

  Future markAsDangerous() {
    return _gpsUtil.getCurrentLocation().then(
      (gps) async {
        final DangerousEntity dangerousEntity = DangerousEntity(
          latitude: gps.latitude,
          longitude: gps.longitude,
          time: gps.time,
          addressInfo: await _gpsUtil.getGPSInfo(gps),
        );

        //storage to local
        addDangerousLocations(dangerousEntity);
      },
    );
  }

  void loadDangerousLocations() {
    try {
      //init from local storage
      final List<DangerousEntity> dangerousLocations = dangerousBox!.values.map((e) => e as DangerousEntity).toList();
      emit(state.copyWith(dangerousLocations: dangerousLocations));
    } catch (e) {
      emit(state.copyWith(dangerousLocations: []));
    }
  }

  void addDangerousLocations(DangerousEntity location) async {
    try {
      await dangerousBox!.add(location);
    } catch (e) {
      emit(state.copyWith(dangerousLocations: [...state.dangerousLocations, location]));
    }
  }

  void removeDangerousLocations(
    DangerousEntity location,
    int index,
  ) async {
    try {
      await dangerousBox!.deleteAt(index);
    } catch (e) {
      final List<DangerousEntity> newDangerousLocations = List<DangerousEntity>.from(state.dangerousLocations);
      newDangerousLocations.remove(location);
      emit(state.copyWith(dangerousLocations: newDangerousLocations));
    }
  }

  void switchShowMarkButton() {
    emit(DangerousState(showMarkButton: !state.showMarkButton));

    _keyValueStorage.set(StorageKey.enableDangerousMarker, state.showMarkButton);
  }
}

class DangerousState extends Equatable {
  final List<DangerousEntity> dangerousLocations;
  final bool showMarkButton;

  const DangerousState({this.dangerousLocations = const [], this.showMarkButton = true});

  @override
  List<Object?> get props => [
        dangerousLocations,
        showMarkButton,
      ];

  DangerousState copyWith({
    List<DangerousEntity>? dangerousLocations,
    bool? showMarkButton,
  }) {
    return DangerousState(
      dangerousLocations: dangerousLocations ?? this.dangerousLocations,
      showMarkButton: showMarkButton ?? this.showMarkButton,
    );
  }
}
