import 'package:mp3_convert/internet_connect/http_request/api.dart';
import 'package:mp3_convert/internet_connect/http_request/api_response.dart';
import 'package:mp3_convert/util/parse_util.dart';

class RemoteConfig {
  RemoteConfig._();

  static final RemoteConfig _instance = RemoteConfig._();

  factory RemoteConfig() => _instance;

  static const String _defaultGateway = "https://cdndl.xyz/media/sv1";
  static const int _defaultMaxSubmitFile = 5;
  static const int _defaultMaxSizePerFile = 200000000;

  String _server = _defaultGateway;
  int _limitFile = _defaultMaxSubmitFile;
  int _maxLength = _defaultMaxSizePerFile;

  String get server => _server;
  int get limitFile => _limitFile;
  int get maxLength => _maxLength;

  Future getRemoteConfig() async {
    try {
      final response = await _GetRemoteConfigGateway().get('');
      _updateConfigurations(response);
      return response;
    } catch (e) {
      // Handle errors appropriately (e.g., logging, notification).
      return null;
    }
  }

  void _updateConfigurations(dynamic response) {
    switch (response) {
      case SuccessApiResponse():
        try {
          final RemoteConfigData responseData = RemoteConfigData.fromMap(response.data as Map);
          _updateServer(responseData.server);
          _updateLimitFile(responseData.limitFile);
          _updateMaxLength(responseData.maxLength);
        } catch (e) {
          // Handle parsing errors appropriately (e.g., logging).
        }
        break;
      case FailureApiResponse():
      case InternetErrorResponse():
        // Handle failure or internet error cases.
        break;
      default:
        // Handle unexpected response cases.
        break;
    }
  }

  void _updateServer(String? newServer) {
    if (newServer != null) {
      _server = newServer;
    }
  }

  void _updateLimitFile(int? newLimitFile) {
    if (newLimitFile != null) {
      _limitFile = newLimitFile;
    }
  }

  void _updateMaxLength(int? newMaxLength) {
    if (newMaxLength != null) {
      _maxLength = newMaxLength;
    }
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
