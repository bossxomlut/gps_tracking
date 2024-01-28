import 'package:flutter/material.dart';
import 'package:mp3_convert/base_presentation/view/view.dart';
import 'package:mp3_convert/resource/icon_path.dart';
import 'package:mp3_convert/resource/string.dart';
import 'package:mp3_convert/util/hardcode_string.dart';
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
              LText(
                ConvertPageLocalization.uploading,
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
              LText(
                ConvertPageLocalization.converting,
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

class ConvertedProgressBar extends StatelessWidget {
  const ConvertedProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.done, size: 32),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LText(
                'converted'.hardCode,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 16,
                    ),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                borderRadius: BorderRadius.circular(4),
                backgroundColor: Color(0xFFf1f1f1),
                color: Color(0xFF05c756),
                value: 1.0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DownloadingProgressBar extends StatelessWidget {
  const DownloadingProgressBar({
    super.key,
    this.progress,
    this.isError = false,
  });
  final double? progress;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;
    return Row(
      children: [
        AppImage.svg(
          IconPath.download,
          color: isError ? errorColor : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LText(
                isError ? ConvertPageLocalization.downloadError : ConvertPageLocalization.downloading,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 16,
                      color: isError ? errorColor : null,
                    ),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                borderRadius: BorderRadius.circular(4),
                backgroundColor: Color(0xFFf1f1f1),
                color: isError ? errorColor : Color(0xFF05c756),
                value: progress,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
