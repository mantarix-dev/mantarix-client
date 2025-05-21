import 'package:flutter/material.dart';

import 'control_factory.dart';
import 'mantarix_app_errors_handler.dart';
import 'mantarix_app_main.dart';
import 'mantarix_app_services.dart';

class MantarixApp extends StatefulWidget {
  final String pageUrl;
  final String assetsDir;
  final bool? hideLoadingPage;
  final String? controlId;
  final String? title;
  final MantarixAppErrorsHandler? errorsHandler;
  final int? reconnectIntervalMs;
  final int? reconnectTimeoutMs;
  final List<CreateControlFactory>? createControlFactories;

  const MantarixApp(
      {super.key,
      required this.pageUrl,
      required this.assetsDir,
      this.hideLoadingPage,
      this.controlId,
      this.title,
      this.errorsHandler,
      this.reconnectIntervalMs,
      this.reconnectTimeoutMs,
      this.createControlFactories});

  @override
  State<MantarixApp> createState() => _MantarixAppState();
}

class _MantarixAppState extends State<MantarixApp> {
  String? _pageUrl;
  MantarixAppServices? _appServices;

  @override
  void deactivate() {
    _appServices?.close();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pageUrl != _pageUrl) {
      _pageUrl = widget.pageUrl;
      _appServices = MantarixAppServices(
          parentAppServices: MantarixAppServices.maybeOf(context),
          hideLoadingPage: widget.hideLoadingPage,
          controlId: widget.controlId,
          reconnectIntervalMs: widget.reconnectIntervalMs,
          reconnectTimeoutMs: widget.reconnectTimeoutMs,
          pageUrl: widget.pageUrl,
          assetsDir: widget.assetsDir,
          errorsHandler: widget.errorsHandler,
          createControlFactories: widget.createControlFactories ?? [],
          child: MantarixAppMain(title: widget.title ?? "Mantarix"));
    }
    return _appServices!;
  }
}
