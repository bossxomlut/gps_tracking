import 'package:mp3_convert/data/data_result.dart';
import 'package:mp3_convert/data/entity/failure_entity.dart';
import 'package:mp3_convert/feature/convert/data/entity/mapping_type.dart';
import 'package:mp3_convert/feature/convert/data/entity/media_type.dart';
import 'package:mp3_convert/feature/convert/data/repository/picking_file_repository.dart';
import 'package:mp3_convert/feature/convert/data/repository/picking_file_repository_impl.dart';
import 'package:mp3_convert/feature/merger/data/repository/merger_mapping_repository.dart';

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

  @override
  Future<String?> getTypeName(String sourceType) {
    return pickingFileRepository.getTypeName(sourceType);
  }
}

class MergeMappingType implements MappingType {
  final MergerMappingRepository pickingFileRepository = MergerMappingRepositoryImpl();
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

  @override
  Future<String?> getTypeName(String sourceType) {
    return pickingFileRepository.getTypeName(sourceType);
  }
}
