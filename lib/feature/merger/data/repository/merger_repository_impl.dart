import 'package:mp3_convert/data/data_result.dart';
import 'package:mp3_convert/data/entity/failure_entity.dart';
import 'package:mp3_convert/data/entity/feature.dart';
import 'package:mp3_convert/feature/convert/data/data_source/file_data_source.dart';
import 'package:mp3_convert/feature/convert/data/repository/convert_file_repository.dart';
import 'package:mp3_convert/feature/convert/data/repository/convert_file_repository_impl.dart';
import 'package:mp3_convert/feature/merger/data/data_source/merger_data_source_impl.dart';

class MergerFileRepositoryImpl extends ConvertFileRepositoryImpl {
  MergerFileRepositoryImpl() : super(fileDataSource: MergerFileDataSourceImpl());

  @override
  Future<DataResult<FailureEntity, dynamic>> addRow(AddRowRequestData requestData) {
    return super.addRow(requestData).then((dataResult) {
      switch (dataResult) {
        case SuccessDataResult<FailureEntity, dynamic>():
          final data = dataResult.data;
          if (data is Map) {
            final id = data["data"].toString();
            return SuccessDataResult(id);
          }
          return FailureDataResult(data);
        case FailureDataResult<FailureEntity, dynamic>():
          return dataResult;
      }
    });
  }
}

class AddRowMergerRequestData extends AddRowRequestData {
  AddRowMergerRequestData({
    required super.fileName,
    required super.socketId,
    required super.uploadId,
    required super.sessionId,
    required super.target,
    required super.ext,
    required super.fileType,
    required super.fileSize,
    required this.fileIndex,
    required this.totalUpload,
    required this.totalDuration,
  }) : super(feature: AppFeature.merger);

  final int fileIndex;
  final int totalUpload;
  final Duration totalDuration;

  @override
  AddRowDto toDto() {
    return MergerAddRowDto(
      fileName: fileName,
      socketId: socketId,
      uploadId: uploadId,
      sessionId: sessionId,
      target: target,
      ext: ext,
      fileType: fileType,
      feature: feature,
      fileSize: fileSize,
      fileIndex: fileIndex,
      totalUpload: totalUpload,
      totalDuration: totalDuration,
    );
  }
}

class MergerAddRowDto extends AddRowDto {
  MergerAddRowDto({
    required super.fileName,
    required super.socketId,
    required super.uploadId,
    required super.sessionId,
    required super.target,
    required super.ext,
    required super.fileType,
    required super.feature,
    required super.fileSize,
    required this.fileIndex,
    required this.totalUpload,
    required this.totalDuration,
  });

  final int fileIndex;
  final int totalUpload;
  final Duration totalDuration;
  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      "fileIndex": fileIndex,
      "totalUpload": totalUpload,
      "duration": totalDuration.inMilliseconds / 1000,
      "options": '{"from":0,"to":${totalDuration.inMilliseconds / 1000}',
    };
  }
}

class UploadMergerData extends UploadRequestData {
  UploadMergerData({
    required super.fileName,
    required super.filePath,
    required super.fileType,
    required super.uploadId,
  });
}

class UploadMergerFileDto extends UploadFileDto {
  UploadMergerFileDto({
    required super.fileName,
    required super.filePath,
    required super.fileType,
    required super.uploadId,
  });
}
