import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

const String downloaderSendPort = 'downloader_send_port';

@pragma('vm:entry-point')
void downloadCallback(String id, int status, int progress) {
  log(
    'Callback on background isolate: '
    'task ($id) is in status ($status) and process ($progress)',
  );

  IsolateNameServer.lookupPortByName(downloaderSendPort)?.send([id, status, progress]);
}

class DownloaderHelper {
  final ReceivePort _port = ReceivePort();
  late StreamSubscription streamSubscription;

  void startListen(Function(dynamic message) onData) async {
    final isRegisSuccess = IsolateNameServer.registerPortWithName(_port.sendPort, downloaderSendPort);

    if (isRegisSuccess) {
      IsolateNameServer.removePortNameMapping(downloaderSendPort);
      IsolateNameServer.registerPortWithName(_port.sendPort, downloaderSendPort);
    }

    streamSubscription = _port.listen(onData);
  }

  void dispose() {
    IsolateNameServer.removePortNameMapping(downloaderSendPort);
    streamSubscription.cancel();
    _port.close();
  }
}
