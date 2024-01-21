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
                onRetry: () {
                  if (file is ConvertErrorFile) {
                    context.read<ConvertCubit>().onRetry(index, file);
                  }
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
