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

class UploadFileDto extends ApiDto {
  final String fileName;
  final String filePath;
  final String fileType;
  final String uploadId;

  UploadFileDto({required this.fileName, required this.filePath, required this.fileType, required this.uploadId});

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}

class AddRowDto extends ApiDto {
  final String fileName;
  final String socketId;
  final String uploadId;
  final String sessionId;
  final String target;
  final String ext;
  final String fileType;

  AddRowDto({
    required this.fileName,
    required this.socketId,
    required this.uploadId,
    required this.sessionId,
    required this.target,
    required this.ext,
    required this.fileType,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "fileName": fileName,
      "socketId": socketId,
      "uploadId": uploadId,
      "sessionId": sessionId,
      "target": target,
      "ext": ext,
      "fileType": fileType,
    };
  }
}

class DownloadDto extends ApiDto {
  final String downloadId;
  final String savePath;

  DownloadDto({
    required this.downloadId,
    required this.savePath,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "downloadId": downloadId,
      "savePath": savePath,
    };
  }
}
