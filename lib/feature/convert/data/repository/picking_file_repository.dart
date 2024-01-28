import 'package:mp3_convert/data/data_result.dart';
import 'package:mp3_convert/data/entity/failure_entity.dart';
import 'package:mp3_convert/feature/convert/data/entity/media_type.dart';

abstract class PickingFileRepository {
  Future<DataResult<FailureEntity, ListMediaType>> mappingType(String sourceType);
  Future<String?> getTypeName(String sourceType);
}
