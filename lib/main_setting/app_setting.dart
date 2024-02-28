import 'package:easy_localization/easy_localization.dart';
import 'package:gps_speed/di/di.dart';
import 'package:gps_speed/util/downloader_util.dart';

class AppSetting {
  Future initApp() async {
    return Future.wait([
      //init locale language
      EasyLocalization.ensureInitialized(),

      Future(() => registerDI()),
    ]);
  }
}
