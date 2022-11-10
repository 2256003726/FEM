
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class RecordProvider with ChangeNotifier {

  DateTime beginTime = DateTime.parse('1998-11-24 10:10:10');
  DateTime overTime = DateTime.now();
  
  setBeginTime(DateTime time) {
    this.beginTime = time;
    notifyListeners();
  }
  
  setOverTime(DateTime time) {
    this.overTime = time;
    notifyListeners();
  }
}