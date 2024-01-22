import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mp3_convert/base_presentation/view/safe_set_state.dart';
import 'package:mp3_convert/data/entity/app_file.dart';
import 'package:mp3_convert/feature/home/cubit/convert_cubit.dart';
import 'package:mp3_convert/feature/home/widget/file_info_card.dart';
import 'package:mp3_convert/resource/image_path.dart';
import 'package:mp3_convert/util/app_life_cycle_mixin.dart';
import 'package:mp3_convert/widget/image.dart';

class HistoryDownloadWidget extends StatefulWidget {
  const HistoryDownloadWidget({super.key});

  @override
  State<HistoryDownloadWidget> createState() => _HistoryDownloadWidgetState();
}

class _HistoryDownloadWidgetState extends AppLifeCycleMixin<HistoryDownloadWidget>
    with SafeSetState<HistoryDownloadWidget> {
  List<AppFile>? _files;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  @override
  void didUpdateWidget(covariant HistoryDownloadWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadFiles();
  }

  void _loadFiles() async {
    final path = await getPath();
    Directory dir = Directory(path);

    _files = dir
        .listSync()
        .whereType<File>()
        .map(
          (f) => AppFile(
            path: f.absolute.uri.path,
            name: f.name,
          ),
        )
        .toList();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void onResume() {
    super.onResume();
    _loadFiles();
  }

  @override
  Widget build(BuildContext context) {
    if (_files?.isEmpty ?? true) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppImage.asset(
              ImagePath.empty,
              width: 60,
              height: 60,
              color: Theme.of(context).hintColor,
            ),
            const SizedBox(height: 12),
            Text(
              "Empty list",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
            ),
          ],
        ),
      );
    }
    return Column(
      children: [..._files!.map((f) => FileInfoCard(file: f))],
    );
  }
}
