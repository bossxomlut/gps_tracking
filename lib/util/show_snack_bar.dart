import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class ShowSnackBar {
  static void show(
    BuildContext context, {
    String? title,
    required String message,
  }) {
    Flushbar(
      title: title,
      message: message,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
    ).show(context);
  }

  static void showError(
    BuildContext context, {
    String? title,
    required String message,
  }) {
    Flushbar(
      title: title,
      message: message,
      duration: const Duration(seconds: 3),
      backgroundColor: Theme.of(context).colorScheme.error,
      messageColor: Theme.of(context).colorScheme.background,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
    ).show(context);
  }
}
