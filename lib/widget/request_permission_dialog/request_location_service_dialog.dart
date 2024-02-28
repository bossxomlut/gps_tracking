import 'package:flutter/material.dart';
import 'package:gps_speed/util/gps/gps.dart';

class RequestLocationServiceDialog extends StatefulWidget with ShowDialog {
  const RequestLocationServiceDialog({super.key, required this.onEnableLocationService});

  final ValueChanged<bool> onEnableLocationService;

  @override
  State<RequestLocationServiceDialog> createState() => _RequestLocationServiceDialogState();
}

class _RequestLocationServiceDialogState extends State<RequestLocationServiceDialog> {
  bool isOpenSettings = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Request Location Service'),
      content: const Text(
        'Please turn on your location service to use this function',
      ),
      actions: <Widget>[
        if (isOpenSettings)
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('OKE'),
            onPressed: () {
              GPSUtil.instance.checkEnableLocationService().then((value) {
                widget.onEnableLocationService(value);
                Navigator.of(context).pop();
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
              GPSUtil.instance.openSettingLocationService().then((value) {});

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
