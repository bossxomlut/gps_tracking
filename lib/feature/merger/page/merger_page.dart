import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_convert/base_presentation/page/base_page.dart';
import 'package:mp3_convert/feature/convert/data/entity/setting_file.dart';
import 'package:mp3_convert/feature/convert/widget/convert_status_widget.dart';
import 'package:mp3_convert/feature/merger/cubit/merger_cubit.dart';
import 'package:mp3_convert/util/hardcode_string.dart';
import 'package:mp3_convert/util/list_util.dart';
import 'package:mp3_convert/widget/empty_picker_widget.dart';
import 'package:collection/collection.dart';
import 'package:mp3_convert/widget/file_picker.dart';

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
          return FloatingActionButton(
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
    return BlocBuilder<MergerCubit, MergerState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                children: [
                  ...?state.files?.map((f) => Card(
                        child: Column(
                          children: [
                            Text(f.name),
                            if (f is ConvertStatusFile) ConvertStatusWidget(convertFile: f, onDownload: (_) {}),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            SafeArea(
                minimum: const EdgeInsets.all(16),
                child: Center(
                  child: FilledButton(
                    // style: FilledButton.styleFrom(
                    //   backgroundColor: Color(0xfff25d17),
                    // ),
                    child: Text("Start merge".hardCode),
                    onPressed: () {
                      context.read<MergerCubit>().startMerger();
                    },
                  ),
                )),
          ],
        );
      },
    );
  }
}
