import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_convert/base_presentation/cubit/base_cubit.dart';
import 'package:mp3_convert/feature/home/cubit/home_state.dart';
import 'package:mp3_convert/feature/home/interface/pick_multiple_file.dart';
import 'package:mp3_convert/widget/file_picker.dart';

class HomeCubit extends Cubit<HomeState> with SafeEmit implements PickMultipleFile {
  HomeCubit() : super(const HomeEmptyState());

  void setPickedFiles(List<AppFile> files) {
    final newFiles = validateFiles(files);

    if (newFiles.isEmpty) {
      return;
    }

    emit(PickedFileState(files: newFiles, maxFiles: state.maxFiles));
  }

  List<AppFile> validateFiles(List<AppFile> files) {
    List<AppFile> newFiles = [];

    for (var file in files) {
      try {
        file.type;
        newFiles.add(file);
      } catch (e) {
        if (e is UnknownFileTypeException) {
          log("Have unknown file type");
        } else {
          log("validate file type: ${e.toString()}");
        }
      }
    }

    return newFiles;
  }

  @override
  bool get canPickMultipleFile => state.canPickMultipleFile;
}

extension FileManager on HomeCubit {
  void removeFile(AppFile file) {
    final cloneFiles = [...?state.files];
    cloneFiles.remove(file);
    if (cloneFiles.isEmpty) {
      emit(HomeEmptyState(maxFiles: state.maxFiles));
    } else {
      emit(PickedFileState(
        maxFiles: state.maxFiles,
        files: cloneFiles,
      ));
    }
  }
}
