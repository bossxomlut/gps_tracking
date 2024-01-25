import 'package:mp3_convert/data/entity/feature.dart';
import 'package:mp3_convert/feature/home/data/data_source/file_data_source_impl.dart';
import 'package:mp3_convert/internet_connect/http_request/api_dto.dart';
import 'package:mp3_convert/internet_connect/http_request/api_response.dart';

abstract class FileDataSource {
  Future<ApiResponse> addRow(AddRowDto dto);
  Future<ApiResponse> uploadFile(UploadFileDto dto);
  Future<ApiResponse> downloadFile(DownloadDto dto);
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
  final AppFeature feature;
  final int fileSize;

  AddRowDto({
    required this.fileName,
    required this.socketId,
    required this.uploadId,
    required this.sessionId,
    required this.target,
    required this.ext,
    required this.fileType,
    required this.feature,
    required this.fileSize,
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
      "actionType": feature.number,
      "fileSize": fileSize,
    };
  }
}

class DownloadDto extends ApiDto {
  final String downloadId;
  final String savePath;
  final String fileName;

  DownloadDto({
    required this.downloadId,
    required this.savePath,
    required this.fileName,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "downloadId": downloadId,
      "savePath": savePath,
      "fileName": fileName,
    };
  }
}
