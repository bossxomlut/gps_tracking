import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mp3_convert/base_presentation/cubit/base_cubit.dart';
import 'package:mp3_convert/data/data_result.dart';
import 'package:mp3_convert/data/entity/failure_entity.dart';
import 'package:mp3_convert/feature/home/cubit/home_state.dart';
import 'package:mp3_convert/feature/home/data/entity/convert_data.dart';
import 'package:mp3_convert/feature/home/data/entity/get_mapping_type.dart';
import 'package:mp3_convert/feature/home/data/entity/mapping_type.dart';
import 'package:mp3_convert/feature/home/data/entity/media_type.dart';
import 'package:mp3_convert/feature/home/data/entity/setting_file.dart';
import 'package:mp3_convert/feature/home/data/repository/convert_file_repository.dart';
import 'package:mp3_convert/feature/home/data/repository/picking_file_repository.dart';
import 'package:mp3_convert/feature/home/data/entity/pick_multiple_file.dart';
import 'package:mp3_convert/main.dart';
import 'package:mp3_convert/util/downloader_util.dart';
import 'package:mp3_convert/util/generate_string.dart';
import 'package:mp3_convert/util/parse_util.dart';
import 'package:mp3_convert/widget/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class HomeCubit extends Cubit<HomeState> with SafeEmit implements PickMultipleFile, MappingType {
  final GetMappingType _getMappingType = GetMappingType();

  final ConvertFileRepository convertFileRepository = ConvertFileRepositoryImpl();

  final DownloaderHelper _downloaderHelper = DownloaderHelper();

  final GenerateString generateString = UUIDGenerateString();

  HomeCubit() : super(const HomeEmptyState()) {
    socketChannel.onConverting(_convertListener);

    _downloaderHelper.startListen(_downloadListener);
  }

  void _convertListener(dynamic data) {
    log("onConvert listener: ${data}");
    if (data is Map) {
      _updateConvertingProgress(data);
    } else if (data is String) {
      try {
        final decodeData = jsonDecode(data);
        if (decodeData is Map) {
          _updateConvertingProgress(decodeData);
        }
      } catch (e) {
        log("onConvert decode string error: $e");
      }
    }
  }

  void _updateConvertingProgress(Map data) {
    final convertData = ConvertData.fromMap(data);
    int index = state.files?.indexWhere((f) => f is ConvertingFile && f.uploadId == convertData.uploadId) ?? -1;
    if (index > -1) {
      final file = state.files![index];
      if (convertData.progress < 100) {
        state.files?[index] = (file as ConvertingFile).copyWith(
          convertProgress: convertData.progress / 100,
        );
      } else {
        state.files?[index] = ConvertedFile(
          downloadId: convertData.downloadId,
          name: file.name,
          path: file.path,
          destinationType: file.destinationType,
        );
      }
      _refreshPickedFileState();
    }
  }

  void _downloadListener(dynamic data) {
    String id = data[0];
    int status = data[1];
    int progress = data[2];
    int index = state.files?.indexWhere((f) => f is DownloadingFile && f.downloaderId == id) ?? -1;

    if (index < 0) {
      return;
    }

    final DownloadingFile file = state.files![index] as DownloadingFile;

    if (progress < 100) {
      state.files?[index] = file.copyWith(
        downloadProgress: progress / 100,
      );
    } else {
      state.files?[index] = DownloadedFile(
        destinationType: file.destinationType,
        path: file.path,
        name: file.name,
        downloadPath: file.downloadPath,
      );
    }

    emit(PickedFileState(files: [...?state.files], maxFiles: state.maxFiles));
  }

  @override
  Future<void> close() {
    _downloaderHelper.dispose();
    return super.close();
  }

  @override
  bool get canPickMultipleFile => state.canPickMultipleFile;

  @override
  Future<ListMediaType?> getMappingType(String sourceType) {
    return _getMappingType.getMappingType(sourceType);
  }

  void _refreshPickedFileState() {
    emit(PickedFileState(files: [...?state.files], maxFiles: state.maxFiles));
  }

  void _setFileAtIndex(int index, ConfigConvertFile file) {
    state.files?[index] = file;

    _refreshPickedFileState();
  }
}

extension FileManager on HomeCubit {
  void setPickedFiles(List<ConfigConvertFile> files) {
    final newFiles = validateFiles(files);

    if (newFiles.isEmpty) {
      return;
    }

    emit(PickedFileState(files: newFiles, maxFiles: state.maxFiles));
  }

  void updateDestinationType(
    int index,
    ConfigConvertFile current,
    String type,
  ) {
    _setFileAtIndex(
      index,
      ConfigConvertFile(
        name: current.name,
        path: current.path,
        destinationType: type,
      ),
    );
  }

  List<ConfigConvertFile> validateFiles(List<ConfigConvertFile> files) {
    List<ConfigConvertFile> newFiles = [];

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

extension ConvertingFileProcess on HomeCubit {
  String get socketId => socketChannel.socketId;

  Future onConvertAll() async {
    onConvert(0, state.files![0]);
  }

  //add row
  Future onAddRow(int index, ConfigConvertFile file) async {
    final uploadingFile = UploadingFile(
      name: file.name,
      path: file.path,
      destinationType: file.destinationType,
      uploadId: generateString.getString(),
    );

    _setFileAtIndex(index, uploadingFile);

    final addRowResult = await convertFileRepository.addRow(
      AddRowRequestData(
        socketId: socketId,
        sessionId: "sessionId", //todo: sessionId cần thông tin nó làm cái gì
        fileName: uploadingFile.name,
        uploadId: uploadingFile.uploadId,
        target: uploadingFile.destinationType!,
        ext: uploadingFile.type,
        fileType: "audio", //todo: cần điều chỉnh lại cái chổ này theo API
      ),
    );

    switch (addRowResult) {
      case SuccessDataResult<FailureEntity, dynamic>():
        onUploadFile(index, uploadingFile);
        return;
      case FailureDataResult<FailureEntity, dynamic>():
        // TODO: Handle this case.
        return;
    }
  }

  //upload file

  Future onUploadFile(int index, UploadingFile file) async {
    final uploadResult = await convertFileRepository.uploadFile(
      UploadRequestData(
        fileName: file.name,
        uploadId: file.uploadId,
        filePath: file.path,
        fileType: file.type,
      ),
    );

    switch (uploadResult) {
      case SuccessDataResult<FailureEntity, dynamic>():
        _setFileAtIndex(
          index,
          UploadedFile(
            name: file.name,
            path: file.path,
            destinationType: file.destinationType,
            uploadId: file.uploadId,
          ),
        );

        _setFileAtIndex(
          index,
          ConvertingFile(
            name: file.name,
            path: file.path,
            destinationType: file.destinationType,
            uploadId: file.uploadId,
            convertProgress: .0,
          ),
        );

        return;
      case FailureDataResult<FailureEntity, dynamic>():
        return;
    }
  }

  //convert file
  Future onConvert(int index, ConfigConvertFile file) async {
    onAddRow(index, file);
  }

  //download file

  void downloadConvertedFile(String downloadId) async {
    int index = state.files?.indexWhere((f) => f is ConvertedFile && f.downloadId == downloadId) ?? -1;

    if (index < 0) {
      return;
    }

    final String path = await _getPath();

    final ConvertedFile file = state.files![index] as ConvertedFile;

    final downloadingFile = DownloadingFile(
      name: file.name,
      path: file.path,
      destinationType: file.destinationType,
      downloadProgress: .0,
      downloadPath: '$path/${file.getConvertFileName()}',
      downloaderId: null,
    );

    _setFileAtIndex(index, downloadingFile);

    final id = await FlutterDownloader.enqueue(
      url: "https://cdndl.xyz/media/sv1/api/upload/downloadFile/$downloadId",
      savedDir: path,
      saveInPublicStorage: true,
      fileName: downloadingFile.getConvertFileName(),
    );

    log("added ${id} to FlutterDownloader.enqueue");

    if (id != null) {
      _setFileAtIndex(index, downloadingFile.copyWith(downloaderId: id));
    } else {
      //todo: handle when cannot get downloader id
    }
  }

  Future<String> _getPath() async {
    final Directory downloadsDir = await getApplicationDocumentsDirectory();

    final savedDir = Directory(downloadsDir.absolute.path);

    if (!savedDir.existsSync()) {
      await savedDir.create();
    }
    return downloadsDir.absolute.path;
  }
}
