import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'actions.dart';
import 'control_factory.dart';
import 'mantarix_app_errors_handler.dart';
import 'mantarix_server.dart';
import 'mantarix_server_protocol.dart';
import 'models/app_state.dart';
import 'reducers.dart';

class MantarixAppServices extends InheritedWidget {
  final MantarixAppServices? parentAppServices;
  final bool? hideLoadingPage;
  final String? controlId;
  final int? reconnectIntervalMs;
  final int? reconnectTimeoutMs;
  final String pageUrl;
  final String assetsDir;
  final MantarixAppErrorsHandler? errorsHandler;
  late final MantarixServer server;
  late final Store<AppState> store;
  final Map<String, GlobalKey> globalKeys = {};
  final Map<String, ControlInvokeMethodCallback> controlInvokeMethods = {};
  final List<CreateControlFactory> createControlFactories;

  MantarixAppServices(
      {super.key,
      required super.child,
      required this.pageUrl,
      required this.assetsDir,
      this.errorsHandler,
      this.parentAppServices,
      this.hideLoadingPage,
      this.controlId,
      this.reconnectIntervalMs,
      this.reconnectTimeoutMs,
      required this.createControlFactories}) {
    store = Store<AppState>(appReducer, initialState: AppState.initial());
    server = MantarixServer(store, controlInvokeMethods,
        reconnectIntervalMs: reconnectIntervalMs,
        reconnectTimeoutMs: reconnectTimeoutMs,
        errorsHandler: errorsHandler);
    if (errorsHandler != null) {
      if (controlId == null) {
        // root error handler
        errorsHandler!.addListener(() {
          if (store.state.isRegistered) {
            server.triggerControlEvent("page", "error", errorsHandler!.error!);
          }
        });
      } else if (controlId != null && parentAppServices != null) {
        // parent error handler
        errorsHandler?.addListener(() {
          parentAppServices?.server
              .triggerControlEvent(controlId!, "error", errorsHandler!.error!);
        });
      }
    }
    // connect to a page
    var pageUri = Uri.parse(pageUrl);
    store.dispatch(PageLoadAction(pageUri, assetsDir, server));
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  void close() {
    server.disconnect();
  }

  static MantarixAppServices? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MantarixAppServices>();

  static MantarixAppServices of(BuildContext context) => maybeOf(context)!;
}
