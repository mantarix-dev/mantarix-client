import 'mantarix_server_protocol_javascript_io.dart'
    if (dart.library.js) "mantarix_server_protocol_javascript_web.dart";
import 'mantarix_server_protocol_tcp_socket.dart';
import 'mantarix_server_protocol_web_socket.dart';
import 'utils/platform_utils_non_web.dart'
    if (dart.library.js) "utils/platform_utils_web.dart";

typedef MantarixServerProtocolOnDisconnectCallback = void Function();
typedef MantarixServerProtocolOnMessageCallback = void Function(String message);
typedef ControlInvokeMethodCallback = Future<String?> Function(
    String methodName, Map<String, String> args);

abstract class MantarixServerProtocol {
  factory MantarixServerProtocol(
      {required String address,
      required MantarixServerProtocolOnDisconnectCallback onDisconnect,
      required MantarixServerProtocolOnMessageCallback onMessage}) {
    if (isMantarixWebPyodideMode()) {
      // JavaScript
      return MantarixJavaScriptServerProtocol(
          address: address, onDisconnect: onDisconnect, onMessage: onMessage);
    } else if (address.startsWith("http://") ||
        address.startsWith("https://")) {
      // WebSocket
      return MantarixWebSocketServerProtocol(
          address: address, onDisconnect: onDisconnect, onMessage: onMessage);
    } else {
      // TCP or UDS
      return MantarixTcpSocketServerProtocol(
          address: address, onDisconnect: onDisconnect, onMessage: onMessage);
    }
  }

  Future connect();
  bool get isLocalConnection;
  int get defaultReconnectIntervalMs;
  void send(String message);
  void disconnect();
}
