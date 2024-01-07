import 'package:flutter/material.dart';
import 'package:mp3_convert/base_presentation/theme/theme.dart';
import 'package:mp3_convert/feature/home/home.dart';

void main() {
  runApp(const MyApp());
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
            title: 'Flutter Demo',
            themeMode: AppTheme.instance.mode,
            theme: ThemeData(
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
            ),
            home: const HomePage(),
          );
        });
  }
}
