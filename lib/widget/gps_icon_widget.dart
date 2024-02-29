import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_speed/feature/tracking_speed/cubit/location_service_cubit.dart';

class LocationServiceInfoWidget extends StatelessWidget {
  const LocationServiceInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationServiceCubit, LocationServiceState>(
      builder: (context, state) {
        return Row(
          children: [
            GPSIconWidget(
              isEnabled: state.isEnableService,
            ),
            const SizedBox(width: 8),
            GPSPermissionWidget(
              isEnabled: state.isGranted,
            ),
          ],
        );
      },
    );
  }
}

class GPSIconWidget extends StatelessWidget {
  const GPSIconWidget({super.key, required this.isEnabled});

  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isEnabled ? theme.primaryColor : theme.disabledColor;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.highlightColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isEnabled ? Icons.location_on_outlined : Icons.location_off_outlined,
            color: color,
            size: 14,
          ),
          const SizedBox(width: 2),
          Text(
            'GPS',
            style: theme.textTheme.labelSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class GPSPermissionWidget extends StatelessWidget {
  const GPSPermissionWidget({super.key, required this.isEnabled});

  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isEnabled ? theme.primaryColor : theme.disabledColor;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.highlightColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isEnabled ? Icons.key_outlined : Icons.key_off_outlined,
            color: color,
            size: 14,
          ),
          const SizedBox(width: 2),
          Text(
            'Permission',
            style: theme.textTheme.labelSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
