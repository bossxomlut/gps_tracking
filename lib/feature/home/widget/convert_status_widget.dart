import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_convert/feature/home/cubit/convert_cubit.dart';
import 'package:mp3_convert/feature/home/data/entity/setting_file.dart';
import 'package:mp3_convert/feature/home/widget/uploading_progress_bar.dart';
import 'package:mp3_convert/resource/icon_path.dart';
import 'package:mp3_convert/widget/image.dart';
import 'package:open_file_plus/open_file_plus.dart';

class ConvertStatusWidget extends StatelessWidget {
  const ConvertStatusWidget({
    super.key,
    required this.convertFile,
  });

  final ConvertStatusFile convertFile;

  @override
  Widget build(BuildContext context) {
    final ConvertStatus status = convertFile.status;

    switch (status) {
      case ConvertStatus.uploading:
        return const UploadingProgressBar();
      case ConvertStatus.uploaded:
        return const UploadingProgressBar(progress: 1);
      case ConvertStatus.converting:
        final double? progress = (convertFile as ConvertingFile).convertProgress;

        return ConvertingProgressBar(progress: progress);
      case ConvertStatus.converted:
        return ElevatedButton(
          onPressed: () {
            context.read<ConvertCubit>().downloadConvertedFile((convertFile as ConvertedFile).downloadId);
          },
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppImage.svg(
                  IconPath.download,
                  color: Colors.white,
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "Download",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
        );
      case ConvertStatus.downloading:
        final double? downloadProgress = (convertFile as DownloadingFile).downloadProgress;
        return DownloadingProgressBar(progress: downloadProgress);
      case ConvertStatus.downloaded:
        return ElevatedButton(
          onPressed: () {
            if (convertFile is DownloadedFile) {
              OpenFile.open((convertFile as DownloadedFile).downloadPath);
            }
          },
          child: Center(
            child: Text(
              "Open File",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
        );
    }
  }
}

class ConvertErrorWidget extends StatelessWidget {
  const ConvertErrorWidget({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppImage.svg(IconPath.refreshAlert, color: Theme.of(context).colorScheme.error),
        const SizedBox(width: 12),
        Text(
          "Have error in this session!",
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(fontSize: 16, color: Theme.of(context).colorScheme.error),
        ),
        const SizedBox(width: 12),
        TextButton(onPressed: onRetry, child: Text("Retry")),
      ],
    );
  }
}
