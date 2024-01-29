import 'package:dio/dio.dart';
import 'package:mp3_convert/feature/convert/data/data_source/file_data_source.dart';
import 'package:mp3_convert/feature/convert/data/data_source/file_data_source_impl.dart';
import 'package:mp3_convert/internet_connect/http_request/api_response.dart';

class CutterFileDataSourceImpl extends FileDataSourceImpl {
  @override
  Future<ApiResponse> uploadFile(UploadFileDto dto) async {
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        dto.filePath,
        filename: dto.fileName,
      ),
    });

    return apiRequestWrapper.post(
      "/api/cutter/upload",
      data: formData,
      headers: {
        "Fb-X-Token": dto.uploadId,
      },
    );
  }
}
