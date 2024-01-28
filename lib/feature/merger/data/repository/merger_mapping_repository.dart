import 'package:mp3_convert/data/data_result.dart';
import 'package:mp3_convert/data/entity/failure_entity.dart';
import 'package:mp3_convert/data/mapping_storage.dart';
import 'package:mp3_convert/feature/convert/data/entity/media_type.dart';
import 'package:mp3_convert/feature/convert/data/repository/picking_file_repository_impl.dart';
import 'package:mp3_convert/feature/merger/data/data_source/convert_file_data_source.dart';
import 'package:mp3_convert/internet_connect/http_request/api_response.dart';

abstract class MergerMappingRepository {
  Future<DataResult<FailureEntity, ListMediaType>> mappingType(String sourceType);
  Future<String?> getTypeName(String sourceType);
}

class MergerMappingRepositoryImpl extends MergerMappingRepository {
  final MergeConvertDataSource _fileTypeMappingSource = MergeConvertDataSourceImpl();
  final MappingStorage<String, ListMediaType> _mappingTypeStorage = MappingTypeStorage();
  final MappingStorage<String, String> _mappingTypeNameStorage = MappingTypeNameStorage();

  @override
  Future<DataResult<FailureEntity, ListMediaType>> mappingType(String sourceType) async {
    if (_mappingTypeStorage.checkContains(sourceType)) {
      return SuccessDataResult(_mappingTypeStorage.getValue(sourceType)!);
    }

    return _fileTypeMappingSource.getTypes().then((response) {
      switch (response) {
        case SuccessApiResponse():
          final responseData = response.data;
          if (responseData is Map) {
            final value = ListMediaType.fromJson(responseData);
            _mappingTypeStorage.setValue(sourceType, value);
            final typeName = responseData['mediaTypes']?.toString() ?? '';
            if (typeName.isNotEmpty) {
              _mappingTypeNameStorage.setValue(sourceType, typeName);
            }
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

  @override
  Future<String?> getTypeName(String sourceType) async {
    return _mappingTypeNameStorage.getValue(sourceType);
  }
}
