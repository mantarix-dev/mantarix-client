@JS()
library script.js;

import 'dart:js_util';

import 'package:flutter/foundation.dart';
import 'package:js/js.dart';

import 'mantarix_server_protocol.dart';

@JS()
external dynamic jsConnect(MantarixServerProtocolOnMessageCallback onMessage);

@JS()
external dynamic jsSend(String data);

class MantarixJavaScriptServerProtocol implements MantarixServerProtocol {
  final String address;
  final MantarixServerProtocolOnMessageCallback onMessage;
  final MantarixServerProtocolOnDisconnectCallback onDisconnect;

  MantarixJavaScriptServerProtocol(
      {required this.address,
      required this.onDisconnect,
      required this.onMessage});

  @override
  connect() async {
    debugPrint("Connecting to JavaScript server $address...");
    await promiseToFuture(jsConnect(allowInterop(onMessage)));
  }

  @override
  bool get isLocalConnection => true;

  @override
  int get defaultReconnectIntervalMs => 10;

  @override
  void send(String message) {
    jsSend(message);
  }

  @override
  void disconnect() {}
}
