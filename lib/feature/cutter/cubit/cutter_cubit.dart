import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_convert/base_presentation/cubit/base_cubit.dart';
import 'package:mp3_convert/data/entity/app_file.dart';
import 'package:mp3_convert/feature/convert/data/entity/get_mapping_type.dart';
import 'package:mp3_convert/feature/convert/data/entity/mapping_type.dart';
import 'package:mp3_convert/feature/convert/data/entity/media_type.dart';
import 'package:mp3_convert/feature/convert/data/entity/setting_file.dart';

class CutterCubit extends Cubit<CutterState> with SafeEmit implements MappingType {
  CutterCubit() : super(const CutterState());
  final GetMappingType _getMappingType = GetMappingType();
  String get currentFileType => state.file?.type ?? '';

  String? get destinationType => state.destinationType;

  void setFile(AppFile file) {
    emit(
      state.copyWith(
        file: ConfigConvertFile(
          name: file.name,
          path: file.path,
          destinationType: file.type,
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
    emit(state.copyWith(file: state.file?.copyWith(destinationType: type.name)));
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
