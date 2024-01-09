part of 'home.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _HomePage();
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
