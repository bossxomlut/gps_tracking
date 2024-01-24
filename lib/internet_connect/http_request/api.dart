import 'dart:async';
import 'dart:developer';

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

  FutureOr<ApiResponse> handleError(Object? error, StackTrace stackTrace) {
    if (error is DioException) {
      log("dio exception: ${error.message}--${error.type}");
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        // TODO: Handle this case.
        case DioExceptionType.sendTimeout:
        // TODO: Handle this case.
        case DioExceptionType.receiveTimeout:
        // TODO: Handle this case.
        case DioExceptionType.badCertificate:
        // TODO: Handle this case.
        case DioExceptionType.badResponse:
        // TODO: Handle this case.
        case DioExceptionType.cancel:
        // TODO: Handle this case.
        case DioExceptionType.connectionError:
        // TODO: Handle this case.
        case DioExceptionType.unknown:
        // TODO: Handle this case.
      }

      return InternetErrorResponse(message: error.message ?? "Internet Error!", data: null);
    }

    return FailureApiResponse(message: error.toString(), data: null);
  }

  Future<ApiResponse> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return dio.get(path, queryParameters: queryParameters).then(getDataResponse).onError(handleError);
  }

  Future<ApiResponse> post(
    String path, {
    required Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return dio
        .post(path, queryParameters: queryParameters, data: data, options: Options(headers: headers))
        .then(getDataResponse)
        .onError(handleError);
  }

  Future<ApiResponse> download(String path, dynamic savePath,
      {Map<String, dynamic>? queryParameters, Map<String, dynamic>? data}) async {
    return dio
        .download(path, savePath, queryParameters: queryParameters, data: data)
        .then(getDataResponse)
        .onError(handleError);
  }
}

class Mp3ApiRequest extends ApiRequestWrapper {
  @override
  String get domainName => "https://cdndl.xyz";
}

class UploadApiRequest extends ApiRequestWrapper {
  static const String _defaultGateWay = "https://cdndl.xyz/media/sv1";

  static String? _remoteConfigGateWay;

  static void loadRemoteConfig() {
    _GetRemoteConfigGateway().get('').then((response) {
      switch (response) {
        case SuccessApiResponse():
          try {
            _remoteConfigGateWay = (response.data as Map)['server']?.toString();
          } catch (e) {}
          break;
        case FailureApiResponse():
        case InternetErrorResponse():
      }
      return response;
    }).catchError((e) {});
  }

  @override
  String get domainName => _remoteConfigGateWay ?? _defaultGateWay;
}

class _GetRemoteConfigGateway extends ApiRequestWrapper {
  @override
  String get domainName => 'https://cdndl.xyz/config/get-server-yt';
}
