import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  const LoadingButton({super.key, required this.child, required this.onTap});
  final Widget child;
  final Future Function() onTap;

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          if (!isLoading) {
            isLoading = true;
            setState(() {});
            try {
              await widget.onTap();
            } catch (e) {}
            isLoading = false;
            setState(() {});
          }
        },
        child: isLoading
            ? const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : widget.child);
  }
}
