abstract class Localization {}

class SettingLocalization {
  static String get prefix => "setting.";

  static String get setting => "${prefix}setting";

  static String get instruction => "${prefix}instruction";

  static String get helpAndFeedback => "${prefix}help_and_feedback";
}

class SelectFileLocalization {
  static String get prefix => "selectFile.";

  static String get tapToSelectFile => "${prefix}tapToSelectFile";

  static String get tapToSelectFiles => "${prefix}tapToSelectFiles";
}

class MenuLocalization {
  static String get prefix => "menu.";

  static String get tool => "${prefix}tool";

  static String get export => "${prefix}export";
}
