import 'package:dio/dio.dart';
import 'package:fem/config/service_url.dart';
import 'package:fem/model/Spot.dart';
import 'package:fem/routes/application.dart';
import 'package:fem/service/service_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AlloSpot extends StatefulWidget {
  final String userId;
  AlloSpot(this.userId);
  @override
  _AlloSpotState createState() => _AlloSpotState();
}

class _AlloSpotState extends State<AlloSpot> {
  List<SpotModel> list = List();
  final _spotController = TextEditingController();        //项目名称
  GlobalKey _globalKey = new GlobalKey<FormState>();      //用于检查输入框是否为空
  //点击空白收起键盘
  FocusNode blankNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("分配项目"),
        centerTitle: true,
      ),
      body: Container(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(blankNode);
          },
          child: Form(
            key: _globalKey,
            autovalidate: true,
            child: _edit()
          ),
        )
      ),
    );
  }
  @override
  void initState() { 
    super.initState();
    _getList();
  }
  //查找已存在的项目
  _getList() async{
    
    var formData = {
      'userId': widget.userId
    };
    await request(servicePath['getSpotList'], parms: formData).then((val) {
      if(val != null && val != '') {
        SpotListModel model = SpotListModel.fromJson(val);
        if(mounted) {
          setState(() {
            list = model.data;
          });
        }
      }
    });
    
  }
  //编辑处
  Widget _edit() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          //项目名称
          TextFormField(
            controller: _spotController,
            decoration: InputDecoration(
            labelText: "项目名称",
            hintText: "输入项目名",
            icon: Icon(Icons.near_me)),
            validator: (v) {
              return v.trim().length > 0 ? null : "项目名不能为空";
            },
          ),
          //确定添加按钮
          RaisedButton(
            child: Text("添加项目"),
            onPressed: () {
              if ((_globalKey.currentState as FormState).validate()) {
                _myDialog();
                
              } else {
                Fluttertoast.showToast(
                  gravity: ToastGravity.CENTER,
                  msg: "请填写完整"
                );
              }
            },
          ),
        ],
      ),
    );
  }
  _myDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("分配项目"),
          content: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Align(
                child: Text('确定分配？'),
                alignment: Alignment(0, 0),
              ),
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("取消"),
              onPressed: () {
                Navigator.pop(context);
                
              },
            ),
            CupertinoDialogAction(
              child: Text("确定"),
              onPressed: () async{
                int i = 0;
                if(list.length > 0) {
                  list.forEach((val) {
                    if(val.spotName == _spotController.text) {
                      Fluttertoast.showToast(msg: "不能分配该用户已有的项目");
                      i = 1;
                      Navigator.pop(context);
                    }
                  });
                }
                
                if(i == 0) {
                  var formData = {
                    'userId': widget.userId,
                    'spotName': _spotController.text,
                  };
                  await request(servicePath['alloSpot'], formData: formData).then((val) {
                  if(val == true) {
                    Navigator.of(context)..pop()..pop('yes');
                    Fluttertoast.showToast(
                      msg: "分配项目成功！",
                      gravity: ToastGravity.CENTER
                    );
                  } else {
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                      msg: "项目名有误！",
                      gravity: ToastGravity.CENTER
                    );
                  }
                });
                }

               
               
              },
            ),
          ],
        );
       
      }
    );
  }
}