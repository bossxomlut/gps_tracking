import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_speed/base_presentation/cubit/base_cubit.dart';
import 'package:gps_speed/base_presentation/cubit/event_mixin.dart';
import 'package:gps_speed/feature/tracking_speed/cubit/tracking_event.dart';
import 'package:gps_speed/util/gps/gps.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationServiceCubit extends Cubit<LocationServiceState> with SafeEmit, EventMixin<LocationServiceEvent> {
  LocationServiceCubit() : super(LocationServiceState.defaultData()) {
    _init();
    gps.checkEnableLocationService().then((value) {
      emit(state.copyWith(isEnableService: value));
    });
    _checkPermission();
  }
  final GPSUtil gps = GPSUtil.instance;

  void _init() {
    GPSUtil.instance.listenLocationServiceChanged().listen((event) {
      emit(state.copyWith(isEnableService: event));
    });

    Timer.periodic(const Duration(seconds: 2), (timer) {
      _checkPermission();
    });
  }

  void _checkPermission() {
    Permission.location.status.then((value) {
      switch (value) {
        case PermissionStatus.granted:
        case PermissionStatus.restricted:
        case PermissionStatus.limited:
        case PermissionStatus.provisional:
          emit(state.copyWith(isGranted: true, isDeniedForever: false));
          break;
        case PermissionStatus.permanentlyDenied:
          emit(state.copyWith(isGranted: false, isDeniedForever: true));
          break;
        case PermissionStatus.denied:
          emit(state.copyWith(isGranted: false, isDeniedForever: false));
      }
    });
  }

  bool canStart() {
    return state.isGranted && state.isEnableService;
  }

  Future requestPermissions() async {
    if (state.isGranted && state.isEnableService) {
      return;
    }

    if (state.isGranted) {
      addEvent(DisableLocationServiceEvent());
      return;
    }

    if (state.isEnableService) {
      await requestLocationPermission();
    }

    return requestLocationPermission().then((isGranted) {
      if (isGranted) {
        return requestLocationService();
      }
      return false;
    });
  }

  Future<bool> requestLocationPermission() async {
    final isGrantedLocationPermission = await gps.requestLocationPermission().catchError((error) {
      if (error is GPSException) {
        switch (error) {
          case DeniedForeverLocationPermissionException():
            addEvent(DeniedForeverLocationPermissionEvent());
            break;
          case DeniedLocationPermissionException():
            addEvent(DeniedLocationPermissionEvent());
            break;
          case DisableLocationServiceException():
            break;
        }
      }

      return false;
    });

    return isGrantedLocationPermission;
  }

  Future<bool> checkEnableLocationService() async {
    final isEnableLocationService = await gps.checkEnableLocationService().catchError((error) {
      if (error is GPSException) {
        switch (error) {
          case DeniedForeverLocationPermissionException():
          case DeniedLocationPermissionException():
            break;
          case DisableLocationServiceException():
            break;
        }
      }

      return false;
    });

    return isEnableLocationService;
  }

  Future requestLocationService() async {
    if (state.isEnableService) {
      return;
    }
    addEvent(DisableLocationServiceEvent());
  }
}

class LocationServiceState extends Equatable {
  final bool isEnableService;
  final bool isGranted;
  final bool isDeniedForever;

  LocationServiceState({
    required this.isEnableService,
    required this.isGranted,
    required this.isDeniedForever,
  });

  factory LocationServiceState.defaultData() {
    return LocationServiceState(
      isDeniedForever: false,
      isEnableService: false,
      isGranted: false,
    );
  }

  LocationServiceState copyWith({
    bool? isEnableService,
    bool? isGranted,
    bool? isDeniedForever,
  }) {
    return LocationServiceState(
      isEnableService: isEnableService ?? this.isEnableService,
      isGranted: isGranted ?? this.isGranted,
      isDeniedForever: isDeniedForever ?? this.isDeniedForever,
    );
  }

  @override
  List<Object?> get props => [
        isEnableService,
        isGranted,
        isDeniedForever,
      ];
}
