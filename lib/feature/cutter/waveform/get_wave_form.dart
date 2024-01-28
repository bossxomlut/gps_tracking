import 'dart:io';

import 'package:just_waveform/just_waveform.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';

Future<Waveform> getWaveformFromFile(String fileName) async {
  final progressStream = BehaviorSubject<WaveformProgress>();
  final audioFile = File(fileName);
  try {
    final waveFile = File('${(await getTemporaryDirectory()).path}/waveform.wave');
    JustWaveform.extract(audioInFile: audioFile, waveOutFile: waveFile)
        .listen(progressStream.add, onError: progressStream.addError);
  } catch (e) {
    progressStream.addError(e);
  }

  await for (WaveformProgress value in progressStream) {
    if (value.waveform != null) {
      progressStream.close();
      return value.waveform!;
    }
  }
  throw Exception("Waveform progress");
}
