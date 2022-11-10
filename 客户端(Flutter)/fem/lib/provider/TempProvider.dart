
import 'package:flutter/cupertino.dart';
import 'package:fem/model/Spot.dart';
import 'package:fem/model/Temperature.dart';
import 'package:fem/provider/SpotProvider.dart';
import 'package:provider/provider.dart';
import 'package:fem/config/service_url.dart';
import 'package:fem/service/service_method.dart';
class TempProvider with ChangeNotifier {

  int warnNum = 0;
  int earlyNum = 0;
  int commonNum = 0;
  int allNum = 0;

  setStateList(BuildContext context) async{
   await setList(context, '0').then((val) {
     if(val != null) {    
      this.commonNum = val['size'];   
     }
    });
   await setList(context, '1').then((val) {
     if(val != null) {   
     this.earlyNum = val['size'];
     }
    });
   await setList(context, '2').then((val) {
     if(val != null) {  
     this.warnNum = val['size'];
     }
    }); 
    this.allNum = commonNum + earlyNum + warnNum;
    notifyListeners();
  }

  Future setList(BuildContext context, String state) async{
    SpotModel spot = Provider.of<SpotProvider>(context, listen: false).selectedSpot;
    if(spot != null) {
      var formData = {
        'spotId': spot.spotId,
        'state': state,
        'curPage':'1',
        'size': '0',
        'name':''
      };
      return await request(servicePath['getTemp'], formData: formData);
    }
    else {
      warnNum = 0;
      earlyNum = 0;
      commonNum = 0;
      allNum = 0;
    }
    
  }
}