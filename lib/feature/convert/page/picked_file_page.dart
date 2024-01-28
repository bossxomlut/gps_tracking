part of '../../home/page/home.dart';

class ConvertPickedFilePage extends StatelessWidget {
  const ConvertPickedFilePage({Key? key, required this.files}) : super(key: key);

  final List<ConfigConvertFile> files;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) {
              final file = files[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppFileCard(
                  file: file,
                  onSelectDestinationType: (type) {
                    context.read<ConvertCubit>().updateDestinationType(index, file, type.toLowerCase());
                  },
                  onSelectDestinationTypeForAll: (type) {
                    context.read<ConvertCubit>().updateDestinationTypeForAll(type.toLowerCase());
                  },
                  onConvert: () {
                    context.read<ConvertCubit>().onConvert(index, file);
                  },
                  onRetry: () {
                    if (file is ConvertErrorFile) {
                      context.read<ConvertCubit>().onRetry(index, file);
                    }
                  },
                  onDelete: () {
                    context.read<ConvertCubit>().removeFileByIndex(index);
                  },
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemCount: files.length,
          ),
        ),
        if (files.length > 1)
          FutureBuilder<bool>(future: (() async {
            return files.any((f) {
              return f.runtimeType == ConfigConvertFile;
            });
          })(), builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == true) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<ConvertCubit>().onConvertAll();
                    },
                    child: LText(ConvertPageLocalization.startConvertAll),
                  ),
                ),
              );
            }
            return const SizedBox();
          }),
      ],
    );
  }
}
