import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mp3_convert/base_presentation/cubit/base_cubit.dart';
import 'package:mp3_convert/data/data_result.dart';
import 'package:mp3_convert/data/entity/failure_entity.dart';
import 'package:mp3_convert/feature/home/cubit/home_state.dart';
import 'package:mp3_convert/feature/home/data/entity/media_type.dart';
import 'package:mp3_convert/feature/home/data/entity/setting_file.dart';
import 'package:mp3_convert/feature/home/data/repository/convert_file_repository.dart';
import 'package:mp3_convert/feature/home/data/repository/picking_file_repository.dart';
import 'package:mp3_convert/feature/home/interface/pick_multiple_file.dart';
import 'package:mp3_convert/main.dart';
import 'package:mp3_convert/util/generate_string.dart';
import 'package:mp3_convert/widget/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class HomeCubit extends Cubit<HomeState> with SafeEmit implements PickMultipleFile {
  HomeCubit() : super(const HomeEmptyState());

  final PickingFileRepository pickingFileRepository = PickingFileRepositoryImpl();
  final ConvertFileRepository convertFileRepository = ConvertFileRepositoryImpl();

  final GenerateString generateString = UUIDGenerateString();
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
    state.files?[index] = SettingFile(
      name: current.name,
      path: current.path,
      destinationType: type,
      uploadId: generateString.getString(),
    );
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

extension UploadFile on HomeCubit {
  Future onConvertAll() async {
    final Directory downloadsDir = await getApplicationDocumentsDirectory();
    log("${downloadsDir.absolute.path}");

    final savedDir = Directory(downloadsDir.absolute.path);
    if (!savedDir.existsSync()) {
      await savedDir.create();
    }
    // convertFileRepository.download(DownloadRequestData(
    //     downloadId: "12a35320-ab76-1e57-85ac-dbf438797fe8", savePath: "${downloadsDir.absolute.path}/test.jpg"));

    final key = await FlutterDownloader.enqueue(
      url: "https://download.samplelib.com/mp3/sample-3s.mp3",
      savedDir: downloadsDir.absolute.path,
      saveInPublicStorage: true,
      fileName: "test.mp3",
    );
    print("Key: ${key}");

    return;
    final settingFile = state.files!.first;
    final addRowResult = await convertFileRepository.addRow(
      AddRowRequestData(
        fileName: settingFile.name,
        socketId: socketId,
        uploadId: settingFile.uploadId!,
        sessionId: "sessionId",
        target: settingFile.destinationType!,
        ext: settingFile.type,
        fileType: "audio",
      ),
    );

    final uploadResult = await convertFileRepository.uploadFile(
      UploadRequestData(
        fileName: settingFile.name,
        uploadId: settingFile.uploadId!,
        filePath: settingFile.path,
        fileType: settingFile.type,
      ),
    );
  }

  Future onConvert(int index, SettingFile file) async {}

  String get socketId => socketChannel.socketId;
}
