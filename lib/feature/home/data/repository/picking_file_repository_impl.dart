import 'package:mp3_convert/data/data_result.dart';
import 'package:mp3_convert/data/entity/failure_entity.dart';
import 'package:mp3_convert/data/mapping_storage.dart';
import 'package:mp3_convert/di/di.dart';
import 'package:mp3_convert/feature/home/data/data_source/type_mapping_source.dart';
import 'package:mp3_convert/feature/home/data/data_source/type_mapping_source_impl.dart';
import 'package:mp3_convert/feature/home/data/entity/media_type.dart';
import 'package:mp3_convert/feature/home/data/repository/picking_file_repository.dart';
import 'package:mp3_convert/internet_connect/http_request/api.dart';
import 'package:mp3_convert/internet_connect/http_request/api_response.dart';

class PickingFileRepositoryImpl extends PickingFileRepository {
  PickingFileRepositoryImpl({
    FileTypeMappingSource? fileTypeMappingSource,
    MappingStorage<String, ListMediaType>? mappingTypeStorage,
  }) {
    _fileTypeMappingSource = fileTypeMappingSource ?? di.get();
    _mappingTypeStorage = mappingTypeStorage ?? di.get<MappingTypeStorage>();
  }

  late final FileTypeMappingSource _fileTypeMappingSource;
  late final MappingStorage<String, ListMediaType> _mappingTypeStorage;

  @override
  Future<DataResult<FailureEntity, ListMediaType>> mappingType(String sourceType) async {
    if (_mappingTypeStorage.checkContains(sourceType)) {
      return SuccessDataResult(_mappingTypeStorage.getValue(sourceType)!);
    }

    return _fileTypeMappingSource.getMappingType(MappingTypeDto(type: sourceType)).then((response) {
      switch (response) {
        case SuccessApiResponse():
          final responseData = response.data;
          if (responseData is Map) {
            final value = ListMediaType.fromJson(responseData);
            _mappingTypeStorage.setValue(sourceType, value);
            return SuccessDataResult(value);
          }
        case FailureApiResponse():
          return FailureDataResult(FailureEntity(message: response.message));
        case InternetErrorResponse():
        // TODO: Handle this case.
      }

      return FailureDataResult(FailureEntity(message: response.message));
    });
  }
}

class MappingTypeStorage extends MappingStorage<String, ListMediaType> {
  MappingTypeStorage._();

  static final MappingTypeStorage _i = MappingTypeStorage._();

  factory MappingTypeStorage() {
    return _i;
  }

  @override
  String getKey(String key) {
    return key;
  }
}
