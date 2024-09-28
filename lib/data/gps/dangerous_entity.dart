import 'package:hive/hive.dart';

part 'dangerous_entity.g.dart';

@HiveType(typeId: 0)
class DangerousEntity {
  @HiveField(0)
  final String addressInfo;

  @HiveField(1)
  final double latitude;

  @HiveField(2)
  final double longitude;

  @HiveField(3)
  final DateTime time;

  DangerousEntity({
    required this.addressInfo,
    required this.latitude,
    required this.longitude,
    required this.time,
  });
}
