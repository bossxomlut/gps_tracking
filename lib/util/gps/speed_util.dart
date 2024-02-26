import 'dart:async';
import 'dart:developer';

import 'gps_util.dart';

class SpeedListener {
  final int clearTimeInSeconds;

  SpeedListener({this.clearTimeInSeconds = 5});

  final StreamController<double> _streamController = StreamController.broadcast();

  StreamSubscription? _streamSubscription;

  Timer? _timer;

  Stream<double> listenSpeedChanged() {
    if (_streamSubscription != null) {
      cancel();
    }

    _streamSubscription = GPSUtil.instance.listenGPSChanged().listen((gps) {
      _streamController.add(gps.kmh());

      if (_timer != null) {
        log("cancel exist timer");
        _clearTimer();
      }

      log("created timer");
      _timer = Timer.periodic(Duration(seconds: clearTimeInSeconds), (timer) {
        log("timer reset speed");
        _streamController.add(0.0);
        _clearTimer();
      });
    });

    return _streamController.stream;
  }

  void cancel() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    _clearTimer();
  }

  void _clearTimer() {
    _timer?.cancel();
    _timer = null;
  }
}

abstract class CalculateSpeed {
  double? _speed;
  double get speed => _speed ?? 0;
  void setSpeed(double speed);

  void reset() {
    _speed = null;
  }
}

class CalculateMaxSpeed extends CalculateSpeed {
  @override
  void setSpeed(double speed) {
    if (_speed == null) {
      _speed = speed;
      return;
    }

    if (_speed! < speed) {
      _speed = speed;
    }
  }
}

class CalculateAverageSpeed extends CalculateSpeed {
  int _count = 0;

  @override
  void setSpeed(double speed) {
    if (_speed == null) {
      _speed = speed;
      _count++;
      return;
    }

    _speed = _speed! * _count + speed;
    _count++;
    _speed = _speed! / _count;
  }

  @override
  void reset() {
    super.reset();
    _count = 0;
  }
}
