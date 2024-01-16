import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AppFile extends Equatable {
  final String name;
  final String path;

  AppFile({required this.name, required this.path});

  String get type => _getFileType();

  String _getFileType() {
    final l = path.split(".");
    if (l.length > 1) {
      return l.last;
    }

    throw UnknownFileTypeException();
  }

  @override
  List<Object?> get props => [
        name,
        path,
      ];
}

class UnknownFileTypeException implements Exception {}

class AppFilePicker extends StatelessWidget {
  const AppFilePicker({Key? key, required this.allowMultiple, required this.fileType}) : super(key: key);

  final bool allowMultiple;
  final FileType fileType;

  Future<List<AppFile>?> opeFilePicker() {
    return FilePicker.platform.pickFiles(type: fileType, allowMultiple: allowMultiple).then((filePickerResult) {
      return filePickerResult?.files
          .map(
            (file) => AppFile(name: file.name, path: file.path ?? ""),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

class VideoFilePicker extends AppFilePicker {
  const VideoFilePicker({
    super.key,
    required super.allowMultiple,
  }) : super(fileType: FileType.video);
}

class AudioFilePicker extends AppFilePicker {
  const AudioFilePicker({
    super.key,
    required super.allowMultiple,
  }) : super(fileType: FileType.audio);
}
