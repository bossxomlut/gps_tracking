import 'package:gps_speed/internet_connect/http_request/api_dto.dart';

abstract class RequestData<T extends ApiDto> {
  T toDto();
}
