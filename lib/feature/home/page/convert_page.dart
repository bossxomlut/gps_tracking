import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_convert/base_presentation/cubit/event_mixin.dart';
import 'package:mp3_convert/base_presentation/view/view.dart';
import 'package:mp3_convert/feature/home/cubit/convert_cubit.dart';
import 'package:mp3_convert/feature/home/cubit/convert_event.dart';
import 'package:mp3_convert/feature/home/cubit/convert_state.dart';
import 'package:mp3_convert/feature/home/data/entity/setting_file.dart';
import 'package:mp3_convert/feature/home/page/home.dart';
import 'package:mp3_convert/resource/string.dart';
import 'package:mp3_convert/widget/file_picker.dart';
import 'package:mp3_convert/base_presentation/page/base_page.dart';

class ConvertPage extends StatefulWidget {
  const ConvertPage({super.key});

  @override
  State<ConvertPage> createState() => _ConvertPageState();
}

class _ConvertPageState extends SingleProviderBasePageState<ConvertPage, ConvertCubit>
    with EventStateMixin<ConvertPage, HomeEvent> {
  _ConvertPageState() : super(cubit: ConvertCubit());

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    final List<String> keys = [];
    return AppBar(
      actions: [
        PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem<int>(value: 0, child: LText(SettingLocalization.setting)),
              PopupMenuItem<int>(value: 1, child: LText(SettingLocalization.instruction)),
              PopupMenuItem<int>(value: 2, child: LText(SettingLocalization.helpAndFeedback)),
            ];
          },
        )
      ],
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return BlocBuilder<ConvertCubit, ConvertState>(
      builder: (context, state) {
        switch (state) {
          case PickedFileState():
            return PickedFileHome(
              files: state.files!,
            );
          case ConvertEmptyState():
            return const EmptyHome();
        }
      },
    );
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context) {
    return BlocBuilder<ConvertCubit, ConvertState>(builder: (context, state) {
      switch (state) {
        case PickedFileState():
          return FloatingActionButton(
            onPressed: () {
              _openPickerDialog(state.canPickMultipleFile);
            },
            child: const Icon(Icons.add_circle_outline),
          );
        default:
          return const SizedBox();
      }
    });
  }

  void _openPickerDialog(bool canPickMultipleFile) async {
    VideoFilePicker(allowMultiple: canPickMultipleFile).opeFilePicker().then((appFiles) {
      setFiles(appFiles ?? []);
    }).catchError((error) {
      //todo: handle error if necessary
    });
  }

  void setFiles(List<AppFile> filePaths) {
    cubit.addPickedFiles(filePaths.map((e) => ConfigConvertFile(path: e.path, name: e.name)).toList());
  }

  @override
  Stream<HomeEvent> get eventStream => cubit.$eventStream;

  @override
  void eventListener(event) {
    switch (event) {
      case UnknownDestinationEvent():
        const snackBar = SnackBar(
          content: Text('Please select convert file type!'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      default:
        return;
    }
  }
}
