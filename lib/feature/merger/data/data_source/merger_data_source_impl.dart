import 'package:dio/dio.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mp3_convert/feature/convert/data/data_source/file_data_source.dart';
import 'package:mp3_convert/feature/convert/data/data_source/file_data_source_impl.dart';
import 'package:mp3_convert/internet_connect/http_request/api_response.dart';

class MergerFileDataSourceImpl extends FileDataSourceImpl {
  @override
  Future<ApiResponse> uploadFile(UploadFileDto dto) async {
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        dto.filePath,
        filename: dto.fileName,
      ),
    });

    return apiRequestWrapper.post(
      "/api/merger/upload",
      data: formData,
      headers: {
        "Fb-X-Token": dto.uploadId,
      },
    );
  }

  @override
  Future<ApiResponse> downloadFile(DownloadDto dto) async {
    final id = await FlutterDownloader.enqueue(
      url: "${apiRequestWrapper.domainName}/api/merger/download-file/${dto.downloadId}",
      savedDir: dto.savePath,
      fileName: dto.fileName,
    );

    if (id != null) {
      return SuccessApiResponse(message: 'Start download and downloader id is $id', data: id);
    }

    return FailureApiResponse(message: 'Download by ${dto.downloadId} failed', data: null);
  }
}
