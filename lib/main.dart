import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_speed/base_presentation/theme/theme.dart';
import 'package:gps_speed/feature/setting/cubit/unit_cubit.dart';
import 'package:gps_speed/firebase/firebase_options.dart';
import 'package:gps_speed/util/app_life_cycle_mixin.dart';
import 'package:gps_speed/util/navigator/app_navigator.dart';
import 'package:gps_speed/util/navigator/app_page.dart';

import 'main_setting/app_setting.dart';

class AppLocale {
  final List<Locale> supportedLocales = [
    const Locale('ar', 'EG'),
    const Locale('en', 'US'),
    const Locale('es', 'ES'),
    const Locale('hi', 'IN'),
    const Locale('ja', 'JP'),
    const Locale('pt', 'BR'),
    const Locale('vi', 'VN'),
    const Locale('zh', 'CN'),
  ];

  Locale get defaultLocale => const Locale('en', 'US');

  String get path => 'assets/translations';
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<UnitCubit>(
          create: (BuildContext context) => UnitCubit(),
        ),
      ],
      child: ListenableBuilder(
        listenable: AppTheme.instance,
        builder: (context, _) {
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            themeMode: AppTheme.instance.mode,
            theme: ThemeData.dark(),
            debugShowCheckedModeBanner: false,
            // theme: ThemeData(
            //   useMaterial3: true,
            // ),
            // darkTheme: ThemeData(
            //   useMaterial3: true,
            // ),
            home: GetHomePage().getPage(null),
            navigatorKey: AppNavigator.navigatorKey,
            navigatorObservers: [
              AppLifeCycleMixin.routeObserver,
            ],
          );
        },
      ),
    );
  }
}
