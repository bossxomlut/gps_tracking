import 'package:flutter/material.dart';
import 'package:gps_speed/util/gps/gps.dart';

class RequestLocationPermissionDialog extends StatefulWidget with ShowDialog {
  const RequestLocationPermissionDialog({super.key, required this.onEnableLocationPermission});

  final ValueChanged<bool> onEnableLocationPermission;

  @override
  State<RequestLocationPermissionDialog> createState() => _RequestLocationPermissionDialogState();
}

class _RequestLocationPermissionDialogState extends State<RequestLocationPermissionDialog> {
  bool isOpenSettings = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Request Location Permission'),
      content: const Text(
        'Please turn on your location permission to use this function',
      ),
      actions: <Widget>[
        if (isOpenSettings)
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('OKE'),
            onPressed: () {
              GPSUtil.instance.requestLocationPermission().then((value) {
                Navigator.of(context).pop();
                widget.onEnableLocationPermission(value);
              });
            },
          )
        else ...[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Open settings'),
            onPressed: () {
              GPSUtil.instance.openSettingLocationPermission().then((value) {});

              isOpenSettings = true;
              setState(() {});
            },
          ),
        ]
      ],
    );
  }
}

mixin ShowDialog on Widget {
  Future show(BuildContext context) {
    return showDialog(context: context, builder: (context) => this);
  }
}
