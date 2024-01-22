import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mp3_convert/base_presentation/theme/theme.dart';
import 'package:mp3_convert/feature/home/cubit/convert_cubit.dart';
import 'package:mp3_convert/feature/home/page/convert_page.dart';
import 'package:mp3_convert/feature/home/page/home.dart';
import 'package:mp3_convert/internet_connect/socket/socket.dart';
import 'package:mp3_convert/util/app_life_cycle_mixin.dart';
import 'package:mp3_convert/util/navigator/app_navigator.dart';
import 'package:mp3_convert/util/downloader_util.dart';
import 'package:mp3_convert/util/navigator/app_page.dart';

import 'main_setting/app_setting.dart';

final ConvertChannel socketChannel = ConvertChannel("https://syt.cdndl.xyz");

class AppLocale {
  final List<Locale> supportedLocales = [
    const Locale('en', 'US'),
    const Locale('vi', 'VN'),
  ];

  Locale get defaultLocale => supportedLocales.first;

  String get path => 'assets/translations';
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppSetting().initApp();

  final AppLocale appLocale = AppLocale();

  runApp(
    EasyLocalization(
      supportedLocales: appLocale.supportedLocales,
      startLocale: appLocale.defaultLocale,
      fallbackLocale: appLocale.defaultLocale,
      path: appLocale.path,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppTheme.initFromRootContext(context);
    return ListenableBuilder(
      listenable: AppTheme.instance,
      builder: (context, _) {
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          themeMode: AppTheme.instance.mode,
          theme: ThemeData(
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
          ),
          home: GetHomePage().getPage(null),
          navigatorKey: AppNavigator.navigatorKey,
          navigatorObservers: [
            AppLifeCycleMixin.routeObserver,
          ],
        );
      },
    );
  }
}
