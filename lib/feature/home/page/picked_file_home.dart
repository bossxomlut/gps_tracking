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
                        onConvert: () {
                          context.read<HomeCubit>().onConvert(index, file);
                        },
                      )),
                ],
              ),
            ),
          ),
        ),
        // SafeArea(
        //     child: ElevatedButton(
        //         onPressed: () {
        //           context.read<HomeCubit>().onConvertAll();
        //         },
        //         child: Text("Start Convert"))),
      ],
    );
  }
}

class AppFileCard extends StatefulWidget {
  const AppFileCard({super.key, required this.file, required this.onSelectDestinationType, required this.onConvert});

  final SettingFile file;
  final ValueChanged<String> onSelectDestinationType;
  final VoidCallback onConvert;

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
                  reduceText(file.name),
                  style: textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.arrow_forward),
              const SizedBox(width: 12),
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
            ],
          ),
          if (file.destinationType != null)
            if (file is ConvertFile)
              const SizedBox()
            else
              Column(
                children: [
                  Divider(),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: widget.onConvert,
                      child: Center(
                        child: Text(
                          "Convert",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
          if (file is ConvertFile)
            Column(
              children: [
                Divider(),
                ConvertStatsWidget(
                  convertFile: file,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class ConvertStatsWidget extends StatelessWidget {
  const ConvertStatsWidget({
    super.key,
    required this.convertFile,
  });

  final ConvertFile convertFile;

  @override
  Widget build(BuildContext context) {
    final ConvertStatus status = convertFile.status;
    final double? progress = convertFile.convertProgress;
    final double? downloadProgress = convertFile.downloadProgress;
    final String? downloadId = convertFile.downloadId;
    switch (status) {
      case ConvertStatus.uploading:
        return const UploadingProgressBar();
      case ConvertStatus.uploaded:
        return const UploadingProgressBar(progress: 1);
      case ConvertStatus.converting:
        return ConvertingProgressBar(progress: progress);
      case ConvertStatus.converted:
        return ElevatedButton(
          onPressed: () {
            context.read<HomeCubit>().downloadConvertedFile(downloadId!);
          },
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppImage.svg(
                  IconPath.download,
                  color: Colors.white,
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "Download",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
        );
      case ConvertStatus.downloading:
        return DownloadingProgressBar(progress: downloadProgress);
      case ConvertStatus.downloaded:
        return ElevatedButton(
          onPressed: () {
            OpenFile.open(convertFile.downloadPath);
          },
          child: Center(
            child: Text(
              "Open File",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
        );
    }
  }
}
