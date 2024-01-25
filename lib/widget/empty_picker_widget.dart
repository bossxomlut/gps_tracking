import 'package:flutter/material.dart';
import 'package:mp3_convert/base_presentation/view/view.dart';
import 'package:mp3_convert/data/entity/app_file.dart';
import 'package:mp3_convert/resource/string.dart';
import 'package:mp3_convert/widget/file_picker.dart';

class EmptyPickerWidget extends StatelessWidget {
  const EmptyPickerWidget({
    super.key,
    required this.canPickMultipleFile,
    required this.onGetFiles,
  });

  final bool canPickMultipleFile;
  final ValueChanged<List<AppFile>> onGetFiles;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openPickerDialog,
      child: ColoredBox(
        color: Colors.transparent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_circle_outline,
                size: 200,
              ),
              const SizedBox(height: 16),
              LText(
                canPickMultipleFile
                    ? ConvertPageLocalization.tapToSelectFiles
                    : ConvertPageLocalization.tapToSelectFiles,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openPickerDialog() async {
    AnyFilePicker(allowMultiple: canPickMultipleFile).opeFilePicker().then((appFiles) {
      setFiles(appFiles ?? []);
    }).catchError((error) {
      //todo: handle error if necessary
    });
  }

  void setFiles(List<AppFile> filePaths) {
    onGetFiles(filePaths);
  }
}
