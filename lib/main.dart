import 'dart:async';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mp3_convert/base_presentation/theme/theme.dart';
import 'package:mp3_convert/feature/home/page/home.dart';
import 'package:mp3_convert/internet_connect/socket/socket.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'main_setting/app_setting.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final ConvertChannel socketChannel = ConvertChannel("https://syt.cdndl.xyz");

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppSetting().initApp();
  await FlutterDownloader.initialize(
      debug: true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl: true // option: set to false to disable working with http links (default: false)
      );

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('vi', 'VN')],
      path: 'assets/translations',
      startLocale: Locale('en', 'US'),
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

class WebSocketWidget extends StatefulWidget {
  const WebSocketWidget({super.key});

  @override
  State<WebSocketWidget> createState() => _WebSocketWidgetState();
}

class _WebSocketWidgetState extends State<WebSocketWidget> {
  SocketChannel socketChannel = SocketChannel("https://syt.cdndl.xyz")..startConnection();
  StreamSubscription? streamSubscription;

  @override
  void initState() {
    super.initState();
    streamSubscription = socketChannel.stream.listen((event) {
      print(event.toString());
    });
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    streamSubscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              socketChannel.close();
              streamSubscription?.cancel();
              streamSubscription = null;
            },
          ),
          FloatingActionButton(
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
