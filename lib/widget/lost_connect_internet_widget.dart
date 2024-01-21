import 'package:flutter/material.dart';
import 'package:mp3_convert/resource/icon_path.dart';
import 'package:mp3_convert/widget/image.dart';

class LostConnectInternetWidget extends StatelessWidget {
  const LostConnectInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          child: Row(
            children: [
              AppImage.svg(IconPath.noWifi, width: 16, height: 16),
              const SizedBox(width: 10),
              Text(
                "Lost connect internet",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 12,
                    ),
              ),
            ],
          ),
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(offset: const Offset(0, -2), blurRadius: 4.0, color: Colors.black.withOpacity(0.04)),
              BoxShadow(offset: const Offset(0, 4), blurRadius: 8.0, color: Colors.black.withOpacity(0.12)),
            ],
            color: Colors.white,
          ),
          width: double.maxFinite,
        ),
      ),
    );
  }
}
