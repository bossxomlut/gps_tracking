import 'package:mp3_convert/feature/convert/data/entity/media_type.dart';

abstract class MappingType {
  Future<ListMediaType?> getMappingType(String sourceType);
  Future<String?> getTypeName(String sourceType);
}
