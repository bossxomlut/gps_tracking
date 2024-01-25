import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_convert/base_presentation/view/view.dart';
import 'package:mp3_convert/feature/convert/cubit/convert_cubit.dart';
import 'package:mp3_convert/feature/convert/data/entity/setting_file.dart';
import 'package:mp3_convert/feature/convert/widget/uploading_progress_bar.dart';
import 'package:mp3_convert/resource/icon_path.dart';
import 'package:mp3_convert/resource/string.dart';
import 'package:mp3_convert/widget/image.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:share_plus/share_plus.dart';

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
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
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
                LText(
                  ConvertPageLocalization.download,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
        );
      case ConvertStatus.downloading:
        final double? downloadProgress = (convertFile as DownloadingFile).downloadProgress;
        return DownloadingProgressBar(progress: downloadProgress);
      case ConvertStatus.downloaded:
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (convertFile is DownloadedFile) {
                    OpenFile.open((convertFile as DownloadedFile).downloadPath);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
                child: Center(
                  child: LText(
                    ConvertPageLocalization.openFile,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Share.shareXFiles([XFile((convertFile as DownloadedFile).downloadPath)]);
              },
              icon: CircleAvatar(
                minRadius: 20,
                child: const Icon(Icons.share),
              ),
            ),
          ],
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
        LText(
          ConvertPageLocalization.haveError,
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(fontSize: 16, color: Theme.of(context).colorScheme.error),
        ),
        const SizedBox(width: 12),
        TextButton(onPressed: onRetry, child: LText(ConvertPageLocalization.retry)),
      ],
    );
  }
}
