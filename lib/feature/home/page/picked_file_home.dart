part of 'home.dart';

class PickedFileHome extends StatelessWidget {
  const PickedFileHome({Key? key, required this.paths}) : super(key: key);

  final List<String> paths;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Center(child: Text(paths.toString()))),
        _MenuWidget(),
      ],
    );
  }
}

class _MenuWidget extends StatelessWidget {
  const _MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.maxFinite,
      child: Row(
        children: [
          Expanded(child: Text("Cong cu")),
          Expanded(child: Text("Xuat")),
        ],
      ),
    );
  }
}
