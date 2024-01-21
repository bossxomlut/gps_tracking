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
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                ],
              ),
            ),
          )
        ];
      },
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "History",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  const HistoryDownloadWidget(),
                ],
              ),
            ),
          ),
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

  final List<Function> _permissions = [
    PermissionHelper.requestNotificationPermission,
    PermissionHelper.requestAudioPermission,
    PermissionHelper.requestVideoPermission,
    PermissionHelper.requestStoragePermission,
  ];

  void _callPermissions() async {
    for (int i = 0; i < _permissions.length; i++) {
      await _permissions[i]();
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    socketChannel.startConnection();

    _connectInternetHelper.startListen();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callPermissions();
    });
  }

  @override
  void dispose() {
    _connectInternetHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const MenuPage();
  }
}
