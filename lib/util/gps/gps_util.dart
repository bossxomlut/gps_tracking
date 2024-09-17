import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import 'gps.dart';

GPSUtil getGPSUtilInstance() => _GPSUtilImpl();

abstract class GPSUtil {
  static final GPSUtil _instance = getGPSUtilInstance();

  static GPSUtil get instance => _instance;

  Future<bool> requestLocationPermission();

  Future<bool> checkLocationPermission();

  Future<bool> openSettingLocationPermission();

  Future<bool> openSettingLocationService();

  Future<bool> checkEnableLocationService();

  Stream<bool> listenLocationServiceChanged();

  Future<GPSEntity> getCurrentLocation();

  Stream<GPSEntity> listenGPSChanged();
}

class _GPSUtilImpl extends GPSUtil {
  @override
  Future<GPSEntity> getCurrentLocation() {
    return Geolocator.getCurrentPosition().then(_fromPosition);
  }

  @override
  Stream<GPSEntity> listenGPSChanged() {
    late LocationSettings locationSettings;

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 4,
        intervalDuration: const Duration(seconds: 1),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText: "Example app will continue to receive your location even when you aren't using it",
          notificationTitle: "Running in Background",
          enableWakeLock: true,
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.best,
        activityType: ActivityType.fitness,
        distanceFilter: 1,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1,
      );
    }
    return Geolocator.getPositionStream(locationSettings: locationSettings).map(_fromPosition);
  }

  @override
  Stream<bool> listenLocationServiceChanged() {
    return Geolocator.getServiceStatusStream().map((event) => event == ServiceStatus.enabled);
  }

  @override
  Future<bool> checkEnableLocationService() {
    return Geolocator.isLocationServiceEnabled();
  }

  @override
  Future<bool> requestLocationPermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw DeniedLocationPermissionException();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw DeniedForeverLocationPermissionException();
    }

    return true;
  }

  @override
  Future<bool> openSettingLocationService() {
    return Geolocator.openLocationSettings();
  }

  @override
  Future<bool> openSettingLocationPermission() {
    return Geolocator.openAppSettings();
  }

  @override
  Future<bool> checkLocationPermission() {
    return Geolocator.checkPermission().then((value) {
      return value == LocationPermission.always || value == LocationPermission.whileInUse;
    });
  }
}

GPSEntity _fromPosition(Position position) {
  return GPSEntity(
    latitude: position.latitude,
    longitude: position.longitude,
    speed: position.speed,
    time: position.timestamp,
  );
}

sealed class GPSException implements Exception {}

class DisableLocationServiceException extends GPSException {}

class DeniedLocationPermissionException extends GPSException {}

class DeniedForeverLocationPermissionException extends GPSException {}
