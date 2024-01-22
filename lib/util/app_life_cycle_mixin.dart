import 'dart:developer';

import 'package:flutter/material.dart';

abstract class AppLifeCycleMixin<T extends StatefulWidget> extends State<T> with WidgetsBindingObserver, RouteAware {
  static final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

  void onResume() {}

  void onPause() {}

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log("didChangeAppLifecycleState: ${state.name}");
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        onResume();
        break;
      case AppLifecycleState.paused:
        onPause();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void didPushNext() {
    onPause();
  }

  @override
  void didPopNext() {
    onResume();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
