import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_convert/base_presentation/view/base_view.dart';
import 'package:mp3_convert/base_presentation/view/view.dart';
import 'package:mp3_convert/feature/home/cubit/convert_cubit.dart';
import 'package:mp3_convert/feature/home/data/entity/media_type.dart';
import 'package:mp3_convert/feature/home/data/entity/setting_file.dart';
import 'package:mp3_convert/feature/home/widget/convert_status_widget.dart';
import 'package:mp3_convert/feature/home/widget/file_type_widget.dart';
import 'package:mp3_convert/feature/home/widget/uploading_progress_bar.dart';
import 'package:mp3_convert/resource/string.dart';
import 'package:mp3_convert/util/reduce_text.dart';
import 'package:mp3_convert/util/show_snack_bar.dart';
import 'package:mp3_convert/widget/button/loading_button.dart';

class AppFileCard extends StatefulWidget {
  const AppFileCard({
    super.key,
    required this.file,
    required this.onSelectDestinationType,
    required this.onSelectDestinationTypeForAll,
    required this.onConvert,
    required this.onRetry,
    required this.onDelete,
  });

  final ConfigConvertFile file;
  final ValueChanged<String> onSelectDestinationType;
  final ValueChanged<String> onSelectDestinationTypeForAll;
  final VoidCallback onConvert;
  final VoidCallback onRetry;
  final VoidCallback onDelete;

  @override
  State<AppFileCard> createState() => _AppFileCardState();
}

class _AppFileCardState extends BaseStatefulWidgetState<AppFileCard> {
  @override
  Widget build(BuildContext context) {
    final file = widget.file;

    return Dismissible(
      key: ObjectKey(file),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        widget.onDelete();
      },
      background: ColoredBox(
        color: const Color(0xFFf44234).withOpacity(0.7),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.delete),
              const SizedBox(width: 4),
              LText(ConvertPageLocalization.delete),
            ],
          ),
        ),
      ),
      secondaryBackground: ColoredBox(
        color: const Color(0xFFf44234).withOpacity(0.7),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Spacer(),
              const Icon(Icons.delete),
              const SizedBox(width: 4),
              LText(ConvertPageLocalization.delete),
            ],
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.highlightColor,
          boxShadow: [
            BoxShadow(offset: const Offset(0, -2), blurRadius: 4.0, color: Colors.black.withOpacity(0.04)),
            BoxShadow(offset: const Offset(0, 4), blurRadius: 8.0, color: Colors.black.withOpacity(0.12)),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    reduceText(file.name),
                    style: textTheme.titleMedium,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.arrow_forward),
                const SizedBox(width: 12),
                Row(
                  children: [
                    LoadingButton(
                      isError: file is UnValidConfigConvertFile,
                      onTap: () async {
                        final listMediaType = await context.read<ConvertCubit>().getMappingType(file.type);
                        if (mounted) {
                          if (listMediaType == null) {
                            ShowSnackBar.showError(context, message: ConvertPageLocalization.haveError.tr());

                            return;
                          }

                          ListMediaTypeWidget(
                            typeList: listMediaType!,
                            initList: file.destinationType != null
                                ? [MediaType(name: file.destinationType!.toUpperCase())]
                                : null,
                            onApplyAll: (destinationType) {
                              widget.onSelectDestinationTypeForAll(destinationType.first.name);
                            },
                          ).showBottomSheet(context).then((destinationType) {
                            if (destinationType != null) {
                              if (destinationType.isNotEmpty) {
                                widget.onSelectDestinationType(destinationType.first.name);
                              }
                            }
                          });
                        }
                      },
                      child: file.destinationType != null
                          ? Text(file.destinationType!)
                          : LText(ConvertPageLocalization.choose),
                    ),
                    // IconButton(onPressed: () {}, icon: Icon(Icons.settings))
                  ],
                )
              ],
            ),
            if (file is ConvertErrorFile)
              _getErrorWidget(file)
            else if (file.destinationType != null)
              if (file is ConvertStatusFile)
                const SizedBox()
              else
                Column(
                  children: [
                    const Divider(),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: widget.onConvert,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                        child: Center(
                          child: LText(
                            ConvertPageLocalization.convert,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            if (file is ConvertStatusFile)
              Column(
                children: [
                  const Divider(),
                  ConvertStatusWidget(
                    convertFile: file,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _getErrorWidget(ConvertErrorFile file) {
    switch (file.convertStatusFile.status) {
      case ConvertStatus.uploading:
      case ConvertStatus.uploaded:
      case ConvertStatus.converting:
      case ConvertStatus.converted:
      case ConvertStatus.downloaded:
        return Column(
          children: [
            const Divider(),
            ConvertErrorWidget(
              onRetry: widget.onRetry,
            ),
          ],
        );
      case ConvertStatus.downloading:
        return Column(
          children: [
            const Divider(),
            DownloadingProgressBar(
              isError: true,
              progress: (file.convertStatusFile as DownloadingFile).downloadProgress,
            ),
          ],
        );
    }
  }
}
