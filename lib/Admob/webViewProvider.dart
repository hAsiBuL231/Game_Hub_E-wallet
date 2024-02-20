import 'package:flutter/foundation.dart';

class WebViewProvider with ChangeNotifier {
  double _progress = 0;

  double get progress => _progress;

  void setValue(double progress) {
    _progress = progress;
    notifyListeners();
  }
}
