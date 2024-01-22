import 'package:dio/dio.dart';
import 'package:mp3_convert/internet_connect/http_request/api.dart';
import 'package:mp3_convert/internet_connect/http_request/api_dto.dart';
import 'package:mp3_convert/internet_connect/http_request/api_response.dart';
import 'package:http_parser/http_parser.dart';

import 'file_data_source.dart';

class FileDataSourceImpl extends FileDataSource {
  final ApiRequestWrapper apiRequestWrapper;

  FileDataSourceImpl(this.apiRequestWrapper);

  @override
  Future<ApiResponse> addRow(AddRowDto dto) {
    return apiRequestWrapper.post(
      "/api/upload/add-row",
      data: dto.toJson(),
    );
  }

  @override
  Future<ApiResponse> downloadFile(DownloadDto dto) {
    return apiRequestWrapper.download("/api/upload/downloadFile/${dto.downloadId}", dto.savePath);
  }

  @override
  Future<ApiResponse> uploadFile(UploadFileDto dto) async {
    FormData formData = FormData.fromMap({
      'file':
          await MultipartFile.fromFile(dto.filePath, filename: dto.fileName, contentType: MediaType('video', 'mp4')),
    });

    return apiRequestWrapper.post(
      "/api/upload/uploadFile",
      data: formData,
      headers: {
        "Fb-X-Token": dto.uploadId,
      },
    );
  }
}
