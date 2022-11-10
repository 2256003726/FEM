import 'package:city_pickers/city_pickers.dart';
import 'package:fem/config/service_url.dart';
import 'package:fem/service/service_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:fem/provider/UserProvider.dart';

//使用地区选择器
Result resultArr = new Result();
class AddSpotPage extends StatefulWidget {
  @override
  _AddSpotPageState createState() => _AddSpotPageState();
}

class _AddSpotPageState extends State<AddSpotPage> {
  final _spotController = TextEditingController();        //项目名称
  final _provinceController = TextEditingController();    //省名
  final _cityController = TextEditingController();        //市名
  final _areaController = TextEditingController();        //县区名
  GlobalKey _globalKey = new GlobalKey<FormState>();      //用于检查输入框是否为空
  //点击空白收起键盘
  FocusNode blankNode = FocusNode();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("添加项目"),
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
        ), 
        
      ),
    );
  }
  
  //编辑部分
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
          Padding(padding: EdgeInsets.only(top:10),),
          //省市区选择按钮
          RaisedButton(
            child: Text("选择省市区"),
            onPressed: () {
              _clickEventFunc(context);
            },
          ),
          //省
          TextFormField(
            controller: _provinceController,
            decoration: InputDecoration(
            labelText: "省名",
            icon: Icon(Icons.near_me)),
            enabled: false,
            validator: (v) {
              return v.trim().length > 0 ? null : "省名不能为空";
            },
          ),
          //市
          TextFormField(
            controller: _cityController,
            decoration: InputDecoration(
            labelText: "市名",
            icon: Icon(Icons.near_me)),
            enabled: false,
            validator: (v) {
              return v.trim().length > 0 ? null : "市名不能为空";
            },
          ),
          //县/区
          TextFormField(
            controller: _areaController,
            decoration: InputDecoration(
            labelText: "县/区名",
            icon: Icon(Icons.near_me)),
            enabled: false,
            validator: (v) {
              return v.trim().length > 0 ? null : "县区名不能为空";
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
      )
    );
  }

  //添加提示框
  _myDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("添加项目"),
          content: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Align(
                child: Text('确定添加？'),
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
                var formData = {
                  'userId': Provider.of<UserProvider>(context, listen: false).user.userId,
                  'spotName': _spotController.text,
                  'spotProvince': _provinceController.text,
                  'spotCity': _cityController.text,
                  'spotArea': _areaController.text
                };
                await request(servicePath['addSpot'], formData: formData).then((val) {
                  if(val == true) {
                    Navigator.of(context)..pop()..pop('yes');
                    Fluttertoast.showToast(
                      msg: "添加项目成功！",
                      gravity: ToastGravity.CENTER
                    );
                  } else {
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                      msg: "项目名不能重复！",
                      gravity: ToastGravity.CENTER
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
  //地区选择器---IOS风格
  void _clickEventFunc(BuildContext context) async {
    
    Result tempResult = await CityPickers.showCityPicker(
      context: context,
      theme: Theme.of(context).copyWith(primaryColor: Color(0xfffe1314)), // 设置主题
      locationCode: resultArr != null ? resultArr.areaId ?? resultArr.cityId ?? resultArr.provinceId : null, // 初始化地址信息
      cancelWidget: Text(
        '取消',
        style: TextStyle(fontSize: ScreenUtil().setSp(26),color: Color(0xff999999)),
      ),
      confirmWidget: Text(
        '确定',
        style: TextStyle(fontSize: ScreenUtil().setSp(26),color: Color(0xfffe1314)),
      ),
      height: 330.0,
      
    );
    if(tempResult != null){
      if(mounted) {
        setState(() {
          resultArr = tempResult;
          _provinceController.text = resultArr.provinceName;
          _cityController.text = resultArr.cityName;
          _areaController.text = resultArr.areaName;
        });
      }
    }
  }
  
}