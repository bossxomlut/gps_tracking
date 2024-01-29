import 'package:dio/dio.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mp3_convert/di/di.dart';
import 'package:mp3_convert/internet_connect/http_request/api.dart';
import 'package:mp3_convert/internet_connect/http_request/api_dto.dart';
import 'package:mp3_convert/internet_connect/http_request/api_response.dart';
import 'package:http_parser/http_parser.dart';

import 'file_data_source.dart';

class FileDataSourceImpl extends FileDataSource {
  late final ApiRequestWrapper _apiRequestWrapper;

  ApiRequestWrapper get apiRequestWrapper => _apiRequestWrapper;

  FileDataSourceImpl({ApiRequestWrapper? apiRequestWrapper}) {
    _apiRequestWrapper = apiRequestWrapper ?? di.get<UploadApiRequest>();
  }

  @override
  Future<ApiResponse> addRow(AddRowDto dto) {
    return _apiRequestWrapper.post(
      "/api/upload/add-row",
      data: dto.toJson(),
    );
  }

  @override
  Future<ApiResponse> downloadFile(DownloadDto dto) async {
    final id = await FlutterDownloader.enqueue(
      url: "${_apiRequestWrapper.domainName}/api/upload/downloadFile/${dto.downloadId}",
      savedDir: dto.savePath,
      fileName: dto.fileName,
    );

    if (id != null) {
      return SuccessApiResponse(message: 'Start download and downloader id is $id', data: id);
    }

    return FailureApiResponse(message: 'Download by ${dto.downloadId} failed', data: null);
  }

  @override
  Future<ApiResponse> uploadFile(UploadFileDto dto) async {
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(dto.filePath, filename: dto.fileName),
    });

    return _apiRequestWrapper.post(
      "/api/upload/uploadFile",
      data: formData,
      headers: {
        "Fb-X-Token": dto.uploadId,
      },
    );
  }
}
