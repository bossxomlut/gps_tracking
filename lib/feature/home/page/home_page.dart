part of 'home.dart';

class MenuPage extends BasePage {
  const MenuPage({super.key});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("MP3-Convert"),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem<int>(value: 0, child: LText(SettingLocalization.setting)),
              PopupMenuItem<int>(value: 1, child: LText(SettingLocalization.instruction)),
              PopupMenuItem<int>(value: 2, child: LText(SettingLocalization.helpAndFeedback)),
            ];
          },
          onSelected: (value) {
            switch (value) {
              case 0:
                {
                  AppNavigator.to(GetSettingPage());
                  break;
                }
              case 1:
                {
                  //todo:
                  break;
                }
              case 2:
                {
                  AppNavigator.to(GetHelpAndFeedbackPage());
                  break;
                }
            }
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
                  const SizedBox(height: 20),
                  LText(
                    HomePageLocalization.features,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FeatureMenuButton(
                        onTap: () {
                          AppNavigator.to(GetConvertPage());
                        },
                        icon: IconPath.exchange,
                        titleKey: CommonLocalization.convert,
                        backgroundColor: const Color(0xfffd4da8),
                      ),
                      CutMenuButton(
                        onTap: () {
                          AppNavigator.to(GetAudioCutterPage());
                        },
                        icon: IconPath.cut,
                        titleKey: CommonLocalization.cutter,
                        backgroundColor: const Color(0xfff39565),
                      ),
                      FeatureMenuButton(
                        icon: IconPath.merger,
                        titleKey: CommonLocalization.merger,
                        backgroundColor: const Color(0xff308ad5),
                      ),
                    ],
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
                  LText(
                    HomePageLocalization.history,
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

class CutMenuButton extends FeatureMenuButton {
  const CutMenuButton({
    super.key,
    required super.icon,
    required super.titleKey,
    super.backgroundColor,
    super.onTap,
  });

  @override
  Widget buildIcon(BuildContext context) {
    final theme = Theme.of(context);

    final color = backgroundColor ?? theme.highlightColor;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withOpacity(0.7),
            color.withOpacity(0.5),
            color.withOpacity(0.3),
          ],
        ),
      ),
      child: const Icon(
        Icons.cut,
        size: 32,
      ),
    );
  }
}

class FeatureMenuButton extends StatelessWidget {
  const FeatureMenuButton({
    super.key,
    required this.icon,
    required this.titleKey,
    this.backgroundColor,
    this.onTap,
  });

  final String icon;
  final String titleKey;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final isEnable = onTap != null;
    final widget = GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          buildIcon(context),
          const SizedBox(height: 8),
          LText(
            titleKey,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
    if (!isEnable) {
      return Opacity(
        opacity: 0.2,
        child: widget,
      );
    }
    return widget;
  }

  Widget buildIcon(BuildContext context) {
    final theme = Theme.of(context);

    final color = backgroundColor ?? theme.highlightColor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withOpacity(0.7),
            color.withOpacity(0.5),
            color.withOpacity(0.3),
          ],
        ),
      ),
      child: AppImage.svg(
        icon,
        color: Theme.of(context).iconTheme.color,
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
