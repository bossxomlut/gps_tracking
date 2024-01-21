import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mp3_convert/widget/lost_connect_internet_widget.dart';

class ShowLostConnectInternetHelper {
  ShowLostConnectInternetHelper(this.context);

  final BuildContext context;

  late final StreamSubscription _internetStreamSubscription;

  OverlayEntry? entry;
  void startListen() {
    _internetStreamSubscription = InternetConnectionChecker().onStatusChange.listen((event) {
      switch (event) {
        case InternetConnectionStatus.disconnected:
          entry = OverlayEntry(
            builder: (context) => LostConnectInternetWidget(),
          );
          Overlay.of(context).insert(entry!);
          break;
        case InternetConnectionStatus.connected:
          entry?.remove();
          entry = null;
        // TODO: Handle this case.
      }
    });
  }

  void dispose() {
    _internetStreamSubscription.cancel();
  }
}
