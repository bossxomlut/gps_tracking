import 'package:dio/dio.dart';

import 'api_response.dart';

abstract class ApiRequestWrapper extends Request {
  String get domainName;

  @override
  Future<ApiResponse> get(String path, {Map<String, dynamic>? queryParameters}) {
    return super.get(domainName + path, queryParameters: queryParameters);
  }

  @override
  Future<ApiResponse> post(String path, {required Map<String, dynamic> data, Map<String, dynamic>? queryParameters}) {
    return super.post(domainName + path, data: data, queryParameters: queryParameters);
  }

  @override
  Future<ApiResponse> download(String path, savePath, Map<String, dynamic> queryParameters, Map<String, dynamic> data) {
    return super.download(domainName + path, savePath, queryParameters, data);
  }
}

abstract class Request {
  Dio dio = Dio();

  ApiResponse getDataResponse(Response dioResponse) {
    if (dioResponse.statusCode == 200) {
      return SuccessApiResponse(message: dioResponse.statusMessage ?? "", data: dioResponse.data);
    }

    //todo: something else status must implement if necessary

    return FailureApiResponse(message: dioResponse.statusMessage ?? "", data: dioResponse.data);
  }

  Future<ApiResponse> get(String path, {Map<String, dynamic>? queryParameters}) async {
    final dioResponse = await dio.get(path, queryParameters: queryParameters);

    return getDataResponse(dioResponse);
  }

  Future<ApiResponse> post(
    String path, {
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final dioResponse = await dio.post(
      path,
      queryParameters: queryParameters,
      data: data,
    );

    return getDataResponse(dioResponse);
  }

  Future<ApiResponse> download(
      String path, dynamic savePath, Map<String, dynamic> queryParameters, Map<String, dynamic> data) async {
    final dioResponse = await dio.download(
      path,
      savePath,
      queryParameters: queryParameters,
      data: data,
    );

    return getDataResponse(dioResponse);
  }
}

class Mp3ApiRequest extends ApiRequestWrapper {
  @override
  String get domainName => "https://cdndl.xyz";
}
