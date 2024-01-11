import 'package:mp3_convert/data/data_result.dart';
import 'package:mp3_convert/data/entity/failure_entity.dart';
import 'package:mp3_convert/feature/home/data/data_source/type_mapping_source.dart';
import 'package:mp3_convert/feature/home/data/entity/media_type.dart';
import 'package:mp3_convert/internet_connect/http_request/api.dart';
import 'package:mp3_convert/internet_connect/http_request/api_response.dart';

abstract class PickingFileRepository {
  Future<DataResult<FailureEntity, ListMediaType>> mappingType(String sourceType);
}

class PickingFileRepositoryImpl extends PickingFileRepository {
  final FileTypeMappingSource fileTypeMappingSource = FileTypeMappingSourceImpl(Mp3ApiRequest());

  @override
  Future<DataResult<FailureEntity, ListMediaType>> mappingType(String sourceType) async {
    return fileTypeMappingSource.getMappingType(MappingTypeDto(type: sourceType)).then((response) {
      switch (response) {
        case SuccessApiResponse():
          final responseData = response.data;
          if (responseData is Map) {
            return SuccessDataResult(ListMediaType.fromJson(responseData));
          }
        case FailureApiResponse():
          return FailureDataResult(FailureEntity(message: response.message));
      }

      return FailureDataResult(FailureEntity(message: response.message));
    });
  }
}

void main() async {
  final PickingFileRepository pickingFileRepository = PickingFileRepositoryImpl();
  final result = await pickingFileRepository.mappingType("mp4");

  switch (result) {
    case SuccessDataResult<FailureEntity, ListMediaType>():
      {
        final data = result.data;
        //handle this data
      }
    case FailureDataResult<FailureEntity, ListMediaType>():
      {
        final data = result.data;
        //show message or something else
      }
  }
}
