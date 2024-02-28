extension TimeFormat on Duration {
  String getMinuteFormat() {
    int sec = inSeconds % 60;
    int min = (inSeconds / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return '$minute’ $second‘’';
  }
}
