import 'package:flutter/material.dart';
import 'package:gps_speed/feature/home/page/home.dart';
import 'package:gps_speed/feature/setting/help_and_feedback_page.dart';
import 'package:gps_speed/feature/setting/setting_page.dart';
import 'package:gps_speed/feature/tracking_speed/page/speed_page.dart';
import 'package:gps_speed/widget/button/go_button.dart';

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

sealed class AppPage {
  final String path;

  AppPage(this.path);

  Widget? getPage(Object? arguments);
}
