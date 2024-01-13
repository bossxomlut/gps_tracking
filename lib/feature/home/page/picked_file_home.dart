part of 'home.dart';

class PickedFileHome extends StatelessWidget {
  const PickedFileHome({Key? key, required this.files}) : super(key: key);

  final List<AppFile> files;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...files.map((file) => AppFileCard(key: ValueKey(file.path), file: file)),
                ],
              ),
            ),
          ),
        ),
        MenuWidget(),
      ],
    );
  }
}

class AppFileCard extends StatefulWidget {
  const AppFileCard({super.key, required this.file});

  final AppFile file;

  @override
  State<AppFileCard> createState() => _AppFileCardState();
}

class _AppFileCardState extends BaseStatefulWidgetState<AppFileCard> {
  @override
  Widget build(BuildContext context) {
    final file = widget.file;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              file.name,
              style: textTheme.titleMedium,
            ),
          ),
          // const SizedBox(width: 16),
          // Text(file.type),
          IconButton(
            onPressed: () {
              context.read<HomeCubit>().removeFile(file);
            },
            icon: const Icon(Icons.close),
          )
        ],
      ),
    );
  }
}
