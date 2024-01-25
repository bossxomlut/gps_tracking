part of '../../home/page/home.dart';

class EmptyHome extends StatefulWidget {
  const EmptyHome({Key? key}) : super(key: key);

  @override
  State<EmptyHome> createState() => _EmptyHomeState();
}

class _EmptyHomeState extends State<EmptyHome> implements PickMultipleFile {
  ConvertCubit get homeCubit => context.read<ConvertCubit>();

  @override
  bool get canPickMultipleFile => context.read<ConvertCubit>().canPickMultipleFile;

  @override
  Widget build(BuildContext context) {
    return EmptyPickerWidget(
      canPickMultipleFile: canPickMultipleFile,
      onGetFiles: (filePaths) {
        homeCubit.setPickedFiles(filePaths.map((e) => ConfigConvertFile(path: e.path, name: e.name)).toList());
      },
    );
  }
}
