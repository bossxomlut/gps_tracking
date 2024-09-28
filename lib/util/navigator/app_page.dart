import 'package:flutter/material.dart';
import 'package:gps_speed/data/gps/dangerous_entity.dart';
import 'package:gps_speed/feature/dangerous_mark/listing_dangerous_mark_page.dart';
import 'package:gps_speed/feature/google_map/dangerous_map_view.dart';
import 'package:gps_speed/feature/google_map/list_dangerous_map_page.dart';
import 'package:gps_speed/feature/setting/help_and_feedback_page.dart';
import 'package:gps_speed/feature/setting/setting_page.dart';
import 'package:gps_speed/feature/tracking_speed/page/speed_page.dart';

import '../../feature/onboard/page/onboarding_page.dart';

class GetHelpAndFeedbackPage extends AppPage {
  GetHelpAndFeedbackPage() : super('/help-and-feedback');

  @override
  Widget? getPage(Object? arguments) {
    return const HelpAndFeedbackPage();
  }
}

class GetSettingPage extends AppPage {
  GetSettingPage() : super('/setting');

  @override
  Widget? getPage(Object? arguments) {
    return const SettingPage();
  }
}

class GetHomePage extends AppPage {
  GetHomePage() : super('/home');

  @override
  Widget? getPage(Object? arguments) {
    return const SpeedPage();
  }
}

class GetOnboardingPage extends AppPage {
  GetOnboardingPage() : super('/onboarding');

  @override
  Widget? getPage(Object? arguments) {
    return const OnboardingPage();
  }
}

class GetListingDangerousMarkPage extends AppPage {
  GetListingDangerousMarkPage() : super('/listing-dangerous-mark');

  @override
  Widget? getPage(Object? arguments) {
    return DangerousLocationsList();
  }
}

class GetDangerousMapPage extends AppPage {
  GetDangerousMapPage() : super('/dangerous-map-page');

  @override
  Widget? getPage(Object? arguments) {
    if (arguments is! DangerousEntity) {
      return DangerousMapPage(
          entity: DangerousEntity(addressInfo: '', latitude: 0, longitude: 0, time: DateTime.now()));
    }

    return DangerousMapPage(entity: arguments);
  }
}

class GetListDangerousMapPage extends AppPage {
  GetListDangerousMapPage() : super('/dangerous-map-page/list');

  @override
  Widget? getPage(Object? arguments) {
    if (arguments is! List<DangerousEntity>) {
      return const ListDangerousMapPage(dangerousList: []);
    }

    return ListDangerousMapPage(dangerousList: arguments);
  }
}

sealed class AppPage {
  final String path;

  AppPage(this.path);

  Widget? getPage(Object? arguments);

  static AppPage? _initPage;

  static void setInitPage(AppPage initPage) {
    _initPage = initPage;
  }

  static AppPage getInitialPage() {
    return _initPage ?? GetOnboardingPage();
  }
}
