abstract class Localization {}

class SettingLocalization {
  static String get prefix => "setting.";

  static String get setting => "${prefix}setting";

  static String get instruction => "${prefix}instruction";

  static String get helpAndFeedback => "${prefix}help_and_feedback";

  static String get language => "${prefix}language";
}

class CommonLocalization {
  static String get prefix => "common.";

  static String get lostConnectInternet => "${prefix}lost_connect_internet";

  static String get emptyList => "${prefix}empty_list";

  static String get convert => "${prefix}convert";
}

class HomePageLocalization {
  static String get prefix => "home_page.";

  static String get features => "${prefix}features";

  static String get history => "${prefix}history";
}

class ConvertPageLocalization {
  static String get prefix => "convert_page.";

  static String get tapToSelectFiles => "${prefix}tap_to_select_files";

  static String get choose => "${prefix}choose";

  static String get convert => "${prefix}convert";

  static String get uploading => "${prefix}uploading";

  static String get converting => "${prefix}converting";

  static String get download => "${prefix}download";

  static String get downloading => "${prefix}downloading";

  static String get openFile => "${prefix}open_file";

  static String get haveError => "${prefix}have_error";

  static String get retry => "${prefix}retry";

  static String get downloadError => "${prefix}download_error";

  static String get startConvertAll => "${prefix}start_convert_all";

  static String get delete => "${prefix}delete";

  static String get requireChooseFileType => "${prefix}require_choose_file_type";
}
