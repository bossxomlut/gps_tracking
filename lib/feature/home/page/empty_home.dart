part of 'home.dart';

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
                color: Colors.black26,
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
    homeCubit.setPickedFiles(filePaths.map((e) => ConfigConvertFile(path: e.path, name: e.name)).toList());
  }
}
