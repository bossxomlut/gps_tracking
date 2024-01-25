import 'package:mp3_convert/data/data_result.dart';
import 'package:mp3_convert/data/entity/failure_entity.dart';
import 'package:mp3_convert/data/entity/feature.dart';
import 'package:mp3_convert/data/request_data.dart';
import 'package:mp3_convert/feature/convert/data/data_source/file_data_source.dart';

abstract class ConvertFileRepository {
  Future<DataResult<FailureEntity, dynamic>> addRow(AddRowRequestData requestData);
  Future<DataResult<FailureEntity, dynamic>> uploadFile(UploadRequestData requestData);
  Future<DataResult<FailureEntity, String>> download(DownloadRequestData requestData);
}

class AddRowRequestData implements RequestData<AddRowDto> {
  final String fileName;
  final String socketId;
  final String uploadId;
  final String sessionId;
  final String target;
  final String ext;
  final String fileType;
  final AppFeature feature;
  final int fileSize;

  AddRowRequestData({
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
  AddRowDto toDto() {
    return AddRowDto(
      fileName: fileName,
      socketId: socketId,
      uploadId: uploadId,
      sessionId: sessionId,
      target: target,
      ext: ext,
      fileType: fileType,
      feature: feature,
      fileSize: fileSize,
    );
  }
}

class UploadRequestData implements RequestData<UploadFileDto> {
  final String fileName;
  final String filePath;
  final String fileType;
  final String uploadId;

  UploadRequestData({
    required this.fileName,
    required this.filePath,
    required this.fileType,
    required this.uploadId,
  });

  @override
  UploadFileDto toDto() {
    return UploadFileDto(
      fileName: fileName,
      filePath: filePath,
      fileType: fileType,
      uploadId: uploadId,
    );
  }
}

class DownloadRequestData implements RequestData<DownloadDto> {
  final String downloadId;
  final String savePath;
  final String fileName;

  DownloadRequestData({
    required this.downloadId,
    required this.savePath,
    required this.fileName,
  });

  @override
  DownloadDto toDto() {
    return DownloadDto(
      downloadId: downloadId,
      savePath: savePath,
      fileName: fileName,
    );
  }
}
