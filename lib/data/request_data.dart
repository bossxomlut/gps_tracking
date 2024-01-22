import 'package:mp3_convert/internet_connect/http_request/api_dto.dart';

abstract class RequestData<T extends ApiDto> {
  T toDto();
}
