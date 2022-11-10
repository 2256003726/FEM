import 'package:fem/model/Spot.dart';
import 'package:flutter/cupertino.dart';

class SpotProvider with ChangeNotifier {
  //spot列表
  List<SpotModel> spotList = [];
  //选择的spot
  SpotModel selectedSpot;
  String local = '';
  setSpotList(List<SpotModel> list) {
    this.spotList = list;
    //this.selectedSpot = list[0];   
    notifyListeners();
  }

  setSelectedSpot(int spotId) {
    spotList.forEach((val) {
      if(val.spotId == spotId) {
        this.selectedSpot = val;
        this.local = val.spotState+val.spotCity+val.spotCounty+val.spotName;
      }
    });
    
    notifyListeners();
  
  }
}