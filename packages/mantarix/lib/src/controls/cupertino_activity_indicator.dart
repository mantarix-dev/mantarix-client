import 'package:flutter/cupertino.dart';

import '../mantarix_control_backend.dart';
import '../models/control.dart';
import 'create_control.dart';

class CupertinoActivityIndicatorControl extends StatelessWidget {
  final Control? parent;
  final Control control;
  final bool parentDisabled;
  final MantarixControlBackend backend;

  const CupertinoActivityIndicatorControl(
      {super.key,
      this.parent,
      required this.control,
      required this.parentDisabled,
      required this.backend});

  @override
  Widget build(BuildContext context) {
    debugPrint("CupertinoActivityIndicatorControl build: ${control.id}");

    return constrainedControl(
        context,
        CupertinoActivityIndicator(
          radius: control.attrDouble("radius", 10)!,
          animating: control.attrBool("animating", true)!,
          color: control.attrColor("color", context),
        ),
        parent,
        control);
  }
}
