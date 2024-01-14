import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mp3_convert/internet_connect/http_request/api_interceptor.dart';

import 'api_response.dart';

abstract class ApiRequestWrapper extends Request {
  String get domainName;

  @override
  Future<ApiResponse> get(String path, {Map<String, dynamic>? queryParameters}) {
    return super.get(domainName + path, queryParameters: queryParameters);
  }

  @override
  Future<ApiResponse> post(String path,
      {required Object? data, Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers}) {
    return super.post(domainName + path, data: data, queryParameters: queryParameters, headers: headers);
  }

  @override
  Future<ApiResponse> download(String path, savePath,
      {Map<String, dynamic>? queryParameters, Map<String, dynamic>? data}) {
    return super.download(domainName + path, savePath);
  }
}

abstract class Request {
  Request() {
    if (!kReleaseMode) {
      dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
      dio.interceptors.add(LogResponseInterceptor());
    }
  }

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
    required Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    final dioResponse = await dio.post(
      path,
      queryParameters: queryParameters,
      data: data,
      options: Options(headers: headers),
    );

    return getDataResponse(dioResponse);
  }

  Future<ApiResponse> download(String path, dynamic savePath,
      {Map<String, dynamic>? queryParameters, Map<String, dynamic>? data}) async {
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

class UploadApiRequest extends ApiRequestWrapper {
  @override
  String get domainName => "https://cdndl.xyz/media/sv1";
}
