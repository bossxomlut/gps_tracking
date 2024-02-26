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
