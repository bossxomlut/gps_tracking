import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_speed/feature/tracking_speed/cubit/warning_speed_bloc.dart';

class MaxSpeedLayoutWidget extends StatelessWidget {
  const MaxSpeedLayoutWidget({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        IgnorePointer(
          child: BlocSelector<WarningSpeedBloc, WarningSpeedState, bool>(
            selector: (state) => state.showWarning,
            builder: (_, showWarning) {
              if (!showWarning) {
                return const SizedBox();
              }

              return const WarningWidget();
            },
          ),
        )
      ],
    );
  }
}

class WarningWidget extends StatefulWidget {
  const WarningWidget({super.key});

  @override
  State<WarningWidget> createState() => _WarningWidgetState();
}

class _WarningWidgetState extends State<WarningWidget> {
  static final List<Color> warningColorTransparent = [Colors.transparent];
  static final List<Color> warningColorList = [
    const Color(0xFFF5222D).withOpacity(0.02),
    const Color(0xFFF5222D).withOpacity(0.2),
  ];

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  late final Timer _timer;

  List<Color> warningColor = warningColorTransparent;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 1200), (timer) {
      if (warningColor == warningColorTransparent) {
        warningColor = warningColorList;
      } else {
        warningColor = warningColorTransparent;
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Colors.transparent,
            ...warningColor,
          ],
          radius: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      duration: const Duration(milliseconds: 600),
    );
  }
}
