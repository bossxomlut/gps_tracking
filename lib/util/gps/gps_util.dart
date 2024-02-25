import 'dart:async';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';

GPSUtil getGPSUtilInstance() => _GPSUtilImpl();

abstract class GPSUtil {
  static final GPSUtil _instance = getGPSUtilInstance();

  static GPSUtil get instance => _instance;

  Future<bool> requestLocationPermission();

  Future<bool> checkEnableLocationService();

  Stream<bool> listenLocationServiceChanged();

  Future<GPSEntity> getCurrentLocation();

  Stream<GPSEntity> listenGPSChanged();
}

class SpeedUtil {
  StreamController<double> _streamController = StreamController();

  GPSEntity? _lastLocation;
  Timer? _timer;

  Stream<double> listenSpeedChanged() {
    GPSUtil.instance.listenGPSChanged().listen((gps) {
      _lastLocation = gps;
      _streamController.add(gps.kmh());

      if (_timer != null) {
        log("cancel exist timer");
        _timer?.cancel();
      }
      log("created timer");
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        log("timer reset speed");
        _streamController.add(0.0);
        _timer?.cancel();
        _timer = null;
      });
    });

    return _streamController.stream;
  }
}

class _GPSUtilImpl extends GPSUtil {
  @override
  Future<GPSEntity> getCurrentLocation() {
    return Geolocator.getCurrentPosition().then(_fromPosition);
  }

  @override
  Stream<GPSEntity> listenGPSChanged() {
    return Geolocator.getPositionStream().map(_fromPosition);
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
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    }

    return true;
  }
}

class GPSEntity {
  final double latitude;
  final double longitude;

  //[speed] (m/s)
  final double speed;
  final DateTime time;

  GPSEntity({
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.time,
  });

  double kmh() {
    return speed * 3.6;
  }
}

enum SpeedUnit { mps, kph }

GPSEntity _fromPosition(Position position) {
  return GPSEntity(
    latitude: position.latitude,
    longitude: position.longitude,
    speed: position.speed,
    time: position.timestamp,
  );
}
