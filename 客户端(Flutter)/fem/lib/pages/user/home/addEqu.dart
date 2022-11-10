import 'package:fem/config/service_url.dart';
import 'package:fem/model/Electricity.dart';
import 'package:fem/model/Temperature.dart';
import 'package:fem/provider/ElecProvider.dart';
import 'package:fem/provider/SpotProvider.dart';
import 'package:fem/provider/TempProvider.dart';
import 'package:fem/service/service_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
class AddEqu extends StatefulWidget {
  final int type;
  AddEqu(this.type);
  @override
  _AddEquState createState() => _AddEquState();
}

class _AddEquState extends State<AddEqu> {
  TextEditingController _idController = TextEditingController();
  TextEditingController _linkmanController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _standardController = TextEditingController();
  TextEditingController _voltageController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _earlyController = TextEditingController();
  TextEditingController _warnController = TextEditingController();
  TextEditingController _detailController = TextEditingController();
  TextEditingController _currentController = TextEditingController();
  TextEditingController _textureController = TextEditingController();
  TextEditingController _sizeController = TextEditingController();
  TextEditingController _desController = TextEditingController();
  GlobalKey _globalKey = new GlobalKey<FormState>();      //用于检查输入框是否为空
   //点击空白收起键盘
  FocusNode blankNode = FocusNode();

  ElectricityModel elec = new ElectricityModel();
  TempModel temp = new TempModel();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("添加设备"),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          //点击取消键盘
          onTap: () {
            FocusScope.of(context).requestFocus(blankNode);
          },
          // //拖拽取消键盘
          // onVerticalDragEnd: (context1){
          //   FocusScope.of(context).requestFocus(blankNode);
          // },
          child: Form(
            autovalidate: true,
            key: _globalKey,
            child: addForm(),
          ),
        ),
      ),
    );
  }

  @override
  void initState() { 
    super.initState();
    _currentController.text = "0A-1600A";
    _voltageController.text = "<600V AC";
    _standardController.text = "GB14287-2014电气火灾监控系统";
    _sizeController.text = "90×49×32mm";
    _textureController.text = "ABS";
    _desController.text = "描述";
    if(widget.type == 0) {
      _earlyController.text = "200";
      _warnController.text = "400";
    } else if(widget.type == 1) {
      _earlyController.text = "60";
      _warnController.text = "120";
    }
  }
  Widget addForm() {
    
    

    return SingleChildScrollView(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(5.0),
          width: ScreenUtil().setWidth(1000),
          child: TextFormField(
            controller: _idController,
            validator: (v) {
              return v.trim().length > 0 ? null : "不能为空";
            },
            obscureText: false,           
            decoration: InputDecoration(              
              hintText: "输入ID",
              labelText: "设备ID",
              icon: Icon(Icons.android, color: Colors.green,),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5.0),
          width: ScreenUtil().setWidth(750),
          child: TextFormField(
            controller: _nameController,
            validator: (v) {
              return v.trim().length > 0 ? null : "不能为空";
            },
            obscureText: false,           
            decoration: InputDecoration(              
              hintText: "输入名称",
              labelText: "设备名称",
              icon: Icon(Icons.android, color: Colors.green,),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5.0),
          width: ScreenUtil().setWidth(750),
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
              icon: Icon(Icons.alarm,  color: Colors.orange,),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5.0),
          width: ScreenUtil().setWidth(750),
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
          width: ScreenUtil().setWidth(750),
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
        Container(
          padding: EdgeInsets.all(5.0),
          width: ScreenUtil().setWidth(750),
          child: TextFormField(
            controller: _linkmanController,
            validator: (v) {
              return v.trim().length > 0 ? null : "不能为空";
            },
            obscureText: false,
            decoration: InputDecoration(
              hintText: "输入联系人",
              labelText: "联系人员",
              icon: Icon(Icons.person, color: Colors.blue,),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5.0),
          width: ScreenUtil().setWidth(750),
          child: TextFormField(
            controller: _phoneController,
            validator: (v) {
              return v.trim().length > 0 ? null : "不能为空";
            },
            obscureText: false,
            decoration: InputDecoration(
              hintText: "输入联系电话",
              labelText: "联系电话",
              icon: Icon(Icons.phone, color: Colors.blue,),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5.0),
          width: ScreenUtil().setWidth(750),
          child: TextFormField(
            controller: _standardController,
            validator: (v) {
              return v.trim().length > 0 ? null : "不能为空";
            },
            obscureText: false,           
            decoration: InputDecoration(              
              hintText: "国家标准",
              labelText: "国家标准",
              icon: Icon(Icons.android, color: Colors.green,),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5.0),
          width: ScreenUtil().setWidth(750),
          child: TextFormField(
            controller: _textureController,
            validator: (v) {
              return v.trim().length > 0 ? null : "不能为空";
            },
            obscureText: false,           
            decoration: InputDecoration(              
              hintText: "材质",
              labelText: "设备材质",
              icon: Icon(Icons.android, color: Colors.green,),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5.0),
          width: ScreenUtil().setWidth(750),
          child: TextFormField(
            controller: _voltageController,
            validator: (v) {
              return v.trim().length > 0 ? null : "不能为空";
            },
            obscureText: false,           
            decoration: InputDecoration(              
              hintText: "电压",
              labelText: "工作电压",
              icon: Icon(Icons.android, color: Colors.green,),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5.0),
          width: ScreenUtil().setWidth(750),
          child: TextFormField(
            controller: _currentController,
            validator: (v) {
              return v.trim().length > 0 ? null : "不能为空";
            },
            obscureText: false,           
            decoration: InputDecoration(              
              hintText: "电流",
              labelText: "工作电流",
              icon: Icon(Icons.android, color: Colors.green,),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5.0),
          width: ScreenUtil().setWidth(750),
          child: TextFormField(
            controller: _sizeController,
            validator: (v) {
              return v.trim().length > 0 ? null : "不能为空";
            },
            obscureText: false,           
            decoration: InputDecoration(              
              hintText: "尺寸",
              labelText: "设备尺寸",
              icon: Icon(Icons.android, color: Colors.green,),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5.0),
          width: ScreenUtil().setWidth(750),
          child: TextFormField(
            controller: _desController,
            validator: (v) {
              return v.trim().length > 0 ? null : "不能为空";
            },
            obscureText: false,           
            decoration: InputDecoration(              
              hintText: "描述",
              labelText: "设备描述",
              icon: Icon(Icons.android, color: Colors.green,),
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
              if((_globalKey.currentState as FormState).validate()) {
                FocusScope.of(context).requestFocus(blankNode);
                _thisDialog();  
              }
             
             //myDialog(context, _earlyController.text, _warnController.text);
                            
            },
          ),
        ),
        ),
        Padding(padding: EdgeInsets.only(top:20),),
      ],
    )
    ); 
  }

  _thisDialog() {
    int e = int.parse(_earlyController.text);
    int w = int.parse(_warnController.text);
    if(widget.type == 0) {
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
      
      elec.elecDes = _desController.text;
      elec.elecEarly = e;
      elec.elecWarning = w;
      elec.elecCurrent = _currentController.text;
      elec.elecName = _nameController.text;
      elec.elecId = _idController.text;
      elec.elecStandard = _standardController.text;
      elec.elecSpotDetail = _detailController.text;
      elec.elecSize = _sizeController.text;
      elec.elecTexture = _textureController.text;
      elec.elecVoltage = _voltageController.text;
      elec.elecSetting = "20mA-1000mA";
      elec.foreSpotId = Provider.of<SpotProvider>(context, listen: false).selectedSpot.spotId;
      elec.elecLinkman = _linkmanController.text;
      elec.elecPhone = _phoneController.text;
      _addFun(elec, temp);
     }
    } else if(widget.type == 1) {
      if(e > 140 || e< 55) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("预警值设置不合法"),
            );
          }
          );
      } else if(w > 140 || w < e) {
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
      temp.foreSpotId = Provider.of<SpotProvider>(context, listen: false).selectedSpot.spotId;
      temp.tempCurrent = _currentController.text;
      temp.tempDes = _desController.text;
      temp.tempEarly = e;
      temp.tempWarning = w;
      temp.tempId = _idController.text;
      temp.tempName = _nameController.text;
      temp.tempSetting = "55℃-140℃";
      temp.tempSize = _sizeController.text;
      temp.tempSpotDetail = _detailController.text;
      temp.tempStandard = _standardController.text;
      temp.tempTexture = _textureController.text;
      temp.tempVoltage = _voltageController.text;    
      temp.tempLinkman = _linkmanController.text;
      temp.tempPhone = _phoneController.text;
      _addFun(elec, temp); 
    }      
    }
  }
  _addFun(ElectricityModel elec, TempModel temp) {
   
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text("确定添加新设备？"),
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
              if(widget.type == 0) {
                await request(servicePath['addElec'], formData: elec.toJson()).then((val) async{
                  if(val == true) {                    
                    Navigator.of(context)..pop()..pop('yes');    
                    
                    Fluttertoast.showToast(
                      msg: "添加设备成功！",
                      timeInSecForIos: 2,
                      textColor: Colors.green,
                      fontSize: ScreenUtil().setSp(40)
                      );                 
                     
                  } else {
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                      msg: "设备id已存在，添加失败！",
                      timeInSecForIos: 2,
                      gravity: ToastGravity.CENTER,
                      textColor: Colors.red,
                      fontSize: ScreenUtil().setSp(40)
                      ); 
                  }
                });
              } else {
                await request(servicePath['addTemp'], formData: temp.toJson()).then((val) {
                  if(val == true) {
                   
                    Navigator.of(context)..pop()..pop('yes');
                    Fluttertoast.showToast(
                      msg: "添加设备成功！",
                      timeInSecForIos: 2,
                      textColor: Colors.green,
                      fontSize: ScreenUtil().setSp(40)
                      );                   
                  } else {
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                      msg: "设备id已存在，添加失败！",
                      timeInSecForIos: 2,
                      gravity: ToastGravity.CENTER,
                      textColor: Colors.red,
                      fontSize: ScreenUtil().setSp(40)
                      ); 
                  }
                });
              }
              
            },
          )
        ],
      );
    }
  );
}
}








