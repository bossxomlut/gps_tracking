import 'dart:async';

import 'package:flutter/material.dart';

const double _goSize = 120;
const double _goZoomSize = 110;

class GoButton extends StatefulWidget {
  const GoButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<GoButton> createState() => _GoButtonState();
}

class _GoButtonState extends State<GoButton> with SingleTickerProviderStateMixin {
  late final AnimationController goController;
  final Tween goSizeTween = Tween<double>(begin: _goSize, end: _goZoomSize);

  late Animation<Object?> goAnimation;

  final GlobalKey<_WavesState> wavesKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    goController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    goAnimation = goSizeTween.animate(goController);

    goController.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.dismissed:
          wavesKey.currentState?.forward();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
        case AnimationStatus.completed:
          goController.reverse();
          break;
      }
    });

    Timer.periodic(Duration(seconds: 3), (timer) {
      goController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _Waves(key: wavesKey),
          AnimatedBuilder(
            animation: goController,
            builder: (context, child) {
              final obj = goAnimation.value;
              final value = obj as double;
              return Container(
                width: value,
                height: value,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.primaryColor, width: 2),
                ),
                child: Text(
                  "GO",
                  style: theme.textTheme.headlineLarge?.copyWith(fontSize: 40, color: theme.primaryColor),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Waves extends StatefulWidget {
  const _Waves({super.key});

  @override
  State<_Waves> createState() => _WavesState();
}

class _WavesState extends State<_Waves> with SingleTickerProviderStateMixin {
  bool isZoomOut = false;
  int animationTime = 250;

  late final AnimationController controller;
  final Tween doubleTween = Tween<double>(begin: 1, end: 1.3);
  final Tween opacityTween = Tween<double>(begin: 1, end: 0);
  late Animation<Object?> animation;
  late Animation<Object?> animation2;
  late Animation<Object?> opacityAnimation;

  void forward() {
    controller.forward();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);

    animation = doubleTween.animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));
    animation2 = doubleTween.animate(CurvedAnimation(parent: controller, curve: Curves.easeInOutCirc));
    opacityAnimation = opacityTween.animate(controller);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
        controller.stop();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final obj = animation.value;
            final value = obj as double;
            if (opacityAnimation.value == 1) {
              return const SizedBox();
            }
            return Opacity(
              opacity: opacityAnimation.value as double > 0.5
                  ? opacityAnimation.value as double
                  : (opacityAnimation.value as double) / 2,
              child: Container(
                height: _goSize * value,
                width: _goSize * value,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.greenAccent, width: 1),
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final obj = animation2.value;
            final value = obj as double;
            if (opacityAnimation.value == 1) {
              return const SizedBox();
            }
            return Opacity(
              opacity: opacityAnimation.value as double,
              child: Container(
                height: _goSize * value,
                width: _goSize * value,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.greenAccent, width: 1),
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class GoButtonScaffold extends StatelessWidget {
  const GoButtonScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: GoButton(
          onTap: () {
            print("LOL");
          },
        ),
      ),
    );
  }
}

class UnicornOutlineButton extends StatelessWidget {
  final _GradientPainter _painter;
  final Widget _child;
  final VoidCallback _callback;
  final double _radius;

  UnicornOutlineButton({
    required double strokeWidth,
    required double radius,
    required Gradient gradient,
    required Widget child,
    required VoidCallback onPressed,
  })  : this._painter = _GradientPainter(strokeWidth: strokeWidth, radius: radius, gradient: gradient),
        this._child = child,
        this._callback = onPressed,
        this._radius = radius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _painter,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _callback,
        child: InkWell(
          borderRadius: BorderRadius.circular(_radius),
          onTap: _callback,
          child: Container(
            constraints: BoxConstraints(minWidth: 88, minHeight: 48),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientPainter extends CustomPainter {
  final Paint _paint = Paint();
  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  _GradientPainter({required double strokeWidth, required double radius, required Gradient gradient})
      : this.strokeWidth = strokeWidth,
        this.radius = radius,
        this.gradient = gradient;

  @override
  void paint(Canvas canvas, Size size) {
    // create outer rectangle equals size
    Rect outerRect = Offset.zero & size;
    var outerRRect = RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

    // create inner rectangle smaller by strokeWidth
    Rect innerRect =
        Rect.fromLTWH(strokeWidth, strokeWidth, size.width - strokeWidth * 2, size.height - strokeWidth * 2);
    var innerRRect = RRect.fromRectAndRadius(innerRect, Radius.circular(radius - strokeWidth));

    // apply gradient shader
    _paint.shader = gradient.createShader(outerRect);

    // create difference between outer and inner paths and draw it
    Path path1 = Path()..addRRect(outerRRect);
    Path path2 = Path()..addRRect(innerRRect);
    var path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
