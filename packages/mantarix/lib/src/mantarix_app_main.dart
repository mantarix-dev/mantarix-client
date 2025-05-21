import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'controls/create_control.dart';
import 'mantarix_app_services.dart';
import 'models/app_state.dart';

class MantarixAppMain extends StatelessWidget {
  final String title;

  const MantarixAppMain({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: MantarixAppServices.of(context).store,
      child: createControl(null, "page", false),
    );
  }
}
