import 'package:flutter/material.dart';

import '../mantarix_app.dart';
import '../mantarix_app_errors_handler.dart';
import '../mantarix_app_services.dart';
import '../models/control.dart';
import 'create_control.dart';

class MantarixAppControl extends StatefulWidget {
  final Control? parent;
  final Control control;

  const MantarixAppControl(
      {super.key, required this.parent, required this.control});

  @override
  State<MantarixAppControl> createState() => _MantarixAppControlState();
}

class _MantarixAppControlState extends State<MantarixAppControl> {
  final _errorsHandler = MantarixAppErrorsHandler();

  @override
  Widget build(BuildContext context) {
    debugPrint("MantarixApp build: ${widget.control.id}");

    var url = widget.control.attrString("url", "")!;
    var reconnectIntervalMs = widget.control.attrInt("reconnectIntervalMs");
    var reconnectTimeoutMs = widget.control.attrInt("reconnectTimeoutMs");

    return constrainedControl(
        context,
        MantarixApp(
          controlId: widget.control.id,
          reconnectIntervalMs: reconnectIntervalMs,
          reconnectTimeoutMs: reconnectTimeoutMs,
          pageUrl: url,
          assetsDir: "",
          errorsHandler: _errorsHandler,
          createControlFactories:
              MantarixAppServices.of(context).createControlFactories,
        ),
        widget.parent,
        widget.control);
  }
}
