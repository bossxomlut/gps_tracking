part of 'theme.dart';

class AppTheme extends ChangeNotifier {
  AppTheme._();

  static AppTheme? _instance;

  static AppTheme get instance => _instance!;

  static BuildContext? _rootContext;

  factory AppTheme.initFromRootContext(BuildContext context) {
    _rootContext = context;
    _instance ??= AppTheme._();
    return instance;
  }

  static ThemeData theme(BuildContext context) => Theme.of(context);

  static TextTheme textTheme(BuildContext context) => theme(context).textTheme;

  ThemeMode _mode = ThemeMode.dark;

  ThemeMode get mode => _mode;

  void setMode(ThemeMode mode) {
    _mode = mode;
    notifyListeners();
  }

  void toggleMode() {
    switch (_mode) {
      case ThemeMode.system:
      case ThemeMode.light:
        _mode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        _mode = ThemeMode.light;
        break;
    }
    notifyListeners();
  }
}
