import 'package:mp3_convert/internet_connect/http_request/api.dart';
import 'package:mp3_convert/internet_connect/http_request/api_response.dart';
import 'package:mp3_convert/util/parse_util.dart';

class RemoteConfig {
  RemoteConfig._();

  static final RemoteConfig _i = RemoteConfig._();

  factory RemoteConfig() {
    return _i;
  }

  static const String _defaultGateWay = "https://cdndl.xyz/media/sv1";
  static const int _defaultMaxSubmitFile = 5;
  static const int _defaultMaxSizePerFile = 200000000;

  String _server = _defaultGateWay;
  int _limitFile = _defaultMaxSubmitFile;
  int _maxLength = _defaultMaxSizePerFile;

  String get server => _server;
  int get limitFile => _limitFile;
  int get maxLength => _maxLength;

  Future getRemoteConfig() async {
    return _GetRemoteConfigGateway().get('').then((response) {
      switch (response) {
        case SuccessApiResponse():
          try {
            final RemoteConfigData responseData = RemoteConfigData.fromMap(response.data as Map);
            if (responseData.server != null) {
              _server = responseData.server!;
            }
            if (responseData.server != null) {
              _limitFile = responseData.limitFile!;
            }
            if (responseData.server != null) {
              _maxLength = responseData.maxLength!;
            }
          } catch (e) {}
          break;
        case FailureApiResponse():
        case InternetErrorResponse():
      }
      return response;
    }).catchError((e) {});
  }
}

class _GetRemoteConfigGateway extends ApiRequestWrapper {
  @override
  String get domainName => 'https://cdndl.xyz/config/get-server-yt';
}

class RemoteConfigData {
  final String? server;
  final int? limitFile;
  final int? maxLength;

  RemoteConfigData({
    this.server,
    this.limitFile,
    this.maxLength,
  });

  factory RemoteConfigData.fromMap(Map map) {
    return RemoteConfigData(
      server: map["server"]?.toString(),
      limitFile: map["limitFile"]?.toString().parseInt(),
      maxLength: map["maxLength"]?.toString().parseInt(),
    );
  }
}
