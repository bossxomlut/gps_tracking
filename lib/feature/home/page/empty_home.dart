part of 'home.dart';

class EmptyHome extends StatelessWidget {
  const EmptyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPickerDialog(context),
      child: Center(
        child: Icon(
          Icons.add_circle_outline,
          size: 200,
          color: Colors.black26,
        ),
      ),
    );
  }

  void _openPickerDialog(BuildContext context) async {
    //todo: implement this
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: true,
    );

    if (result != null) {
      setFiles(result.files.map((e) => e.path!).toList(), context);
    }
  }

  void setFiles(List<String> filePaths, BuildContext context) {
    context.read<HomeCubit>().setPickedFiles(filePaths);
  }
}
