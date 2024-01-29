import 'dart:async';
import 'dart:developer';

import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart';

const String convertSocketChannelUrl = "https://syt.cdndl.xyz";

class SocketChannel {
  final String url;
  late final Socket _socket;
  SocketChannel(this.url) {
    _socket = io(
      url,
      OptionBuilder().setTransports(['websocket']).disableAutoConnect().setTimeout(3000).build(),
    );
  }

  void startConnection() {
    _socket.connect();
  }

  void reconnect() {
    startConnection();
  }

  void close() {
    log("close connect to socket server");
    _socket.clearListeners();
    _socket.close();
  }

  String? get socketId => _getSocketId();

  String? _getSocketId() {
    if (_socket.disconnected) {
      return null;
    }
    return _socket.id;
  }

  void onDisconnected(Function(dynamic data) callBack) {
    _socket.onDisconnect((data) {
      log("socket io.onDisconnect: ${data}");
      callBack(data);
    });
  }

  void onConnected(Function(dynamic data) callBack) {
    _socket.onConnect((data) {
      log("socket io.onConnect: ${data}");
      callBack(data);
    });
  }

  void onClose(Function(dynamic data) callBack) {
    _socket.onclose((data) {
      log("socket io.onClose: ${data}");
      callBack(data);
    });
  }

  void clearListenersAndClose() {
    close();
  }
}

class ConvertChannel extends SocketChannel {
  ConvertChannel(super.url);

  void onConverting(Function(dynamic data) onListen) {
    _socket.on("converting", onListen);
  }
}

class MergerChannel extends ConvertChannel {
  MergerChannel(super.url);

  void onMerging(Function(dynamic data) onListen) {
    _socket.on("merging", onListen);
  }
}
//
// socket.onConnect((data) {
// print('socketok: ${data}');
// });
//
// socket.onError((data) {
// print('socketerror');
// print(data);
// });
//
// socket.on('connected', (data) => print("connected: ${data}"));
//
// socket.on("converting", (data) => print("connected: ${data}"));
