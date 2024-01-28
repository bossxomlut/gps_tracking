import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_convert/base_presentation/cubit/base_cubit.dart';
import 'package:mp3_convert/data/data_result.dart';
import 'package:mp3_convert/data/entity/app_file.dart';
import 'package:mp3_convert/data/entity/failure_entity.dart';
import 'package:mp3_convert/feature/convert/cubit/convert_cubit.dart';
import 'package:mp3_convert/feature/convert/data/entity/convert_data.dart';
import 'package:mp3_convert/feature/convert/data/entity/get_mapping_type.dart';
import 'package:mp3_convert/feature/convert/data/entity/mapping_type.dart';
import 'package:mp3_convert/feature/convert/data/entity/media_type.dart';
import 'package:mp3_convert/feature/convert/data/entity/setting_file.dart';
import 'package:mp3_convert/feature/convert/data/repository/convert_file_repository.dart';
import 'package:mp3_convert/feature/convert/data/repository/convert_file_repository_impl.dart';
import 'package:mp3_convert/feature/merger/data/repository/merger_repository_impl.dart';
import 'package:mp3_convert/main.dart';
import 'package:mp3_convert/util/downloader_util.dart';
import 'package:mp3_convert/util/generate_string.dart';

class MergerCubit extends Cubit<MergerState> with SafeEmit implements MappingType {
  MergerCubit() : super(const MergerState()) {
    //use socket to listen convert progress from server
    socketChannel
      ..onConverting(_convertListener)
      ..onDisconnected(_onConvertingError);

    //use downloader to listen download progress from internet
    _downloaderHelper.startListen(_downloadListener);
  }

  final GetMappingType _getMappingType = GetMappingType();

  final DownloaderHelper _downloaderHelper = DownloaderHelper();

  final ConvertFileRepository convertFileRepository = MergerFileRepositoryImpl();

  final GenerateString generateString = UUIDGenerateString();

  String _sessionId = '';

  void addFiles(Iterable<ConfigConvertFile> files) {
    emit(state.copyWith(files: [...?state.files, ...files]));
  }

  void removeFile(AppFile file) {
    final cloneFiles = [...?state.files];
    cloneFiles.remove(file);
    if (cloneFiles.isEmpty) {
      emit(state.copyWith(files: []));
    } else {
      emit(state.copyWith(files: cloneFiles));
    }
  }

  void removeFileByIndex(int index) {
    final cloneFiles = [...?state.files];
    final file = cloneFiles.removeAt(index);
    if (cloneFiles.isEmpty) {
      emit(state.copyWith(files: []));
    } else {
      emit(state.copyWith(files: cloneFiles));
    }
  }

  @override
  Future<ListMediaType?> getMappingType(String sourceType) {
    return _getMappingType.getMappingType(sourceType);
  }

  @override
  Future<String?> getTypeName(String sourceType) {
    return _getMappingType.getTypeName(sourceType);
  }

  void _setFileAtIndex(int index, ConfigConvertFile file) {
    try {
      state.files?[index] = file;

      _refreshPickedFileState();
    } catch (e) {}
  }

  void _refreshPickedFileState() {
    emit(state.copyWith(files: [...?state.files]));
  }
}

extension ConvertListener on MergerCubit {
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
      if (convertData.progress < 100 || convertData.downloadId == null) {
        state.files?[index] = (file as ConvertingFile).copyWith(
          convertProgress: convertData.progress / 100,
        );
      } else {
        state.files?[index] = ConvertedFile(
          downloadId: convertData.downloadId!,
          name: file.name,
          path: file.path,
          destinationType: file.destinationType,
        );
      }

      _refreshPickedFileState();
    }
  }

  void _onConvertingError(_) {
    // _files.forEachIndexed((index, file) {
    //   if (file is ConvertingFile) {
    //     _setFileAtIndex(index, ConvertErrorFile(convertStatusFile: file));
    //   }
    // });
  }
}

extension DownloadListener on MergerCubit {
  void _downloadListener(dynamic data) {
    String id = data[0];

    ///1: _
    ///2: running
    ///3: complete
    ///4: error
    int status = data[1];
    int progress = data[2];
    log("LOL: download listener progress: ${progress}");
    // final f = state.file!;
    // if (f is DownloadedFile) {
    //   emit(state.copyWith(file: f));
    //   return;
    // }
    // print('LOl: ${_checkIsDownloadingFile(f, id) || _checkIsDownloadingFileFromError(f, id)}');
    //
    // if (_checkIsDownloadingFile(f, id) || _checkIsDownloadingFileFromError(f, id)) {
    //   final DownloadingFile file = _getDownloadingFile(f);
    //
    //   if (status == 4) {
    //     emit(state.copyWith(file: ConvertErrorFile(convertStatusFile: f as ConvertStatusFile)));
    //     return;
    //   }
    //
    //   if (progress < 100) {
    //     emit(state.copyWith(file: file.copyWith(downloadProgress: progress / 100)));
    //   } else {
    //     emit(state.copyWith(
    //       file: DownloadedFile(
    //         destinationType: file.destinationType,
    //         path: file.path,
    //         name: file.name,
    //         downloadPath: file.downloadPath,
    //       ),
    //     ));
    //   }
    // }
  }

  // bool _checkIsDownloadingFile(ConfigConvertFile f, String id) {
  //   return f is DownloadingFile && f.downloaderId == id;
  // }
  //
  // bool _checkIsDownloadingFileFromError(ConfigConvertFile f, String id) {
  //   return f is ConvertErrorFile && _checkIsDownloadingFile(f.convertStatusFile, id);
  // }
  //
  // DownloadingFile _getDownloadingFile(ConfigConvertFile f) {
  //   if (f is DownloadingFile) {
  //     return f;
  //   } else if (f is ConvertErrorFile) {
  //     return _getDownloadingFile(f.convertStatusFile);
  //   }
  //   throw Exception("Can not get DownloadingFile");
  // }
}

extension MergerFileProcess on MergerCubit {
  String? get socketId => socketChannel.socketId;

  List<ConfigConvertFile> get _files => state.files ?? [];

  void startMerger() async {
    _sessionId = generateString.getString();

    for (int i = 0; i < _files.length; i++) {
      onAddRow(_files[i], i);
    }
  }

  //add row
  Future onAddRow(ConfigConvertFile file, int index) async {
    final uploadId = generateString.getString();
    final uploadingFile = UploadingFile(
      name: file.name,
      path: file.path,
      destinationType: file.destinationType,
      uploadId: uploadId,
    );

    _setFileAtIndex(index, uploadingFile);

    if (socketId == null) {
      //todo:
      return;
    }

    final addRowResult = await convertFileRepository.addRow(
      AddRowMergerRequestData(
        socketId: socketId!,
        sessionId: _sessionId,
        fileName: file.name,
        uploadId: uploadingFile.uploadId,
        target: state.mediaType?.name ?? MergerState.defaultConvertType,
        ext: uploadingFile.type,
        fileType: '',
        fileSize: FileStat.statSync(file.path).size,
        fileIndex: index,
        totalUpload: _files.length,
      ),
    );

    switch (addRowResult) {
      case SuccessDataResult<FailureEntity, dynamic>():
        final newId = addRowResult.data.toString();
        onUploadFile(uploadingFile, newId);
        return;
      case FailureDataResult<FailureEntity, dynamic>():
        //todo:
        return;
    }
  }

  //upload file

  Future onUploadFile(UploadingFile file, String id) async {
    final uploadResult = await convertFileRepository.uploadFile(
      UploadMergerData(
        fileName: file.name,
        uploadId: id,
        filePath: file.path,
        fileType: file.type,
      ),
    );

    final updateIndex = _files.indexWhere((f) => f is UploadingFile && f.uploadId == file.uploadId);
    if (updateIndex >= 0) {
      switch (uploadResult) {
        case SuccessDataResult<FailureEntity, dynamic>():
          _setFileAtIndex(
            updateIndex,
            UploadedFile(
              name: file.name,
              path: file.path,
              destinationType: file.destinationType,
              uploadId: file.uploadId,
            ),
          );

          _setFileAtIndex(
            updateIndex,
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
          _setFileAtIndex(updateIndex, ConvertErrorFile(convertStatusFile: file));
          return;
      }
    }
  }

  //download file

  void startDownload() {
    // if (state.file is ConvertedFile) {
    //   downloadConvertedFile((state.file as ConvertedFile).downloadId);
    // }
  }

  void downloadConvertedFile(String downloadId) async {
    // final String path = await _getPath();
    //
    // final ConvertedFile file = state.file as ConvertedFile;
    // final fileName = '${file.generateConvertFileName()}';
    // final downloadPath = '$path/$fileName';
    //
    // final downloadingFile = DownloadingFile(
    //   name: file.name,
    //   path: file.path,
    //   destinationType: file.destinationType,
    //   downloadId: file.downloadId,
    //   downloadProgress: .0,
    //   downloadPath: downloadPath,
    //   downloaderId: null,
    // );
    // emit(state.copyWith(file: downloadingFile));
    //
    // final downloadResult = await convertFileRepository.download(
    //   DownloadRequestData(
    //     downloadId: downloadId,
    //     savePath: path,
    //     fileName: fileName,
    //   ),
    // );
    //
    // switch (downloadResult) {
    //   case SuccessDataResult<FailureEntity, String>():
    //     final downloaderId = downloadResult.data;
    //     emit(state.copyWith(file: downloadingFile.copyWith(downloaderId: downloaderId)));
    //     break;
    //   case FailureDataResult<FailureEntity, dynamic>():
    // }
  }

  Future<String> _getPath() async {
    return getPath();
  }
}

class MergerState extends Equatable {
  static const String defaultConvertType = 'mp3';

  final List<ConfigConvertFile>? files;
  final MediaType? mediaType;

  const MergerState({
    this.files,
    this.mediaType,
  });

  @override
  List<Object?> get props => [
        files.hashCode,
        mediaType,
      ];

  MergerState copyWith({
    List<ConfigConvertFile>? files,
    MediaType? mediaType,
  }) {
    return MergerState(
      files: files ?? this.files,
      mediaType: mediaType ?? this.mediaType,
    );
  }
}
