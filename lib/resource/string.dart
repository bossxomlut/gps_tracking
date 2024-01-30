abstract class Localization {}

class SettingLocalization {
  static String get prefix => "";

  static String get setting => "${prefix}setting";

  static String get instruction => "${prefix}instruction";

  static String get helpAndFeedback => "${prefix}help_and_feedback";

  static String get language => "${prefix}language";

  static String get version => "${prefix}version";

  static String get developerTeam => "${prefix}developer_team";
}

class CommonLocalization {
  static String get prefix => "";

  static String get lostConnectInternet => "${prefix}lost_connect_internet";

  static String get emptyList => "${prefix}empty_list";

  static String get convert => "${prefix}convert";

  static String get cutter => "${prefix}cutter";

  static String get merger => "${prefix}merger";
}

class HomePageLocalization {
  static String get prefix => "";

  static String get features => "${prefix}features";

  static String get history => "${prefix}history";
}

class ConvertPageLocalization {
  static String get prefix => "";

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

  static String get canNotDownloadFile => "${prefix}can_not_download_file";

  static String get autoDownload => "${prefix}auto_download";

  static String get selectConvertType => "${prefix}select_convert_type";

  static String get applyAll => "${prefix}apply_all";
}

class CutterPageLocalization {
  static String get prefix => "";

  static String get startCut => "${prefix}start_cut";

  static String get removeSelection => "${prefix}remove_selection";

  static String get convertType => "${prefix}convert_type";

  static String get from => "${prefix}from";

  static String get to => "${prefix}to";
}

class MergerPageLocalization {
  static String get prefix => "";

  static String get converted => "${prefix}converted";

  static String get cancel => "${prefix}cancel";

  static String get startMerge => "${prefix}start_merge";

  static String get pleaseWait => "${prefix}please_wait";

  static String get completed => "${prefix}complete";

  static String get inProgressUpload => "${prefix}in_progress_upload";

  static String get inProgressConvert => "${prefix}in_progress_convert";

  static String get inProgressMerge => "${prefix}in_progress_merge";

  static String get inProgressDownload => "${prefix}in_progress_download";
}
