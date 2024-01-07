import 'package:easy_localization/easy_localization.dart';

class AppSetting {
  Future initApp() async {
    return Future.wait([
      EasyLocalization.ensureInitialized(),
    ]);
  }
}
