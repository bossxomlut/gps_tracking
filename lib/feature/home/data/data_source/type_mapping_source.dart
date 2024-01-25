import 'package:mp3_convert/internet_connect/http_request/api_dto.dart';
import 'package:mp3_convert/internet_connect/http_request/api_response.dart';

abstract class FileTypeMappingSource {
  Future<ApiResponse> getMappingType(MappingTypeDto typeDto);
}

class MappingTypeDto extends ApiDto {
  final String type;

  MappingTypeDto({required this.type});
  @override
  Map<String, dynamic> toJson() {
    return {"ext": type};
  }
}
