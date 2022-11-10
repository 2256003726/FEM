import 'package:flutter/cupertino.dart';

class ServiceProvider with ChangeNotifier {
  String serviceLocation = '';
  setService(String url) {
    this.serviceLocation = url;
    notifyListeners();
  }
}