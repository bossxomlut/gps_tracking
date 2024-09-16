import 'package:flutter/material.dart';
import 'package:gps_speed/util/navigator/app_navigator.dart';
import 'package:gps_speed/util/navigator/app_page.dart';

class SettingIconWidget extends StatelessWidget {
  const SettingIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.primaryColor;

    return GestureDetector(
      onTap: () {
        AppNavigator.to(GetSettingPage());
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: theme.highlightColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.settings,
          color: color,
          size: 14,
        ),
      ),
    );
  }
}
