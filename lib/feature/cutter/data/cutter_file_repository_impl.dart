import 'package:mp3_convert/data/data_result.dart';
import 'package:mp3_convert/data/entity/failure_entity.dart';
import 'package:mp3_convert/data/entity/feature.dart';
import 'package:mp3_convert/feature/convert/data/data_source/file_data_source.dart';
import 'package:mp3_convert/feature/convert/data/repository/convert_file_repository.dart';

class AddRowCutterRequestData extends AddRowRequestData {
  AddRowCutterRequestData({
    required super.fileName,
    required super.socketId,
    required super.uploadId,
    required super.sessionId,
    required super.target,
    required super.ext,
    required super.fileType,
    required super.fileSize,
    required this.startDuration,
    required this.endDuration,
    required this.isRemoveSelection,
    required this.fadeIn,
    required this.fadeOut,
  }) : super(feature: AppFeature.cutter);

  final Duration startDuration;
  final Duration endDuration;
  final bool isRemoveSelection;
  final bool fadeIn;
  final bool fadeOut;

  @override
  AddRowDto toDto() {
    return CutterAddRowDto(
      fileName: fileName,
      socketId: socketId,
      uploadId: uploadId,
      sessionId: sessionId,
      target: target,
      ext: ext,
      fileType: fileType,
      feature: feature,
      fileSize: fileSize,
      startDuration: startDuration,
      endDuration: endDuration,
      isRemoveSelection: isRemoveSelection,
      fadeIn: fadeIn,
      fadeOut: fadeOut,
    );
  }
}

class CutterAddRowDto extends AddRowDto {
  CutterAddRowDto({
    required super.fileName,
    required super.socketId,
    required super.uploadId,
    required super.sessionId,
    required super.target,
    required super.ext,
    required super.fileType,
    required super.feature,
    required super.fileSize,
    required this.startDuration,
    required this.endDuration,
    required this.isRemoveSelection,
    required this.fadeIn,
    required this.fadeOut,
  });

  final Duration startDuration;
  final Duration endDuration;
  final bool isRemoveSelection;
  final bool fadeIn;
  final bool fadeOut;

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      "options": {
        "isFaceIn": fadeIn,
        "isFaceOut": fadeOut,
        "isRemoveSelection": isRemoveSelection,
        "from": startDuration.inSeconds.toDouble(),
        "to": endDuration.inSeconds.toDouble(),
      },
      "typeUpload": 1,
    };
  }
}
