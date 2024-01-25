import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_convert/base_presentation/cubit/base_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConvertSettingCubit extends Cubit<ConvertSettingState> with SafeEmit {
  ConvertSettingCubit() : super(ConvertSettingState()) {
    _init();
  }

  final AutoDownloadSetting _autoDownloadSetting = AutoDownloadSetting();

  void _init() async {
    //load auto download
    emit(state.copyWith(isAutoDownload: _autoDownloadSetting.isAutoDownload()));
  }

  bool isAutoDownload() {
    return _autoDownloadSetting.isAutoDownload();
  }

  void setAutoDownload(bool value) {
    _autoDownloadSetting.setAutoDownload(value);
    emit(state.copyWith(isAutoDownload: isAutoDownload()));
  }
}

class AutoDownloadSetting {
  AutoDownloadSetting._() {
    _init();
  }

  static final AutoDownloadSetting _i = AutoDownloadSetting._();

  factory AutoDownloadSetting() {
    return _i;
  }

  void _init() async {
    ref ??= await SharedPreferences.getInstance();
  }

  SharedPreferences? ref;

  final _isAutoDownloadKey = 'auto_download_key';

  bool isAutoDownload() {
    return ref?.getBool(_isAutoDownloadKey) ?? false;
  }

  void setAutoDownload(bool value) {
    ref?.setBool(_isAutoDownloadKey, value);
  }
}

class ConvertSettingState {
  final bool isAutoDownload;

  ConvertSettingState({this.isAutoDownload = false});

  ConvertSettingState copyWith({
    bool? isAutoDownload,
  }) {
    return ConvertSettingState(
      isAutoDownload: isAutoDownload ?? this.isAutoDownload,
    );
  }
}
