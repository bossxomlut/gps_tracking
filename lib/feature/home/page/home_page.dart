part of 'home.dart';

class MenuPage extends BasePage {
  const MenuPage({super.key});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("MP3-Convert"),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem<int>(value: 0, child: LText(SettingLocalization.setting)),
              PopupMenuItem<int>(value: 1, child: LText(SettingLocalization.instruction)),
              PopupMenuItem<int>(value: 2, child: LText(SettingLocalization.helpAndFeedback)),
            ];
          },
        )
      ],
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Features",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Card(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ConvertPage(),
                ));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        AppImage.svg(IconPath.exchange),
                        const SizedBox(width: 16),
                        Text(
                          'Convert',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    )),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "History",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          const HistoryDownloadWidget(),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ShowLostConnectInternetHelper _connectInternetHelper = ShowLostConnectInternetHelper(context);
  @override
  void initState() {
    super.initState();
    socketChannel.startConnection();

    PermissionHelper.requestStoragePermission();
    PermissionHelper.requestNotificationPermission();

    _connectInternetHelper.startListen();
  }

  @override
  void dispose() {
    _connectInternetHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MenuPage();
  }
}

class HistoryDownloadWidget extends StatefulWidget {
  const HistoryDownloadWidget({super.key});

  @override
  State<HistoryDownloadWidget> createState() => _HistoryDownloadWidgetState();
}

class _HistoryDownloadWidgetState extends State<HistoryDownloadWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AppFile>>(
      future: (() async {
        final path = await getPath();
        print("path: ${path}");
        Directory dir = Directory(path);

        return dir
            .listSync()
            .whereType<File>()
            .map((f) => AppFile(
                  path: f.absolute.uri.path,
                  name: f.name,
                ))
            .toList();
      })(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final files = snapshot.data!;
          if (files.isEmpty) {
            return Text("Empty list");
          }
          return Column(
            children: [...snapshot.data!.map((f) => FileInfoCard(file: f))],
          );
        }
        return const SizedBox();
      },
    );
  }
}

class FileInfoCard extends StatelessWidget {
  const FileInfoCard({super.key, required this.file});

  final AppFile file;

  @override
  Widget build(BuildContext context) {
    final stat = FileStat.statSync(file.path);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.file_present_rounded,
                  size: 60,
                ),
                Text(file.type),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.name,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    stat.modified.toString(),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  Share.shareXFiles([XFile(file.path)]);
                },
                icon: Icon(Icons.share)),
          ],
        ),
      ),
    );
  }
}
