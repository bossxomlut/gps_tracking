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
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(16),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => _HomePage(),
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

class _HomePage extends SingleProviderBasePage<HomeCubit> {
  _HomePage({super.key}) : super(HomeCubit());

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    final List<String> keys = [];
    return AppBar(
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
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      switch (state) {
        case PickedFileState():
          return PickedFileHome(
            files: state.files!,
          );
        case HomeEmptyState():
          return const EmptyHome();
      }
    });
  }
}
