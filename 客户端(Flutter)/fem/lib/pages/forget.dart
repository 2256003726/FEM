import 'package:fem/service/service_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgetPage extends StatefulWidget {
  @override
  _ForgetPageState createState() => _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> {
  final _userId = TextEditingController();    //用户名
  final _phone = TextEditingController();    //电话
  final _servicePath = TextEditingController();    //电话
  GlobalKey _globalKey = new GlobalKey<FormState>();    //用于检查输入框是否为空
  String password = '';
  void initState() {
    _getService();
    super.initState();
  }  
  //读取服务器地址
  _getService() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    _servicePath.text=preferences.get("service");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("忘记密码"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: _globalKey,
            autovalidate: false,
            child: Column(
              children: <Widget>[
                TextFormField(
                controller: _servicePath,
                decoration: InputDecoration(
                    labelText: "服务器地址",
                    hintText: "输入服务器地址",
                    icon: Icon(Icons.local_laundry_service)),
                validator: (v) {
                  return v.trim().length > 0 ? null : "服务器地址不能为空";
                },
              ),
                TextFormField(
                  controller: _userId,
                  decoration: InputDecoration(
                      labelText: "账号",
                      hintText: "输入你的账号",
                      icon: Icon(Icons.person)),
                  validator: (v) {
                    return v.trim().length > 0 ? null : "账号不能为空";
                  },
                ),
                TextFormField(
                  controller: _phone,
                  decoration: InputDecoration(
                      labelText: "电话",
                      hintText: "输入你的电话",
                      icon: Icon(Icons.phone)),
                  validator: (v) {
                    return v.trim().length > 0 ? null : "电话不能为空";
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                Container(
                  height: ScreenUtil().setHeight(130),
                  padding: EdgeInsets.only(top: 20),
                  child: SizedBox(      
                    width: ScreenUtil().setWidth(600),     
                    child: RaisedButton(
                      onPressed: () {
                        if ((_globalKey.currentState as FormState).validate()) {
                          _retrieve();                    
                        }
                      },
                      child: Text(
                        "找回密码",
                        style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)), //字体白色
                      ),
                      color: Colors.blue,
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(45.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                Container(
                  alignment: Alignment.center,
                  height: ScreenUtil().setHeight(130),
                  padding: EdgeInsets.only(top: 20),
                  
                  child: Text(
                    password,
                    style: TextStyle(color: Colors.red,fontSize: ScreenUtil().setSp(30)), //字体白色
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  _retrieve() async{
    var formData = {
      'userId': _userId.text,
      'phone': _phone.text,
    };
    String url = 'https://' + _servicePath.text+':8888/user/forget';
    await request(url, formData: formData).then((val) {
      if(val != null) {
        print(val);
        if(mounted) {
          setState(() {
            password = '您的密码:  '+val;
          });
        }
      } else {
        Fluttertoast.showToast(
          msg: "账号或电话错误"
        );
      }
    });
  }
}