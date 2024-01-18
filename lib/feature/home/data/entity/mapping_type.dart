import 'package:mp3_convert/feature/home/data/entity/media_type.dart';

abstract class MappingType {
  Future<ListMediaType?> getMappingType(String sourceType);
}
