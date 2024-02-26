import 'package:mp3_convert/feature/tracking_speed/cubit/tracking_cubit.dart';

void main() {
  var a = TrackingMovingState(
    speed: SpeedEntity.zero(),
    distance: DistanceEntity.zero(),
  );
  var b = a.copyWith(speedListener: a.speed.copyWith(averageSpeed: 10));
  print(a);
  print(b);
  print(a == b);
}
