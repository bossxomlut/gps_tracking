import 'package:flutter/material.dart';

abstract class BaseStatelessView extends StatelessWidget {
  BaseStatelessView({super.key});

  late final BuildContext? _context;

  ThemeData get theme => Theme.of(_context!);

  TextTheme get textTheme => theme.textTheme;

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    _context ??= context;
    return const Placeholder();
  }
}

abstract class BaseStatefulWidgetState<T extends StatefulWidget> extends State<T> {
  ThemeData get theme => Theme.of(context);

  TextTheme get textTheme => theme.textTheme;
}
