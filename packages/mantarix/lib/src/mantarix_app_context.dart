import 'package:flutter/material.dart';

class MantarixAppContext extends InheritedWidget {
  final ThemeMode? themeMode;

  const MantarixAppContext(
      {super.key, required this.themeMode, required super.child});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static MantarixAppContext? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MantarixAppContext>();
}
