import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  const CustomChip({Key? key, this.backgroundColor, this.child}) : super(key: key);

  final Color? backgroundColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(44),
      ),
      child: child,
    );
  }
}
