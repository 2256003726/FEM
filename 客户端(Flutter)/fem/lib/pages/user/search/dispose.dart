
import 'package:fem/config/service_url.dart';
import 'package:fem/service/service_method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../provider/SpotProvider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fem/model/Spot.dart';
//已处理
dispose(int type, int id) async {
    //电流
    if(type == 0) {
      await request(servicePath['disposeRecordElec'], parms: {'reId': id}).then((val) {
        Fluttertoast.showToast(
          msg: "已处理",
          timeInSecForIos: 2
        );
      });
      //测温
    } else {
      await request(servicePath['disposeRecordTemp'], parms: {'reId': id}).then((val) {
        Fluttertoast.showToast(
          msg: "已处理",
          timeInSecForIos: 2
          );
      });
    }
}

delete(int type, int id) async {
  if(type == 0) {
      await request(servicePath['deleteRecordElec'], parms: {'reId': id}).then((val) {
        Fluttertoast.showToast(
          msg: "已删除",
          timeInSecForIos: 2
        );
      });
      //测温
    } else {
      await request(servicePath['deleteRecordTemp'], parms: {'reId': id}).then((val) {
        Fluttertoast.showToast(
          msg: "已删除",
          timeInSecForIos: 2
          );
      });
    }
}

//打开第三方高德地图
_toMap(BuildContext context, String detail) async{
  SpotModel spot = Provider.of<SpotProvider>(context, listen: false).selectedSpot;
  String spotUrl = spot.spotState + spot.spotCity + spot.spotCounty + spot.spotName + detail;
  String web = 'https://mobile.amap.com/#/';
  String url = 'androidamap://keywordNavi?sourceApplication=softname&keyword='+spotUrl+'&style=2';
  if(await canLaunch(url)) {
    await launch(url);
  } else {
    await launch(web);
  }
}

show(BuildContext context, String detail) {
  showDialog(context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text("将要打开高德地图，是否打开？"),
        actions: <Widget>[
          CupertinoDialogAction(
                child: Text("取消"),
                onPressed: () {
                  Navigator.pop(context);                 
                },
            ),
          CupertinoDialogAction(
            child: Text("确定"),
            onPressed: () {
              Navigator.pop(context);
              _toMap(context, detail);
            },
          )
        ],
      );
    }
  );
}

//打电话
void _call(String phone) async {
    String url = 'tel:'+phone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
callMe(BuildContext context, String phone) {
  showDialog(context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text("即将拨打"+phone+"，是否继续？"),
        actions: <Widget>[
          CupertinoDialogAction(
                child: Text("取消"),
                onPressed: () {
                  Navigator.pop(context);                 
                },
            ),
          CupertinoDialogAction(
            child: Text("确定"),
            onPressed: () {
              Navigator.pop(context);
              _call(phone);
            },
          )
        ],
      );
    }
  );
}