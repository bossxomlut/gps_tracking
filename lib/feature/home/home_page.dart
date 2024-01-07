part of 'home.dart';

class _HomePage extends BasePage {
  const _HomePage({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 200,
            height: 200,
            color: AppTheme.theme(context).cardColor,
            child: TextButton(
              onPressed: () {
                AppTheme.instance.toggleMode();
              },
              child: Text(
                AppTheme.theme(context).cardColor.toString(),
              ),
            ),
          ),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: AppTheme.theme(context).cardColor,
            ),
          )
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _HomePage();
  }
}
