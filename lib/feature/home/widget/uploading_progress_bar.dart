import 'package:flutter/material.dart';
import 'package:mp3_convert/resource/icon_path.dart';
import 'package:mp3_convert/widget/image.dart';

class UploadingProgressBar extends StatelessWidget {
  const UploadingProgressBar({super.key, this.progress});
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppImage.svg(IconPath.arrowCircleTop),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Uploading",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 16,
                    ),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                borderRadius: BorderRadius.circular(4),
                backgroundColor: Color(0xFFf1f1f1),
                color: Color(0xFF05c756),
                value: progress,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ConvertingProgressBar extends StatelessWidget {
  const ConvertingProgressBar({super.key, this.progress});
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppImage.svg(IconPath.exchange),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Converting",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 16,
                    ),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                borderRadius: BorderRadius.circular(4),
                backgroundColor: Color(0xFFf1f1f1),
                color: Color(0xFF05c756),
                value: progress,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DownloadingProgressBar extends StatelessWidget {
  const DownloadingProgressBar({super.key, this.progress});
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppImage.svg(IconPath.download),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Downloading",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 16,
                    ),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                borderRadius: BorderRadius.circular(4),
                backgroundColor: Color(0xFFf1f1f1),
                color: Color(0xFF05c756),
                value: progress,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
