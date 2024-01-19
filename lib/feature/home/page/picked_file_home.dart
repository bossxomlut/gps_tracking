part of 'home.dart';

class PickedFileHome extends StatelessWidget {
  const PickedFileHome({Key? key, required this.files}) : super(key: key);

  final List<ConfigConvertFile> files;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) {
              final file = files[index];
              return AppFileCard(
                file: file,
                onSelectDestinationType: (type) {
                  context.read<ConvertCubit>().updateDestinationType(index, file, type);
                },
                onConvert: () {
                  context.read<ConvertCubit>().onConvert(index, file);
                },
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemCount: files.length,
          ),
        ),
        if (files.length > 1)
          SafeArea(
            child: ElevatedButton(
              onPressed: () {
                context.read<ConvertCubit>().onConvertAll();
              },
              child: Text("Start Convert All"),
            ),
          ),
      ],
    );
  }
}

class AppFileCard extends StatefulWidget {
  const AppFileCard({super.key, required this.file, required this.onSelectDestinationType, required this.onConvert});

  final ConfigConvertFile file;
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
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(offset: const Offset(0, -2), blurRadius: 4.0, color: Colors.black.withOpacity(0.04)),
          BoxShadow(offset: const Offset(0, 4), blurRadius: 8.0, color: Colors.black.withOpacity(0.12)),
        ],
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
                    isError: file is UnValidConfigConvertFile,
                    onTap: () async {
                      final listMediaType = await context.read<ConvertCubit>().getMappingType(file.type);
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
            if (file is ConvertStatusFile)
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
          if (file is ConvertStatusFile)
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

  final ConvertStatusFile convertFile;

  @override
  Widget build(BuildContext context) {
    final ConvertStatus status = convertFile.status;

    switch (status) {
      case ConvertStatus.uploading:
        return const UploadingProgressBar();
      case ConvertStatus.uploaded:
        return const UploadingProgressBar(progress: 1);
      case ConvertStatus.converting:
        final double? progress = (convertFile as ConvertingFile).convertProgress;

        return ConvertingProgressBar(progress: progress);
      case ConvertStatus.converted:
        return ElevatedButton(
          onPressed: () {
            final String? downloadId = (convertFile as ConvertedFile).downloadId;
            context.read<ConvertCubit>().downloadConvertedFile(downloadId!);
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
        final double? downloadProgress = (convertFile as DownloadingFile).downloadProgress;
        return DownloadingProgressBar(progress: downloadProgress);
      case ConvertStatus.downloaded:
        return ElevatedButton(
          onPressed: () {
            if (convertFile is DownloadedFile) {
              OpenFile.open((convertFile as DownloadedFile).downloadPath);
            }
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
