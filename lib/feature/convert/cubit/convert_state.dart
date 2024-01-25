import 'package:equatable/equatable.dart';
import 'package:mp3_convert/feature/convert/data/entity/setting_file.dart';
import 'package:mp3_convert/feature/convert/data/entity/pick_multiple_file.dart';

const minFiles = 1;

sealed class ConvertState extends Equatable implements PickMultipleFile {
  final int maxFiles;
  final List<ConfigConvertFile>? files;

  const ConvertState({
    this.maxFiles = minFiles,
    this.files,
  }) : assert(maxFiles >= minFiles, "maxFiles must be a positive number");

  @override
  List<Object?> get props => [
        files.hashCode,
        maxFiles,
      ];

  @override
  bool get canPickMultipleFile => maxFiles > 1;
}

class ConvertEmptyState extends ConvertState {
  const ConvertEmptyState({super.maxFiles});

  ConvertEmptyState copyWith({
    int? maxFiles,
  }) {
    return ConvertEmptyState(
      maxFiles: maxFiles ?? this.maxFiles,
    );
  }
}

class PickedFileState extends ConvertState {
  const PickedFileState({
    required super.files,
    required super.maxFiles,
  });

  PickedFileState copyWith({
    int? maxFiles,
    List<ConfigConvertFile>? files,
  }) {
    return PickedFileState(
      files: files ?? this.files,
      maxFiles: maxFiles ?? this.maxFiles,
    );
  }
}
