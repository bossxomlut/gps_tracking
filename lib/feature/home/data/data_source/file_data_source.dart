import 'package:mp3_convert/feature/home/data/data_source/file_data_source_impl.dart';
import 'package:mp3_convert/internet_connect/http_request/api_dto.dart';
import 'package:mp3_convert/internet_connect/http_request/api_response.dart';

abstract class FileDataSource {
  Future<ApiResponse> addRow(AddRowDto dto);
  Future<ApiResponse> uploadFile(UploadFileDto dto);
  Future<ApiResponse> downloadFile(DownloadDto dto);
}
