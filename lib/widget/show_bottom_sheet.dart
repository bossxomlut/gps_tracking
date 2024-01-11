import 'package:flutter/material.dart';

mixin ShowBottomSheet<T> on Widget {
  Future<T?> showBottomSheet(BuildContext context) {
    return showModalBottomSheet<T>(
      context: context,
      builder: (context) => SafeArea(child: this),
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(),
    );
  }
}
