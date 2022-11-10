import 'package:fem/service/service_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _servicePath = TextEditingController();      //服务器地址
  final _userId = TextEditingController();      //用户id
  final _password = TextEditingController();    //密码
  final _confirm = TextEditingController();    //密码
  final _username = TextEditingController();    //用户名
  final _phone = TextEditingController();    //电话
  GlobalKey _globalKey = new GlobalKey<FormState>();    //用于检查输入框是否为空
  @override
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
        title: Text("注册用户"),
        centerTitle: true,
      ),
      body: Container(
        
        alignment: Alignment.center,
        child: SingleChildScrollView(
          
          child: Form(
            autovalidate: false,
            key: _globalKey,
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
                  controller: _username,
                  decoration: InputDecoration(
                      labelText: "用户名",
                      hintText: "输入你的用户名",
                      icon: Icon(Icons.person)),
                  validator: (v) {
                    return v.trim().length > 0 ? null : "用户名不能为空";
                  },
                ),
                TextFormField(
                  controller: _phone,
                  decoration: InputDecoration(
                      labelText: "手机号",
                      hintText: "输入你的手机号",
                      icon: Icon(Icons.phone)),
                  validator: (v) {
                    return v.trim().length > 0 ? null : "手机号不能为空";
                  },
                ),
                TextFormField(
                  controller: _password,
                  decoration: InputDecoration(
                    labelText: "密码",
                    hintText: "输入你的密码",
                    icon: Icon(Icons.lock),
                  ),
                  validator: (v) {
                    return v.trim().length > 5 ? null : "密码不低于6位";
                  },
                  obscureText: true,
                ),
                TextFormField(
                  autovalidate: false,
                  controller: _confirm,
                  decoration: InputDecoration(
                    labelText: "确认密码",
                    hintText: "输入你的密码",
                    icon: Icon(Icons.lock),
                  ),
                  validator: (v) {
                    if(v == _password.text) {
                      return null;
                    } else {
                      return "密码不一致";
                    }
                    
                  },
                  obscureText: true,
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
                          _register();                    
                        }
                      },
                      child: Text(
                        "注册",
                        style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)), //字体白色
                      ),
                      color: Colors.blue,
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(45.0)),
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
  _register() async{
    
    var formData = {
      'userId': _userId.text,
      'username': _username.text,
      'password': _password.text,
      'phone': _phone.text
    };
    String url = 'https://' + _servicePath.text+':8888/user/register';
    await request(url, formData: formData).then((val) async{
      if(val == true) {
        SharedPreferences preferences= await SharedPreferences.getInstance();
        preferences.setString("service", _servicePath.text);
        Fluttertoast.showToast(
          msg: "注册成功！",
        );
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: "注册失败！",
        );
      }
    });
  }

}