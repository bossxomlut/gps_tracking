import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

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
import 'package:mp3_convert/util/parse_util.dart';
import 'package:mp3_convert/widget/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class ConvertData {
  final String uploadId;
  final double progress;
  final String? downloadId;

  ConvertData({
    required this.uploadId,
    required this.progress,
    this.downloadId,
  });

  factory ConvertData.fromMap(Map map) {
    return ConvertData(
      uploadId: map["uploadId"].toString(),
      progress: map["percent"].toString().parseDouble() ?? 0.0,
      downloadId: map["downloadId"]?.toString(),
    );
  }
}

@pragma('vm:entry-point')
void downloadCallback(String id, int status, int progress) {
  print(
    'Callback on background isolate: '
    'task ($id) is in status ($status) and process ($progress)',
  );

  IsolateNameServer.lookupPortByName('downloader_send_port')?.send([id, status, progress]);
}

class HomeCubit extends Cubit<HomeState> with SafeEmit implements PickMultipleFile {
  HomeCubit() : super(const HomeEmptyState()) {
    socketChannel.onConverting((data) {
      log("onConvert: ${data}");
      if (data is Map) {
        final convertData = ConvertData.fromMap(data as Map);
        int index = state.files?.indexWhere((f) => f.uploadId == convertData.uploadId) ?? -1;
        if (index > -1) {
          if (convertData.progress < 100) {
            //todo: update progress
            state.files?[index] = (state.files?[index] as ConvertFile).copyWith(
              status: ConvertStatus.converting,
              convertProgress: convertData.progress / 100,
            );
            emit(PickedFileState(files: [...?state.files], maxFiles: state.maxFiles));
          } else {
            state.files?[index] = (state.files?[index] as ConvertFile).copyWith(
              status: ConvertStatus.converted,
              downloadId: convertData.downloadId,
              convertProgress: 1.0,
            );
            emit(PickedFileState(files: [...?state.files], maxFiles: state.maxFiles));
          }
        }
      } else if (data is String) {
        log("is String ");
        final convertData = ConvertData.fromMap(jsonDecode(data));
      }
    });

    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      int status = data[1];
      int progress = data[2];

      int index = state.files?.indexWhere((f) => f is ConvertFile && f.downloaderId == id) ?? -1;

      if (index < 0) {
        return;
      }

      if (progress < 100) {
        state.files?[index] = (state.files?[index] as ConvertFile).copyWith(
          status: ConvertStatus.downloading,
          downloadProgress: progress / 100,
        );
      } else {
        state.files?[index] = (state.files?[index] as ConvertFile).copyWith(
          status: ConvertStatus.downloaded,
          downloadProgress: 100,
        );
      }

      emit(PickedFileState(files: [...?state.files], maxFiles: state.maxFiles));
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  final ReceivePort _port = ReceivePort();

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

  void downloadConvertedFile(String downloadId) async {
    int index = state.files?.indexWhere((f) => f is ConvertFile && f.downloadId == downloadId) ?? -1;

    if (index < 0) {
      return;
    }

    state.files?[index] = (state.files?[index] as ConvertFile).copyWith(
      status: ConvertStatus.downloading,
      downloadProgress: 0,
    );
    emit(PickedFileState(files: [...?state.files], maxFiles: state.maxFiles));

    final Directory downloadsDir = await getApplicationDocumentsDirectory();
    log("${downloadsDir.absolute.path}");

    final savedDir = Directory(downloadsDir.absolute.path);
    if (!savedDir.existsSync()) {
      await savedDir.create();
    }

    final id = await FlutterDownloader.enqueue(
      url: "https://cdndl.xyz/media/sv1/api/upload/downloadFile/${downloadId}",
      savedDir: downloadsDir.absolute.path,
      saveInPublicStorage: true,
      fileName: state.files?[index].getConvertFileName(),
    );

    if (id != null) {
      state.files?[index] = (state.files?[index] as ConvertFile).copyWith(
        downloaderId: id,
      );

      emit(PickedFileState(files: [...?state.files], maxFiles: state.maxFiles));
    }

    // FlutterDownloader.registerCallback((id, status, progress) {
    //   print("FlutterDownloader callback: ${status}");
    // });
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
    onConvert(0, state.files![0]);
  }

  Future onConvert(int index, SettingFile file) async {
    var settingFile = file;
    state.files?[index] = ConvertFile(
      name: settingFile.name,
      path: settingFile.path,
      destinationType: settingFile.destinationType,
      uploadId: settingFile.uploadId,
      status: ConvertStatus.uploading,
    );
    emit(PickedFileState(files: [...?state.files], maxFiles: state.maxFiles));

    settingFile = state.files![index];
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

    switch (addRowResult) {
      case FailureDataResult<FailureEntity, dynamic>():
        // TODO: Handle this case.
        return;
      case SuccessDataResult<FailureEntity, dynamic>():
        final uploadResult = await convertFileRepository.uploadFile(
          UploadRequestData(
            fileName: settingFile.name,
            uploadId: settingFile.uploadId!,
            filePath: settingFile.path,
            fileType: settingFile.type,
          ),
        );
        state.files?[index] = (state.files?[index] as ConvertFile).copyWith(
          status: ConvertStatus.converting,
        );
        emit(PickedFileState(files: [...?state.files], maxFiles: state.maxFiles));

        switch (uploadResult) {
          case SuccessDataResult<FailureEntity, dynamic>():
            return;
          case FailureDataResult<FailureEntity, dynamic>():
            return;
        }
    }
  }

  String get socketId => socketChannel.socketId;
}
