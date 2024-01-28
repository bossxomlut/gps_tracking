import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_convert/base_presentation/page/base_page.dart';
import 'package:mp3_convert/base_presentation/view/view.dart';
import 'package:mp3_convert/feature/convert/data/entity/media_type.dart';
import 'package:mp3_convert/feature/convert/data/entity/setting_file.dart';
import 'package:mp3_convert/feature/convert/widget/convert_status_widget.dart';
import 'package:mp3_convert/feature/convert/widget/file_type_widget.dart';
import 'package:mp3_convert/feature/merger/cubit/merger_cubit.dart';
import 'package:mp3_convert/feature/setting/help_and_feedback_page.dart';
import 'package:mp3_convert/resource/icon_path.dart';
import 'package:mp3_convert/resource/string.dart';
import 'package:mp3_convert/util/hardcode_string.dart';
import 'package:mp3_convert/util/list_util.dart';
import 'package:mp3_convert/util/show_snack_bar.dart';
import 'package:mp3_convert/widget/button/button.dart';
import 'package:mp3_convert/widget/empty_picker_widget.dart';
import 'package:collection/collection.dart';
import 'package:mp3_convert/widget/file_picker.dart';
import 'package:mp3_convert/widget/image.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:share_plus/share_plus.dart';

class MergerPage extends StatefulWidget {
  const MergerPage({super.key});

  @override
  State<MergerPage> createState() => _MergerPageState();
}

class _MergerPageState extends SingleProviderBasePageState<MergerPage, MergerCubit> {
  _MergerPageState() : super(cubit: MergerCubit());

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar();
  }

  @override
  Widget buildBody(BuildContext context) {
    return BlocBuilder<MergerCubit, MergerState>(
      builder: (context, state) {
        if (state.files.isNotNullAndNotEmpty) {
          return const _ListFilesContent();
        }
        return EmptyPickerWidget(
          canPickMultipleFile: true,
          onGetFiles: (files) {
            cubit.addFiles(files.map((f) => ConfigConvertFile(name: f.name, path: f.path)));
          },
        );
      },
    );
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context) {
    return BlocBuilder<MergerCubit, MergerState>(
      builder: (context, state) {
        if (state.files.isNotNullAndNotEmpty) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: FloatingActionButton(
              onPressed: () {
                const AnyFilePicker(allowMultiple: true).opeFilePicker().then((files) {
                  if (files != null && files.isNotEmpty) {
                    cubit.addFiles(files.map((f) => ConfigConvertFile(name: f.name, path: f.path)));
                  }
                }).catchError((error) {
                  //todo: handle error if necessary
                });
              },
              child: const Icon(Icons.add_circle_outline),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

class _ListFilesContent extends StatefulWidget {
  const _ListFilesContent({super.key});

  @override
  State<_ListFilesContent> createState() => _ListFilesContentState();
}

class _ListFilesContentState extends State<_ListFilesContent> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<MergerCubit, MergerState>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Expanded(
                //   child: Padding(
                //     padding: const EdgeInsets.all(16),
                //     child: Column(
                //       children: [
                //         ...?state.files?.map((f) => Container(
                //               padding: EdgeInsets.all(16),
                //               alignment: Alignment.centerLeft,
                //               decoration: BoxDecoration(
                //                 color: Theme.of(context).splashColor,
                //               ),
                //               child: ColumnStart(
                //                 children: [
                //                   Text(
                //                     f.name,
                //                     style: Theme.of(context).textTheme.bodyLarge,
                //                   ),
                //                   if (f is ConvertStatusFile) ConvertStatusWidget(convertFile: f, onDownload: (_) {}),
                //                 ],
                //               ),
                //             )),
                //       ],
                //     ),
                //   ),
                // ),
                Expanded(
                  child: ReorderableListView.builder(
                    itemBuilder: (context, index) {
                      final f = state.files![index];
                      return Dismissible(
                        key: ObjectKey(f),
                        direction: DismissDirection.endToStart,
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
                          padding: EdgeInsets.all(16),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: Theme.of(context).splashColor,
                            border: Border(
                              bottom: BorderSide(width: 1, color: Colors.white12),
                            ),
                          ),
                          child: Column(
                            children: [
                              ColumnStart(
                                children: [
                                  Text(
                                    f.name,
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  if (f is ConvertStatusFile) MergerStatusWidget(convertFile: f, onDownload: (_) {}),
                                ],
                              ),
                            ],
                          ),
                        ),
                        onDismissed: (direction) {
                          context.read<MergerCubit>().removeFileByIndex(index);
                        },
                      );
                    },
                    itemCount: state.files?.length ?? 0,
                    onReorder: (oldIndex, newIndex) {
                      context.read<MergerCubit>().onReorder(oldIndex, newIndex);
                    },
                  ),
                ),
                SafeArea(
                    minimum: const EdgeInsets.all(16),
                    child: Center(
                      child: Row(
                        children: [
                          LoadingButton(
                            child: Text(state.mediaType != null ? state.mediaType!.name : "Choose"),
                            onTap: () async {
                              final listMediaType = await context.read<MergerCubit>().getMappingType('');
                              if (mounted) {
                                if (listMediaType == null) {
                                  ShowSnackBar.showError(context, message: ConvertPageLocalization.haveError.tr());

                                  return;
                                }
                                final type = state.mediaType;

                                ListMediaTypeWidget(
                                  showApplyAll: false,
                                  typeList: listMediaType!,
                                  initList: type != null ? [MediaType(name: type.name!.toUpperCase())] : null,
                                  onApplyAll: (destinationType) {
                                    // widget.onSelectDestinationTypeForAll(destinationType.first.name);
                                  },
                                ).showBottomSheet(context).then((destinationType) {
                                  if (destinationType != null) {
                                    if (destinationType.isNotEmpty) {
                                      context.read<MergerCubit>().setType(destinationType.first.name);
                                    }
                                  }
                                });
                              }
                            },
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              // style: FilledButton.styleFrom(
                              //   backgroundColor: Color(0xfff25d17),
                              // ),
                              child: Text("Start merge".hardCode),
                              onPressed: (state.files?.length ?? 0) > 1
                                  ? () {
                                      context.read<MergerCubit>().startMerger();
                                    }
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            );
          },
        ),
        BlocSelector<MergerCubit, MergerState, MergeStatus?>(
          selector: (state) => state.status,
          builder: (context, status) {
            if (status != null) {
              print('status merge: ${status}');
              return Container(
                color: Colors.white.withOpacity(0.2),
                alignment: Alignment.center,
                child: Container(
                  width: double.maxFinite,
                  margin: const EdgeInsets.all(32),
                  padding: const EdgeInsets.all(16),
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColorDark, borderRadius: BorderRadius.circular(8)),
                  child: ColumnStart(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Đang xử lý",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      _getProgressWidget(status),
                      const SizedBox(height: 12),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                              onPressed: () {
                                context.read<MergerCubit>().cancelMerge();
                              },
                              child: Text('Cancel'.hardCode))),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        )
      ],
    );
  }

  String _getProgressString(MergeStatus status) {
    switch (status) {
      case MergeStatus.uploading:
        return "Progressing in upload...";
      case MergeStatus.converting:
        return "Progressing in convert...";
      case MergeStatus.downloading:
        return "Progressing in download...";
      case MergeStatus.downloaded:
        return "Progressing in convert...";
      case MergeStatus.merged:
        return "Progressing in convert...";
    }
  }

  Widget _getProgressWidget(MergeStatus status) {
    switch (status) {
      case MergeStatus.uploading:
        return Row(
          children: [
            const CircularProgressIndicator(strokeWidth: 2),
            const SizedBox(width: 20),
            Text(_getProgressString(status)),
          ],
        );
      case MergeStatus.converting:
        return Row(
          children: [
            const CircularProgressIndicator(strokeWidth: 2),
            const SizedBox(width: 20),
            Text(_getProgressString(status)),
          ],
        );
      case MergeStatus.downloaded:
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  OpenFile.open(context.read<MergerCubit>().getDownloadPath());
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
                // Share.shareXFiles([XFile((convertFile as DownloadedFile).downloadPath)]);
              },
              icon: const CircleAvatar(
                minRadius: 20,
                child: Icon(Icons.share),
              ),
            ),
          ],
        );
      case MergeStatus.downloading:
        return Row(
          children: [
            const CircularProgressIndicator(strokeWidth: 2),
            const SizedBox(width: 20),
            Text(_getProgressString(status)),
          ],
        );

      case MergeStatus.merged:
        return ElevatedButton(
          onPressed: () {
            context.read<MergerCubit>().startDownload();
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
    }
  }
}
