import 'package:mantarix/mantarix.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';

class WebviewWeb extends StatefulWidget {
  final Control control;
  final MantarixControlBackend backend;

  const WebviewWeb({super.key, required this.control, required this.backend});

  @override
  State<WebviewWeb> createState() => _WebviewWebState();
}

class _WebviewWebState extends State<WebviewWeb> {
  late PlatformWebViewController controller;
  @override
  void initState() {
    super.initState();
    WebViewPlatform.instance = WebWebViewPlatform();

    controller = PlatformWebViewController(
      const PlatformWebViewControllerCreationParams(),
    )..loadRequest(
        LoadRequestParams(
            uri: Uri.parse(
                widget.control.attrString("url", "https://mantarix.dev")!)),
      );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWebViewWidget(
      PlatformWebViewWidgetCreationParams(controller: controller),
    ).build(context);
  }
}
