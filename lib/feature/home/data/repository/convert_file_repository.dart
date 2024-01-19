import 'package:mp3_convert/data/data_result.dart';
import 'package:mp3_convert/data/entity/failure_entity.dart';
import 'package:mp3_convert/feature/home/data/data_source/file_data_source.dart';
import 'package:mp3_convert/feature/home/data/data_source/file_data_source_impl.dart';
import 'package:mp3_convert/internet_connect/http_request/api.dart';
import 'package:mp3_convert/internet_connect/http_request/api_dto.dart';
import 'package:mp3_convert/internet_connect/http_request/api_response.dart';

abstract class ConvertFileRepository {
  Future<DataResult<FailureEntity, dynamic>> addRow(AddRowRequestData requestData);
  Future<DataResult<FailureEntity, dynamic>> uploadFile(UploadRequestData requestData);
  Future<DataResult<FailureEntity, dynamic>> download(DownloadRequestData requestData);
}

class ConvertFileRepositoryImpl extends ConvertFileRepository {
  final FileDataSource _fileDataSource = FileDataSourceImpl(UploadApiRequest());
  @override
  Future<DataResult<FailureEntity, dynamic>> addRow(AddRowRequestData requestData) {
    return _fileDataSource.addRow(requestData.toDto()).then((response) {
      switch (response) {
        case SuccessApiResponse():
          final responseData = response.data;
          if (responseData is Map) {
            return SuccessDataResult(responseData);
          }
        case FailureApiResponse():
          return FailureDataResult(FailureEntity(message: response.message));
        case InternetErrorResponse():
        // TODO: Handle this case.
      }
      return FailureDataResult(FailureEntity(message: response.message));
    });
  }

  @override
  Future<DataResult<FailureEntity, dynamic>> uploadFile(UploadRequestData requestData) {
    return _fileDataSource.uploadFile(requestData.toDto()).then((response) {
      switch (response) {
        case SuccessApiResponse():
          final responseData = response.data;
          return SuccessDataResult(responseData);
        case FailureApiResponse():
          return FailureDataResult(FailureEntity(message: response.message));
        case InternetErrorResponse():
          return FailureDataResult(FailureEntity(message: response.message));
      }
    });
  }

  @override
  Future<DataResult<FailureEntity, dynamic>> download(DownloadRequestData requestData) {
    return _fileDataSource.downloadFile(requestData.toDto()).then((response) {
      switch (response) {
        case SuccessApiResponse():
          final responseData = response.data;
          if (responseData is Map) {
            return SuccessDataResult(responseData);
          }
        case FailureApiResponse():
          return FailureDataResult(FailureEntity(message: response.message));
        case InternetErrorResponse():
        // TODO: Handle this case.
      }
      return FailureDataResult(FailureEntity(message: response.message));
    });
  }
}

abstract class RequestData<T extends ApiDto> {
  T toDto();
}

class AddRowRequestData implements RequestData<AddRowDto> {
  final String fileName;
  final String socketId;
  final String uploadId;
  final String sessionId;
  final String target;
  final String ext;
  final String fileType;

  AddRowRequestData({
    required this.fileName,
    required this.socketId,
    required this.uploadId,
    required this.sessionId,
    required this.target,
    required this.ext,
    required this.fileType,
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

  DownloadRequestData({
    required this.downloadId,
    required this.savePath,
  });

  @override
  DownloadDto toDto() {
    return DownloadDto(
      downloadId: downloadId,
      savePath: savePath,
    );
  }
}
