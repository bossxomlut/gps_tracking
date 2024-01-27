import 'package:flutter/material.dart';
import 'package:mp3_convert/feature/convert/page/convert_page.dart';
import 'package:mp3_convert/feature/convert/page/convert_setting_page.dart';
import 'package:mp3_convert/feature/cutter/page/audio_cutter_page.dart';
import 'package:mp3_convert/feature/home/page/home.dart';
import 'package:mp3_convert/feature/merger/page/merger_page.dart';
import 'package:mp3_convert/feature/setting/help_and_feedback_page.dart';
import 'package:mp3_convert/feature/setting/setting_page.dart';

class GetMergerPage extends AppPage {
  GetMergerPage() : super('/merger');

  @override
  Widget? getPage(Object? arguments) {
    return const MergerPage();
  }
}

class GetAudioCutterPage extends AppPage {
  GetAudioCutterPage() : super('/cutter');

  @override
  Widget? getPage(Object? arguments) {
    return const AudioCutterPage();
  }
}

class GetConvertSettingPage extends AppPage {
  GetConvertSettingPage() : super('/convert/setting');

  @override
  Widget? getPage(Object? arguments) {
    return const ConvertSettingPage();
  }
}

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
    return const HomePage();
  }
}

class GetConvertPage extends AppPage {
  GetConvertPage() : super('/convert');

  @override
  Widget? getPage(Object? arguments) {
    return const ConvertPage();
  }
}

sealed class AppPage {
  final String path;

  AppPage(this.path);

  Widget? getPage(Object? arguments);
}
