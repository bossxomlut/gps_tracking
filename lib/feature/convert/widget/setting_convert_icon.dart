import 'package:flutter/material.dart';
import 'package:mp3_convert/util/navigator/app_navigator.dart';
import 'package:mp3_convert/util/navigator/app_page.dart';

class SettingConvertIcon extends StatelessWidget {
  const SettingConvertIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        AppNavigator.to(GetConvertSettingPage());
      },
      icon: const Icon(Icons.settings),
    );
  }
}
