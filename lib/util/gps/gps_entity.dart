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
