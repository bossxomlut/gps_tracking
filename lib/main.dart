import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gps_speed/base_presentation/theme/theme.dart';
import 'package:gps_speed/data/gps/dangerous_entity.dart';
import 'package:gps_speed/feature/dangerous_mark/cubit/dangerous_cubit.dart';
import 'package:gps_speed/feature/setting/setting.dart';
import 'package:gps_speed/feature/tracking_speed/cubit/location_service_cubit.dart';
import 'package:gps_speed/firebase/firebase_options.dart';
import 'package:gps_speed/util/app_life_cycle_mixin.dart';
import 'package:gps_speed/util/gps/gps.dart';
import 'package:gps_speed/util/navigator/app_navigator.dart';
import 'package:gps_speed/util/navigator/app_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'main_setting/app_setting.dart';

class AppLocale {
  final List<Locale> supportedLocales = [
    // const Locale('ar', 'EG'),
    const Locale('en', 'US'),
    // const Locale('es', 'ES'),
    // const Locale('hi', 'IN'),
    // const Locale('ja', 'JP'),
    // const Locale('pt', 'BR'),
    // const Locale('vi', 'VN'),
    // const Locale('zh', 'CN'),
  ];

  Locale get defaultLocale => const Locale('en', 'US');

  String get path => 'assets/translations';
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(name: 'gps speed', options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  final dir = await getApplicationDocumentsDirectory();

  Hive.initFlutter(dir.path);
  Hive.registerAdapter(DangerousEntityAdapter());

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    AppTheme.initFromRootContext(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<UnitCubit>(
          create: (BuildContext context) => UnitCubit(),
        ),
        BlocProvider<MaxSpeedCubit>(
          create: (BuildContext context) => MaxSpeedCubit()..init(),
        ),
        BlocProvider<LocationServiceCubit>(
          create: (BuildContext context) => LocationServiceCubit(),
        ),
        BlocProvider<DangerousCubit>(
          create: (BuildContext context) => DangerousCubit(getGPSUtilInstance()),
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
            theme: ThemeData.dark().copyWith(
              primaryColor: Colors.greenAccent,
            ),
            home: AppPage.getInitialPage().getPage(null),
            navigatorKey: AppNavigator.navigatorKey,
            debugShowCheckedModeBanner: false,
            navigatorObservers: [
              AppLifeCycleMixin.routeObserver,
            ],
            builder: FToastBuilder(),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
