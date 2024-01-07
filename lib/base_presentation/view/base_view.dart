import 'package:flutter/material.dart';

abstract class BaseStatefulWidgetState<T extends StatefulWidget> extends State<T> {
  ThemeData get theme => Theme.of(context);

  TextTheme get textTheme => theme.textTheme;
}
