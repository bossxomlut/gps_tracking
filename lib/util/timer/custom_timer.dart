class CustomTimer {
  final _stopwatch = Stopwatch();
  final int step;

  CustomTimer({this.step = 1000}) {
    _stream = Stream.periodic(Duration(milliseconds: step), (_) {
      return _stopwatch.elapsed;
    });
  }

  late final Stream<Duration> _stream;

  Stream<Duration> get stream => _stream;

  void start() {
    if (!isRunning) {
      _stopwatch.start();
    }
  }

  void stop() {
    if (isRunning) {
      _stopwatch.stop();
    }
  }

  void reset() {
    _stopwatch.reset();
  }

  void cancel() {
    stop();
  }

  bool get isRunning => _stopwatch.isRunning;

  Duration get currentTime => _stopwatch.elapsed;
}

extension TimeFormat on Duration {
  String getMinuteFormat() {
    int sec = inSeconds % 60;
    int min = (inSeconds / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return '$minute’ $second‘’';
  }
}