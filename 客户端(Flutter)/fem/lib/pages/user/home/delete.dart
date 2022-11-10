import 'package:fem/config/service_url.dart';

import 'package:fem/service/service_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

deleteThis(BuildContext context, int type, String id) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text("确定删除该设备？"),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("取消"),
          ),
          CupertinoDialogAction(
            child: Text("确定"),
            onPressed: () {
              if(type == 0) {
                 Navigator.of(context)..pop()..pop(id);
                _deleteElec(id);
              } else if(type == 1) {
                 Navigator.of(context)..pop()..pop(id);
                _deleteTemp(id);
              }
            },
          ),
        ],
      );
    }
    );
 
}

_deleteElec(String elecId) async{
  var formData = {
    'elecId': elecId
  };
  await request(servicePath['deleteElec'], parms: formData).then((val) {
    if(val == true) {
     
      Fluttertoast.showToast(
        msg: "删除成功",
        timeInSecForIos: 2
      );
    } else {
      Fluttertoast.showToast(
        msg: '删除失败',
        timeInSecForIos: 2
        );
    }
   
  });
}

_deleteTemp(String tempId) async{
  var formData = {
    'tempId': tempId
  };
  await request(servicePath['deleteTemp'], parms: formData).then((val) {
    if(val == true) {
      Fluttertoast.showToast(
        msg: "删除成功",
        timeInSecForIos: 2
      );
    } else {
      Fluttertoast.showToast(
        msg: '删除失败',
        timeInSecForIos: 2
        );
    }
   
  });
}

