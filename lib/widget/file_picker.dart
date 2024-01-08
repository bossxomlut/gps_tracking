import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AppFile {
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
}

class UnknownFileTypeException implements Exception {}

class AppFilePicker extends StatelessWidget {
  const AppFilePicker({Key? key, required this.allowMultiple}) : super(key: key);

  final bool allowMultiple;

  Future<List<AppFile>?> opeFilePicker() {
    return FilePicker.platform.pickFiles(type: FileType.media, allowMultiple: allowMultiple).then((filePickerResult) {
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
