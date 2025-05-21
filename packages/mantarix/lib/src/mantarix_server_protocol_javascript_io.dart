import 'mantarix_server_protocol.dart';

class MantarixJavaScriptServerProtocol implements MantarixServerProtocol {
  final String address;
  final MantarixServerProtocolOnMessageCallback onMessage;
  final MantarixServerProtocolOnDisconnectCallback onDisconnect;

  MantarixJavaScriptServerProtocol(
      {required this.address,
      required this.onDisconnect,
      required this.onMessage});

  @override
  connect() async {}

  @override
  bool get isLocalConnection => true;

  @override
  int get defaultReconnectIntervalMs => 10;

  @override
  void send(String message) {}

  @override
  void disconnect() {}
}
