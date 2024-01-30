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
import 'package:mp3_convert/feature/convert/cubit/convert_setting_cubit.dart';
import 'package:mp3_convert/feature/convert/data/entity/convert_data.dart';
import 'package:mp3_convert/feature/convert/data/entity/get_mapping_type.dart';
import 'package:mp3_convert/feature/convert/data/entity/mapping_type.dart';
import 'package:mp3_convert/feature/convert/data/entity/media_type.dart';
import 'package:mp3_convert/feature/convert/data/entity/setting_file.dart';
import 'package:mp3_convert/feature/convert/data/repository/convert_file_repository.dart';
import 'package:mp3_convert/feature/convert/data/repository/convert_file_repository_impl.dart';
import 'package:mp3_convert/feature/cutter/data/repository/cutter_file_repository.dart';
import 'package:mp3_convert/feature/cutter/data/repository/cutter_file_repository_impl.dart';
import 'package:mp3_convert/internet_connect/socket/socket.dart';
import 'package:mp3_convert/main.dart';
import 'package:mp3_convert/util/downloader_util.dart';
import 'package:mp3_convert/util/generate_string.dart';

class CutterCubit extends Cubit<CutterState> with SafeEmit implements MappingType {
  CutterCubit() : super(const CutterState()) {
    //use socket to listen convert progress from server
    _socketChannel
      ..startConnection()
      ..onConverting(_convertListener)
      ..onDisconnected(_onConvertingError);

    //use downloader to listen download progress from internet
    _downloaderHelper.startListen(_downloadListener);
  }

  final ConvertChannel _socketChannel = ConvertChannel(convertSocketChannelUrl);

  final GetMappingType _getMappingType = GetMappingType();

  String get currentFileType => state.file?.type ?? '';

  String? get destinationType => state.destinationType;

  final DownloaderHelper _downloaderHelper = DownloaderHelper();

  final ConvertFileRepository convertFileRepository = CutterFileRepositoryImpl();

  final GenerateString generateString = UUIDGenerateString();

  @override
  Future<void> close() {
    _socketChannel.close();
    _downloaderHelper.dispose();
    return super.close();
  }

  void setFile(AppFile file) {
    //if select current file -> ignore
    if (file.path == state.file?.path) {
      return;
    }

    emit(
      CutterState(
        file: ConfigConvertFile(
          name: file.name,
          path: file.path,
          destinationType: file.type.toLowerCase(),
        ),
      ),
    );
    getMappingType(file.type).then((value) {
      if (currentFileType == file.type) {
        emit(state.copyWith(
          listMediaType: value,
        ));
      }
    });
  }

  void setRemoveSelection(bool value) {
    emit(
      state.copyWith(
        isRemoveSelection: value,
      ),
    );
  }

  @override
  Future<ListMediaType?> getMappingType(String sourceType) {
    return _getMappingType.getMappingType(sourceType);
  }

  @override
  Future<String?> getTypeName(String sourceType) {
    return _getMappingType.getTypeName(sourceType);
  }

  void setConvertType(MediaType type) {
    emit(state.copyWith(file: state.file?.copyWith(destinationType: type.name.toLowerCase())));
  }

  void setDurations(Duration start, Duration end) {
    emit(state.copyWith(startTime: start, endTime: end));
  }
}

extension CutterFileProcess on CutterCubit {
  String? get socketId => _socketChannel.socketId;

  void startCut() {
    onAddRow(state.file!);
  }

  //add row
  Future onAddRow(ConfigConvertFile file) async {
    final uploadId = generateString.getString();
    final uploadingFile = UploadingFile(
      name: file.name,
      path: file.path,
      destinationType: file.destinationType,
      uploadId: uploadId,
    );

    emit(state.copyWith(file: uploadingFile));

    if (socketId == null) {
      //todo:
      return;
    }

    final addRowResult = await convertFileRepository.addRow(
      AddRowCutterRequestData(
        socketId: socketId!,
        sessionId: generateString.getString(),
        fileName: uploadingFile.name,
        uploadId: uploadingFile.uploadId,
        target: uploadingFile.destinationType!,
        ext: uploadingFile.type,
        fileType: (await getTypeName(uploadingFile.type)) ?? '',
        fileSize: FileStat.statSync(file.path).size,
        isRemoveSelection: state.isRemoveSelection ?? false,
        startDuration: state.startTime ?? Duration.zero,
        endDuration: state.endTime ?? Duration.zero,
        fadeIn: false,
        fadeOut: false,
      ),
    );

    switch (addRowResult) {
      case SuccessDataResult<FailureEntity, dynamic>():
        if (state.file is UploadingFile) {
          onUploadFile(state.file as UploadingFile);
        }
        return;
      case FailureDataResult<FailureEntity, dynamic>():
        //todo:
        return;
    }
  }

  //upload file

  Future onUploadFile(UploadingFile file) async {
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
        emit(
          state.copyWith(
            file: UploadedFile(
              name: file.name,
              path: file.path,
              destinationType: file.destinationType,
              uploadId: file.uploadId,
            ),
          ),
        );

        emit(
          state.copyWith(
            file: ConvertingFile(
              name: file.name,
              path: file.path,
              destinationType: file.destinationType,
              uploadId: file.uploadId,
              convertProgress: .0,
            ),
          ),
        );
        return;
      case FailureDataResult<FailureEntity, dynamic>():
        emit(
          state.copyWith(
            file: ConvertErrorFile(convertStatusFile: file),
          ),
        );
        return;
    }
  }

  //download file

  void startDownload() {
    if (state.file is ConvertedFile) {
      downloadConvertedFile((state.file as ConvertedFile).downloadId);
    }
  }

  void downloadConvertedFile(String downloadId) async {
    final String path = await _getPath();

    final ConvertedFile file = state.file as ConvertedFile;
    final fileName = 'cutter_${file.generateConvertFileName()}';
    final downloadPath = '$path/$fileName';

    final downloadingFile = DownloadingFile(
      name: file.name,
      path: file.path,
      destinationType: file.destinationType,
      downloadId: file.downloadId,
      downloadProgress: .0,
      downloadPath: downloadPath,
      downloaderId: null,
    );
    emit(state.copyWith(file: downloadingFile));

    final downloadResult = await convertFileRepository.download(
      DownloadRequestData(
        downloadId: downloadId,
        savePath: path,
        fileName: fileName,
      ),
    );

    switch (downloadResult) {
      case SuccessDataResult<FailureEntity, String>():
        final downloaderId = downloadResult.data;
        emit(state.copyWith(file: downloadingFile.copyWith(downloaderId: downloaderId)));
        break;
      case FailureDataResult<FailureEntity, dynamic>():
    }
  }

  Future<String> _getPath() async {
    return getPath();
  }
}

extension ConvertListener on CutterCubit {
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
    final file = state.file;
    if (file is ConvertingFile) {
      if (convertData.progress < 100 || convertData.downloadId == null) {
        emit(state.copyWith(
            file: (file).copyWith(
          convertProgress: convertData.progress / 100,
        )));
      } else {
        emit(state.copyWith(
            file: ConvertedFile(
          downloadId: convertData.downloadId!,
          name: file.name,
          path: file.path,
          destinationType: file.destinationType,
        )));

        if (AutoDownloadSetting().isAutoDownload()) {
          downloadConvertedFile(convertData.downloadId!);
        }
      }
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

extension DownloadListener on CutterCubit {
  void _downloadListener(dynamic data) {
    String id = data[0];

    ///1: _
    ///2: running
    ///3: complete
    ///4: error
    int status = data[1];
    int progress = data[2];
    final f = state.file!;
    if (f is DownloadedFile) {
      emit(state.copyWith(file: f));
      return;
    }

    if (_checkIsDownloadingFile(f, id) || _checkIsDownloadingFileFromError(f, id)) {
      final DownloadingFile file = _getDownloadingFile(f);

      if (status == 4) {
        emit(state.copyWith(file: ConvertErrorFile(convertStatusFile: f as ConvertStatusFile)));
        return;
      }

      if (progress < 100) {
        emit(state.copyWith(file: file.copyWith(downloadProgress: progress / 100)));
      } else {
        emit(state.copyWith(
          file: DownloadedFile(
            destinationType: file.destinationType,
            path: file.path,
            name: file.name,
            downloadPath: file.downloadPath,
          ),
        ));
      }
    }
  }

  bool _checkIsDownloadingFile(ConfigConvertFile f, String id) {
    return f is DownloadingFile && f.downloaderId == id;
  }

  bool _checkIsDownloadingFileFromError(ConfigConvertFile f, String id) {
    return f is ConvertErrorFile && _checkIsDownloadingFile(f.convertStatusFile, id);
  }

  DownloadingFile _getDownloadingFile(ConfigConvertFile f) {
    if (f is DownloadingFile) {
      return f;
    } else if (f is ConvertErrorFile) {
      return _getDownloadingFile(f.convertStatusFile);
    }
    throw Exception("Can not get DownloadingFile");
  }
}

class CutterState extends Equatable {
  final ConfigConvertFile? file;
  final bool? isRemoveSelection;
  final Duration? startTime;
  final Duration? endTime;
  final ListMediaType? listMediaType;

  String? get destinationType => file?.destinationType;

  const CutterState({
    this.file,
    this.isRemoveSelection,
    this.startTime,
    this.endTime,
    this.listMediaType,
  });

  @override
  List<Object?> get props => [
        file,
        isRemoveSelection,
        startTime,
        endTime,
        listMediaType?.hashCode,
      ];

  CutterState copyWith({
    ConfigConvertFile? file,
    bool? isRemoveSelection,
    Duration? startTime,
    Duration? endTime,
    ListMediaType? listMediaType,
  }) {
    return CutterState(
      file: file ?? this.file,
      isRemoveSelection: isRemoveSelection ?? this.isRemoveSelection,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      listMediaType: listMediaType ?? this.listMediaType,
    );
  }
}
