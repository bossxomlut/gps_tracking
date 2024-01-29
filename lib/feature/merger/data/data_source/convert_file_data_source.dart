import 'package:mp3_convert/di/di.dart';
import 'package:mp3_convert/internet_connect/http_request/api.dart';
import 'package:mp3_convert/internet_connect/http_request/api_response.dart';

abstract class MergeConvertDataSource {
  Future<ApiResponse> getTypes();
}

class MergeConvertDataSourceImpl extends MergeConvertDataSource {
  late final ApiRequestWrapper _apiRequestWrapper;

  ApiRequestWrapper get apiRequestWrapper => _apiRequestWrapper;

  MergeConvertDataSourceImpl({ApiRequestWrapper? apiRequestWrapper}) {
    _apiRequestWrapper = apiRequestWrapper ?? di.get<Mp3ApiRequest>();
  }

  @override
  Future<ApiResponse> getTypes() {
    return apiRequestWrapper.get(
      "/config/get-format-merger",
    );
  }
}
