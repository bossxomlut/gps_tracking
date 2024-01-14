part of 'home.dart';

class PickedFileHome extends StatelessWidget {
  const PickedFileHome({Key? key, required this.files}) : super(key: key);

  final List<SettingFile> files;

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
                  ...files.mapIndexed((index, file) => AppFileCard(
                        key: ValueKey(file.path),
                        file: file,
                        onSelectDestinationType: (type) {
                          context.read<HomeCubit>().updateDestinationType(index, file, type);
                        },
                      )),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
            child: ElevatedButton(
                onPressed: () {
                  context.read<HomeCubit>().onConvertAll();
                },
                child: Text("Start Convert"))),
      ],
    );
  }
}

class AppFileCard extends StatefulWidget {
  const AppFileCard({super.key, required this.file, required this.onSelectDestinationType});

  final SettingFile file;
  final ValueChanged<String> onSelectDestinationType;

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
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  file.name,
                  style: textTheme.titleMedium,
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                file.type,
                style: textTheme.titleMedium,
              ),
              Icon(Icons.arrow_forward),
              Row(
                children: [
                  LoadingButton(
                    child: Text(file.destinationType ?? "Chọn"),
                    onTap: () async {
                      final listMediaType = await context.read<HomeCubit>().getMappingType(file.type);
                      ListMediaTypeWidget(
                        typeList: listMediaType ?? ListMediaType(types: []),
                        initList: file.destinationType != null ? [MediaType(name: file.destinationType!)] : null,
                      ).showBottomSheet(context).then((destinationType) {
                        if (destinationType != null) {
                          if (destinationType.isNotEmpty) {
                            widget.onSelectDestinationType(destinationType.first.name);
                          }
                        }
                      });
                    },
                  ),
                  // IconButton(onPressed: () {}, icon: Icon(Icons.settings))
                ],
              )
              // const SizedBox(width: 16),
              // Text(file.type),
              // IconButton(
              //   onPressed: () {
              //     context.read<HomeCubit>().removeFile(file);
              //   },
              //   icon: const Icon(Icons.close),
              // )
            ],
          ),
          if (file is ConvertFile) Text("${file.status.name}"),
          if (file is ConvertFile)
            if (file.status == ConvertStatus.converted)
              TextButton(
                  onPressed: () {
                    context.read<HomeCubit>().downloadConvertedFile(file.downloadId!);
                  },
                  child: Text("Download")),
        ],
      ),
    );
  }
}
