import 'package:flutter/foundation.dart';

class MantarixAppErrorsHandler extends ChangeNotifier {
  String? _error;
  String? get error => _error;
  void onError(String error) {
    _error = error;
    notifyListeners();
  }
}
