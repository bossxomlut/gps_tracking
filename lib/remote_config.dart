import 'dart:developer';

import 'package:mp3_convert/internet_connect/http_request/api.dart';
import 'package:mp3_convert/internet_connect/http_request/api_response.dart';

class RemoteConfig {
  RemoteConfig._();

  static final RemoteConfig _instance = RemoteConfig._();

  factory RemoteConfig() => _instance;

  static const String _serverKey = 'server';
  static const String _limitFileKey = 'limitFile';
  static const String _maxLengthKey = 'maxLength';

  static const Map<String, dynamic> _configDefaultData = {
    _serverKey: "https://cdndl.xyz/media/sv1",
    _limitFileKey: 5,
    _maxLengthKey: 200000000,
  };

  Map<String, dynamic> _configData = _configDefaultData;

  String get server => _getValue<String>(_serverKey);
  int get limitFile => _getValue<int>(_limitFileKey);
  int get maxLength => _getValue<int>(_maxLengthKey);

  T _getValue<T>(String key) {
    final defaultValue = _configDefaultData[key];

    assert(defaultValue != null);
    assert(defaultValue.runtimeType != T);

    final configValue = _configData[key];

    if (configValue == null || configValue.runtimeType != T) {
      _configData[key] = defaultValue;
      return defaultValue;
    }

    return configValue;
  }

  Future getRemoteConfig() async {
    try {
      await _GetRemoteConfigGateway().get('').then(_updateConfigurations);
      log("getRemoteConfig: done");
    } catch (e) {
      log("getRemoteConfig: have an error");
    }
  }

  void _updateConfigurations(dynamic response) {
    switch (response) {
      case SuccessApiResponse():
        try {
          _configData = response.data as Map<String, dynamic>;
        } catch (e) {
          log("getRemoteConfig - remote config data is not mapping type");
        }
        break;
      case FailureApiResponse():
      case InternetErrorResponse():
      default:
        break;
    }
  }
}

class _GetRemoteConfigGateway extends ApiRequestWrapper {
  @override
  String get domainName => 'https://cdndl.xyz/config/get-server-yt';
}
