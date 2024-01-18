import 'package:equatable/equatable.dart';
import 'package:mp3_convert/feature/home/data/entity/setting_file.dart';
import 'package:mp3_convert/feature/home/data/entity/pick_multiple_file.dart';
import 'package:mp3_convert/widget/file_picker.dart';

const minFiles = 1;

sealed class HomeState extends Equatable implements PickMultipleFile {
  final int maxFiles;
  final List<ConfigConvertFile>? files;

  const HomeState({
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

class HomeEmptyState extends HomeState {
  const HomeEmptyState({super.maxFiles});

  HomeEmptyState copyWith({
    int? maxFiles,
  }) {
    return HomeEmptyState(
      maxFiles: maxFiles ?? this.maxFiles,
    );
  }
}

class PickedFileState extends HomeState {
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
