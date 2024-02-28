import 'package:geolocator/geolocator.dart';

import 'gps_entity.dart';

abstract class CalculateDistance {
  //meter
  double get distance;

  void setPosition(GPSEntity position);

  void reset();
}

class CalculateDistanceImpl extends CalculateDistance {
  GPSEntity? _position;

  @override
  void setPosition(GPSEntity position) {
    _totalDistance += _calNewDistance(position);
    _position = position;
  }

  double _totalDistance = 0;

  @override
  void reset() {
    _position = null;
    _totalDistance = 0;
  }

  double _calNewDistance(GPSEntity position) {
    if (_position == null) {
      return 0;
    }

    return Geolocator.distanceBetween(
      _position!.latitude,
      _position!.longitude,
      position.latitude,
      position.longitude,
    );
  }

  @override
  double get distance => _totalDistance;
}
