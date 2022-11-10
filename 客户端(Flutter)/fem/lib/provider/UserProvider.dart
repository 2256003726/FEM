import 'package:flutter/cupertino.dart';
import '../model/User.dart';

class UserProvider with ChangeNotifier {
  UserModel user;
  setUser(dynamic json) {
    this.user = UserModel.fromJson(json); 
    notifyListeners();
  }
  
}