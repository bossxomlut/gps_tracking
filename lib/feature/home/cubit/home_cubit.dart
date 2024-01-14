import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_convert/base_presentation/cubit/base_cubit.dart';
import 'package:mp3_convert/data/data_result.dart';
import 'package:mp3_convert/data/entity/failure_entity.dart';
import 'package:mp3_convert/feature/home/cubit/home_state.dart';
import 'package:mp3_convert/feature/home/data/entity/media_type.dart';
import 'package:mp3_convert/feature/home/data/entity/setting_file.dart';
import 'package:mp3_convert/feature/home/data/repository/picking_file_repository.dart';
import 'package:mp3_convert/feature/home/interface/pick_multiple_file.dart';
import 'package:mp3_convert/widget/file_picker.dart';

class HomeCubit extends Cubit<HomeState> with SafeEmit implements PickMultipleFile {
  HomeCubit() : super(const HomeEmptyState());

  final PickingFileRepository pickingFileRepository = PickingFileRepositoryImpl();

  void setPickedFiles(List<SettingFile> files) {
    final newFiles = validateFiles(files);

    if (newFiles.isEmpty) {
      return;
    }

    emit(PickedFileState(files: newFiles, maxFiles: state.maxFiles));
  }

  List<SettingFile> validateFiles(List<SettingFile> files) {
    List<SettingFile> newFiles = [];

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

  Future<ListMediaType?> getMappingType(String sourceType) {
    return pickingFileRepository.mappingType(state.files!.first.type).then((result) {
      switch (result) {
        case SuccessDataResult<FailureEntity, ListMediaType>():
          return result.data;
        case FailureDataResult<FailureEntity, ListMediaType>():
          return null;
      }
    });
  }

  void updateDestinationType(
    int index,
    SettingFile current,
    String type,
  ) {
    state.files?[index] = SettingFile(name: current.name, path: current.path, destinationType: type);
    emit(PickedFileState(files: [...?state.files], maxFiles: state.maxFiles));
  }
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
