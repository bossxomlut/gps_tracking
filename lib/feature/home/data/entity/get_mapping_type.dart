import 'package:mp3_convert/data/data_result.dart';
import 'package:mp3_convert/data/entity/failure_entity.dart';
import 'package:mp3_convert/feature/home/data/entity/mapping_type.dart';
import 'package:mp3_convert/feature/home/data/entity/media_type.dart';
import 'package:mp3_convert/feature/home/data/repository/picking_file_repository.dart';
import 'package:mp3_convert/feature/home/data/repository/picking_file_repository_impl.dart';

class GetMappingType implements MappingType {
  final PickingFileRepository pickingFileRepository = PickingFileRepositoryImpl();

  @override
  Future<ListMediaType?> getMappingType(String sourceType) {
    return pickingFileRepository.mappingType(sourceType).then((result) {
      switch (result) {
        case SuccessDataResult<FailureEntity, ListMediaType>():
          return result.data;
        case FailureDataResult<FailureEntity, ListMediaType>():
          return null;
      }
    });
  }
}
