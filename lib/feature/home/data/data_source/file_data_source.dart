import 'package:mp3_convert/internet_connect/http_request/api_response.dart';

abstract class FileDataSource {
  Future<ApiResponse> addRow();
  Future<ApiResponse> uploadFile();
  Future<ApiResponse> downloadFile();
}
