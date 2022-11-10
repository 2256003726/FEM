
import 'package:fem/config/service_url.dart';
import 'package:fem/model/Electricity.dart';
import 'package:fem/service/service_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fluttertoast/fluttertoast.dart';

class UpdateElec extends StatefulWidget {
  final String elecId;
  UpdateElec(this.elecId);
  @override
  _UpdateElecState createState() => _UpdateElecState();
}

class _UpdateElecState extends State<UpdateElec> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _earlyController = TextEditingController();
  TextEditingController _warnController = TextEditingController();
  TextEditingController _detailController = TextEditingController();
  ElectricityModel myElec;
  ElectricityModel elce;
  GlobalKey _globalKey = new GlobalKey<FormState>();
  //点击空白收起键盘
  FocusNode blankNode = FocusNode();
  //获取设备信息
  _getInfo() async{
     var formData = {
      'elecId': widget.elecId
    };
    await request(servicePath['getDetail'], parms: formData).then((val) {
      setState(() {
        elce = ElectricityModel.fromJson(val);
        myElec = ElectricityModel.fromJson(val);
      });
    });
  }
  @override
  void initState() {
    _getInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lime,
        title: Text("修改信息"),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(blankNode);
          },
          child: Form(
            key: _globalKey,
            autovalidate: true,
            child: editWidget(elce,context),
          ),
        ), 
        
      ),
    );
  }
  Widget editWidget(ElectricityModel elec, BuildContext context) {
 
  
  if(elec == null) {
    return Center(child: Text("获取中"),);
  } else {
    if(_detailController.text=='' || _detailController.text==null) {

    _nameController.text = elec.elecName;
    _detailController.text = elec.elecSpotDetail;
    _warnController.text = elec.elecWarning.toString();
    _earlyController.text = elec.elecEarly.toString();
    }
    return SingleChildScrollView(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(5.0),
          width: ScreenUtil().setWidth(1000),
          child: TextFormField(
            controller: _nameController,
            validator: (v) {
              return v.trim().length > 0 ? null : "不能为空";
            },
            obscureText: false,           
            decoration: InputDecoration(              
              hintText: "输入名称",
              labelText: "设备名称",
              icon: Icon(Icons.android),
            ),
          ),
        ),
         Container(
          padding: EdgeInsets.all(5.0),
          width: ScreenUtil().setWidth(1000),
          child: TextFormField(
            controller: _earlyController,
            keyboardType: TextInputType.number,
            validator: (v) {
              return v.trim().length > 0 ? null : "不能为空";
            },
            obscureText: false,
            decoration: InputDecoration(
              hintText: "输入预警值",
              labelText: "预警值",
              icon: Icon(Icons.alarm, color: Colors.orange,),
            ),
          ),
        ),
         Container(
          padding: EdgeInsets.all(5.0),
          width: ScreenUtil().setWidth(1000),
          child: TextFormField(
            controller: _warnController,
            keyboardType: TextInputType.number,
            validator: (v) {
              return v.trim().length > 0 ? null : "不能为空";
            },
            obscureText: false,
            decoration: InputDecoration(
              hintText: "输入报警值",
              labelText: "报警值",
              icon: Icon(Icons.alarm,  color: Colors.red,),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5.0),
          width: ScreenUtil().setWidth(1000),
          child: TextFormField(
            controller: _detailController,
            validator: (v) {
              return v.trim().length > 0 ? null : "不能为空";
            },
            obscureText: false,
            decoration: InputDecoration(
              hintText: "输入详细地点",
              labelText: "安装地点",
              icon: Icon(Icons.near_me, color: Colors.blue,),
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(top:20),),

        Container(
          alignment: Alignment.center,
           child: SizedBox(
          width: 120.0,
          height: 50.0,
          child: RaisedButton(
            child: Text("确定",style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(40)), ),
            color: Colors.blue,
            onPressed: () {
             FocusScope.of(context).requestFocus(blankNode);
             myDialog(context, _earlyController.text, _warnController.text);
                            
            },
          ),
        ),
        ),
       
      ],
    )
    );
    
  }
  
}
myDialog(BuildContext context, String early, String warning) {
  int e = int.parse(early);
  int w = int.parse(warning);
  if(e > 2000 || e< 20) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("预警值设置不合法"),
        );
      }
      );
  } else if(w > 2000 || w < e) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("报警值设置不合法"),
        );
      }
      );
  } else {
    myElec.elecEarly = e;
    myElec.elecWarning = w;
    myElec.elecName = _nameController.text;
    myElec.elecSpotDetail = _detailController.text;
     showDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
            title: Text("编辑完成"),
            content: Column(
              
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Align(
                  child: Text('确定修改？'),
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
        
                  await request(servicePath['updateElec'], formData: myElec.toJson()).then((val) {
                    if(val == true) {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        barrierDismissible: true,                        
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Icon(Icons.tag_faces, color: Colors.green,),
                                Padding(padding: EdgeInsets.only(right: 5),),
                                Text("修改成功！")
                              ],
                            )
                          );
                        },
                        );
                    } else {
                      Fluttertoast.showToast(
                        msg: "修改成功",
                        timeInSecForIos: 3,

                        );
                    }
                  });
                },
              ),
            ],
          );

    }
    );
  }
 
}
}

