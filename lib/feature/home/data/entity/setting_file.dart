import 'package:mp3_convert/widget/file_picker.dart';

enum ConvertStatus {
  uploading,
  uploaded,
  converting,
  converted,
  downloading,
  downloaded,
}

abstract class Progress {
  final int progress;

  Progress(this.progress) {
    assert(progress >= 0);
    assert(progress <= 100);
  }
}

class SettingFile extends AppFile {
  SettingFile({
    required super.name,
    required super.path,
    this.destinationType,
    this.uploadId,
  });

  final String? destinationType;
  final String? uploadId;

  SettingFile copyWith({
    String? name,
    String? path,
    String? destinationType,
    String? uploadId,
  }) {
    return SettingFile(
      name: name ?? this.name,
      path: path ?? this.path,
      destinationType: destinationType ?? this.destinationType,
      uploadId: uploadId ?? this.uploadId,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        destinationType,
        uploadId,
      ];

  String getConvertFileName() {
    return name.substring(0, name.length - type.length) + destinationType!;
  }
}

class ConvertFile extends SettingFile {
  final ConvertStatus status;
  final String? downloadId;
  final double? convertProgress;
  final double? downloadProgress;
  final String? downloaderId;
  final String? downloadPath;

  ConvertFile({
    required super.name,
    required super.path,
    super.destinationType,
    super.uploadId,
    required this.status,
    this.downloadId,
    this.convertProgress,
    this.downloadProgress,
    this.downloaderId,
    this.downloadPath,
  });

  @override
  ConvertFile copyWith({
    ConvertStatus? status,
    String? name,
    String? path,
    String? destinationType,
    String? uploadId,
    String? downloadId,
    String? downloaderId,
    double? convertProgress,
    double? downloadProgress,
    String? downloadPath,
  }) {
    return ConvertFile(
      name: name ?? this.name,
      path: path ?? this.path,
      destinationType: destinationType ?? this.destinationType,
      uploadId: uploadId ?? this.uploadId,
      status: status ?? this.status,
      downloadId: downloadId ?? this.downloadId,
      downloaderId: downloaderId ?? this.downloaderId,
      convertProgress: convertProgress ?? this.convertProgress,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      downloadPath: downloadPath ?? this.downloadPath,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        status,
        downloadId,
        downloaderId,
        convertProgress,
        downloadProgress,
        downloadPath,
      ];
}
