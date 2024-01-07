import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mp3_convert/base_presentation/theme/theme.dart';
import 'package:mp3_convert/feature/home/page/home.dart';

import 'main_setting/app_setting.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppSetting().initApp();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('vi', 'VN')],
      path: 'assets/translations',
      startLocale: Locale('vi', 'VN'),
      fallbackLocale: Locale('en', 'US'),
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
          home: const HomePage(),
        );
      },
    );
  }
}
