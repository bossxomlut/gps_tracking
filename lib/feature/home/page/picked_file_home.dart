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
        _MenuWidget(),
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

class _MenuWidget extends StatelessWidget {
  const _MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        child: Container(
          width: double.maxFinite,
          child: Row(
            children: [
              Expanded(
                child: _CustomMenuButton(
                  title: MenuLocalization.tool.tr(),
                  onTap: () {},
                ),
              ),
              Expanded(
                child: _CustomMenuButton(
                  title: MenuLocalization.export.tr(),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomMenuButton extends StatelessWidget {
  const _CustomMenuButton({super.key, required this.title, this.onTap});

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Text(title.toUpperCase()),
      ),
    );
  }
}
