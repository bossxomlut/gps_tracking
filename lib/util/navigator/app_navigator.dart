import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gps_speed/util/navigator/app_page.dart';

abstract class AppNavigator {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static bool canPop() {
    if (navigatorKey.currentContext != null) {
      return Navigator.canPop(navigatorKey.currentContext!);
    }
    return false;
  }

  static Future to(AppPage appPage, [dynamic arguments]) {
    if (navigatorKey.currentContext != null) {
      log('open page: ${appPage.path} with arguments: $arguments');
      return Navigator.of(navigatorKey.currentContext!).push(
        MaterialPageRoute(
          builder: (context) => appPage.getPage(arguments)!,
          settings: RouteSettings(
            name: appPage.path,
            arguments: arguments,
          ),
        ),
      );
    }
    return Future.value();
  }

  static void back<T>([T? result]) {
    if (navigatorKey.currentContext != null) {
      Navigator.of(navigatorKey.currentContext!).pop<T>(result);
    }
  }

  static Future goOff(String name) {
    if (navigatorKey.currentContext != null) {
      return Navigator.of(navigatorKey.currentContext!).pushNamedAndRemoveUntil(name, (route) => false);
    }
    return Future.value();
  }

  static Future goRemoveUntil(String target, String removeName, {Object? arguments}) {
    if (navigatorKey.currentContext != null) {
      return Navigator.of(navigatorKey.currentContext!)
          .pushNamedAndRemoveUntil(target, (route) => route.settings.name == removeName, arguments: arguments);
    }
    return Future.value();
  }

  static void backTo(String name) {
    if (navigatorKey.currentContext != null) {
      Navigator.of(navigatorKey.currentContext!).popUntil((route) => route.settings.name == name);
    }
  }
}
