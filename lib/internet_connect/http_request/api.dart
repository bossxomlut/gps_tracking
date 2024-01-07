import 'package:dio/dio.dart';

import 'api_response.dart';

class ApiWrapper extends _Request {}

abstract class _Request {
  Dio dio = Dio();

  Future<ApiResponse> get(String path, Map<String, dynamic> queryParameters) async {
    final dioResponse = await dio.get(path, queryParameters: queryParameters);

    return SuccessApiResponse(message: "message", data: "data");
  }

  Future<ApiResponse> post(String path, Map<String, dynamic> queryParameters, Map<String, dynamic> data) async {
    final dioResponse = await dio.post(
      path,
      queryParameters: queryParameters,
      data: data,
    );

    return SuccessApiResponse(message: "message", data: "data");
  }

  Future<ApiResponse> download(
      String path, dynamic savePath, Map<String, dynamic> queryParameters, Map<String, dynamic> data) async {
    final dioResponse = await dio.download(
      path,
      savePath,
      queryParameters: queryParameters,
      data: data,
    );

    return SuccessApiResponse(message: "message", data: "data");
  }
}

// abstract class PostRequest {
//   Future<ApiResponse> post(String path, Map<String, dynamic> queryParameters, Map<String, dynamic> data) async {
//     Dio dio = Dio();
//
//     final dioResponse = await dio.post(
//       path,
//       queryParameters: queryParameters,
//       data: data,
//     );
//
//     return SuccessApiResponse(message: "message", data: "data");
//   }
// }
//
// abstract class DownloadRequest {
//   Future<ApiResponse> post(
//       String path, dynamic savePath, Map<String, dynamic> queryParameters, Map<String, dynamic> data) async {
//     Dio dio = Dio();
//
//     final dioResponse = await dio.download(
//       path,
//       savePath,
//       queryParameters: queryParameters,
//       data: data,
//     );
//
//     return SuccessApiResponse(message: "message", data: "data");
//   }
// }
