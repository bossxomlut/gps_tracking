import 'package:flutter/material.dart';
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
