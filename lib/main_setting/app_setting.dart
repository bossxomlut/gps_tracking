import 'package:easy_localization/easy_localization.dart';
import 'package:gps_speed/di/di.dart';
import 'package:gps_speed/storage/key_value_storage.dart';
import 'package:gps_speed/storage/storage_key.dart';
import 'package:gps_speed/util/navigator/app_page.dart';
import 'package:gps_speed/util/parse_util.dart';

class AppSetting {
  Future initApp() async {
    return Future.wait([
      //init locale language
      EasyLocalization.ensureInitialized(),
      Future.sync(() {
        KeyValueStorage.i().get<bool>(StorageKey.firstInit, tryParse: (value) {
          return value.parseBool();
        }).then((isFirstInit) {
          if (isFirstInit == false) {
            AppPage.setInitPage(GetHomePage());
          } else {
            AppPage.setInitPage(GetOnboardingPage());
          }
        });
      }),
      Future.sync(registerDI),
    ]);
  }
}
