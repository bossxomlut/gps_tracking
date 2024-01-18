import 'dart:async';

import 'package:flutter/material.dart';

mixin EventMixin<E> {
  final _eventController = StreamController<E>.broadcast();

  Stream<E> get $eventStream => _eventController.stream;

  void addEvent(E event) {
    _eventController.sink.add(event);
  }

  @mustCallSuper
  void dispose() {
    _eventController.close();
  }
}

mixin EventStateMixin<T extends StatefulWidget, E> on State<T> {
  late StreamSubscription<E> _streamSubscription;

  Stream<E> get eventStream;

  @override
  void initState() {
    super.initState();
    _streamSubscription = eventStream.listen((event) => eventListener(event));
  }

  void eventListener(E event);

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
