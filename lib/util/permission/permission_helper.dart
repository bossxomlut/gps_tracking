import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> requestStoragePermission() async {
    if (Platform.isIOS) {
      return true;
    }

    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      if (info.version.sdkInt > 28) {
        var permission = await Permission.mediaLibrary.status;

        if (permission != PermissionStatus.granted) {
          await Permission.mediaLibrary.request();
          permission = await Permission.mediaLibrary.status;
        }
        return permission == PermissionStatus.granted;
      }

      final status = await Permission.storage.status;
      if (status == PermissionStatus.granted) {
        return true;
      }

      final result = await Permission.storage.request();
      return result == PermissionStatus.granted;
    }

    throw StateError('unknown platform');
  }

  static Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status != PermissionStatus.granted) {
      await Permission.notification.request();
    }
    return (await Permission.notification.status) == PermissionStatus.granted;
  }

  static Future<bool> requestAudioPermission() async {
    final status = await Permission.audio.status;
    if (status != PermissionStatus.granted) {
      await Permission.audio.request();
    }
    return (await Permission.audio.status) == PermissionStatus.granted;
  }

  static Future<bool> requestVideoPermission() async {
    final status = await Permission.videos.status;
    if (status != PermissionStatus.granted) {
      await Permission.videos.request();
    }
    return (await Permission.videos.status) == PermissionStatus.granted;
  }
}
