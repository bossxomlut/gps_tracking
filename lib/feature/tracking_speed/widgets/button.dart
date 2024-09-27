import 'package:flutter/material.dart';

class PauseButton extends StatelessWidget {
  const PauseButton({Key? key, this.onTap}) : super(key: key);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CycleButton(
      onTap: onTap,
      backgroundColor: Theme.of(context).highlightColor,
      child: Container(
        width: 76,
        height: 76,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Text(
          'Pause',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
        ),
        // child: AppImage.svg(IconPath.pause),
      ),
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton({Key? key, this.onTap}) : super(key: key);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CycleButton(
      onTap: onTap,
      backgroundColor: Theme.of(context).highlightColor,
      child: Container(
        width: 76,
        height: 76,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Text(
          'Start',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}

class StopButton extends StatelessWidget {
  const StopButton({Key? key, this.onTap}) : super(key: key);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CycleButton(
      onTap: onTap,
      backgroundColor: Theme.of(context).highlightColor,
      child: Container(
        width: 76,
        height: 76,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        child: Text(
          'Stop',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
        ),
        // child: AppImage.svg(IconPath.finish),
      ),
    );
  }
}

class CycleButton extends StatelessWidget {
  const CycleButton({
    Key? key,
    this.backgroundColor,
    this.onTap,
    this.child,
    this.isDisable = false,
  }) : super(key: key);

  final Color? backgroundColor;
  final VoidCallback? onTap;
  final Widget? child;
  final bool isDisable;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDisable ? Colors.grey.shade200 : backgroundColor,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: isDisable ? null : onTap,
        borderRadius: BorderRadius.circular(100),
        child: child,
      ),
    );
  }
}
