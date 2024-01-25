import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_convert/base_presentation/cubit/event_mixin.dart';
import 'package:mp3_convert/base_presentation/view/view.dart';
import 'package:mp3_convert/data/entity/app_file.dart';
import 'package:mp3_convert/feature/home/cubit/convert_cubit.dart';
import 'package:mp3_convert/feature/home/cubit/convert_event.dart';
import 'package:mp3_convert/feature/home/cubit/convert_state.dart';
import 'package:mp3_convert/feature/home/data/entity/setting_file.dart';
import 'package:mp3_convert/feature/home/page/home.dart';
import 'package:mp3_convert/resource/string.dart';
import 'package:mp3_convert/util/navigator/app_navigator.dart';
import 'package:mp3_convert/util/navigator/app_page.dart';
import 'package:mp3_convert/util/show_snack_bar.dart';
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
    return AppBar(
      actions: [
        IconButton(
            onPressed: () {
              AppNavigator.to(GetConvertSettingPage());
            },
            icon: const Icon(Icons.settings)),
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
    AnyFilePicker(allowMultiple: canPickMultipleFile).opeFilePicker().then((appFiles) {
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
        ShowSnackBar.showError(context, message: ConvertPageLocalization.requireChooseFileType.tr());

        return;
      case CannotDownloadFileEvent():
        ShowSnackBar.showError(context, message: ConvertPageLocalization.canNotDownloadFile.tr());
        return;
      default:
        return;
    }
  }
}
