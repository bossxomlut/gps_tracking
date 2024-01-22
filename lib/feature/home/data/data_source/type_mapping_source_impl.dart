import 'package:mp3_convert/feature/home/data/data_source/type_mapping_source.dart';
import 'package:mp3_convert/internet_connect/http_request/api.dart';
import 'package:mp3_convert/internet_connect/http_request/api_response.dart';

class FileTypeMappingSourceImpl extends FileTypeMappingSource {
  final ApiRequestWrapper apiRequestWrapper;

  FileTypeMappingSourceImpl(this.apiRequestWrapper);

  @override
  Future<ApiResponse> getMappingType(MappingTypeDto typeDto) {
    return apiRequestWrapper.post(
      "/config/check-format",
      data: typeDto.toJson(),
    );
  }
}
