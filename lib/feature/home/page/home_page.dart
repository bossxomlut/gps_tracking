part of 'home.dart';

class MenuPage extends BasePage {
  const MenuPage({super.key});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("MP3-Convert"),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        ToolButton(
          title: 'Convert',
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => _HomePage(),
            ));
          },
          icon: "icon_convert",
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
  @override
  void initState() {
    super.initState();
    socketChannel.startConnection();
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
