import 'package:mp3_convert/di/di.dart';
import 'package:mp3_convert/feature/home/data/data_source/type_mapping_source.dart';
import 'package:mp3_convert/internet_connect/http_request/api.dart';
import 'package:mp3_convert/internet_connect/http_request/api_response.dart';

class FileTypeMappingSourceImpl extends FileTypeMappingSource {
  late final ApiRequestWrapper _apiRequestWrapper;

  FileTypeMappingSourceImpl({ApiRequestWrapper? apiRequestWrapper}) {
    _apiRequestWrapper = apiRequestWrapper ?? di.get<Mp3ApiRequest>();
  }

  @override
  Future<ApiResponse> getMappingType(MappingTypeDto typeDto) {
    return _apiRequestWrapper.post(
      "/config/check-format",
      data: typeDto.toJson(),
    );
  }
}
