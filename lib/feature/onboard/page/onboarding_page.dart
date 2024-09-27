import 'package:flutter/material.dart';
import 'package:gps_speed/base_presentation/page/base_page.dart';
import 'package:gps_speed/resource/image_path.dart';
import 'package:gps_speed/storage/key_value_storage.dart';
import 'package:gps_speed/storage/storage_key.dart';
import 'package:gps_speed/util/gps/gps_util.dart';
import 'package:gps_speed/util/navigator/app_navigator.dart';
import 'package:gps_speed/util/navigator/app_page.dart';
import 'package:gps_speed/util/show_snack_bar.dart';
import 'package:gps_speed/widget/image.dart';
import 'package:gps_speed/widget/request_permission_dialog/show_open_setting_dialog.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends BasePageState<OnboardingPage> with WidgetsBindingObserver {
  final KeyValueStorage _storage = KeyValueStorage.i();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        GPSUtil.instance.checkLocationPermission().then((isGranted) {
          if (isGranted) {
            _storage.set(StorageKey.firstInit, false);
            AppNavigator.goOff(GetHomePage());
          }
        }).onError((error, stackTrace) {});
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 140),
          AspectRatio(
            aspectRatio: 1,
            child: AppImage.asset(
              ImagePath.onboardingRequiredLocation,
            ),
          ),
          Text(
            'This app requires location permission to track your movements and calculate speed.',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () {
              GPSUtil.instance.requestLocationPermission().then((isGranted) {
                if (isGranted) {
                  _storage.set(StorageKey.firstInit, false);
                  AppNavigator.goOff(GetHomePage());
                }
              }).onError((error, stackTrace) {
                if (error is DeniedForeverLocationPermissionException) {
                  OpenSettingDialog(
                    onConfirm: () {
                      GPSUtil.instance.openSettingLocationPermission();
                    },
                  ).show(context);
                } else {
                  //show message not granted location permission
                  ShowSnackBar.show(context, message: "This permission is required");
                }
              });
            },
            child: const Text('Allow location permission'),
          ),
        ],
      ),
    );
  }
}
