enum SpeedUnit {
  mps,
  kph;

  String getStringUnit() {
    switch (this) {
      case SpeedUnit.mps:
        return "m/s";
      case SpeedUnit.kph:
        return "km/h";
    }
  }
}

enum DistanceUnit {
  m,
  km;

  String getStringUnit() {
    switch (this) {
      case DistanceUnit.m:
        return "m";
      case DistanceUnit.km:
        return "km";
    }
  }
}
