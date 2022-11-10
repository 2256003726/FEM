import 'package:fem/config/service_url.dart';
import 'package:fem/service/service_method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fem/provider/UserProvider.dart';
class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String pass = '';
  final _old = TextEditingController();      //旧密码
  final _new = TextEditingController();    //新密码1
  final _new2 = TextEditingController();    //新密码2
  GlobalKey _globalKey = new GlobalKey<FormState>();      //用于检查输入框是否为空
  SharedPreferences prefs;
  @override
  void initState() { 
    super.initState();
    _getPass();
  }
  _getPass() async{
    prefs = await SharedPreferences.getInstance();
    pass = prefs.get("password");
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("修改密码"),
        centerTitle: true,
      ),
      body: Container(
        child: Form(
          key: _globalKey,
          autovalidate: false, //自动校验
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _old,
                decoration: InputDecoration(
                    labelText: "旧密码",
                    hintText: "输入旧密码",
                    icon: Icon(Icons.person)),
                validator: (v) {
                  if(v.trim().length == 0) {
                    return "旧密码不能为空";
                  } else {
                    if(v != pass) {
                      return "旧密码不正确";
                    }
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _new,
                decoration: InputDecoration(
                  labelText: "新密码",
                  hintText: "输入你的新密码",
                  icon: Icon(Icons.lock),
                ),
                validator: (v) {
                  if(v.trim().length <= 5 ) {
                    return "密码不能低于6位";
                  } else {
                    if(v == _old.text) {
                      return "新旧密码不能相同";
                    }
                  }
                  return null;
                },
                obscureText: true,
              ),
              TextFormField(
                controller: _new2,
                decoration: InputDecoration(
                  labelText: "重复新密码",
                  hintText: "再次输入你的新密码",
                  icon: Icon(Icons.lock),
                ),
                validator: (v) {
                  if(v.trim().length <= 5 ) {
                    return "密码不能低于6位";
                  } else {
                    if(v != _new.text) {
                      return "两次新密码必须相同";
                    }
                  }
                  return null;
                },
                obscureText: true,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              SizedBox(
                width: 120.0,
                height: 50.0,
                child: RaisedButton(
                  onPressed: () {
                    if ((_globalKey.currentState as FormState).validate()) {
                     // _login();
                      _changePassword();
                    }
                  },
                  child: Text(
                    "确定",
                    style: TextStyle(color: Colors.white), //字体白色
                  ),
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _changePassword() async{
    var formData = {
      'userId': Provider.of<UserProvider>(context, listen: false).user.userId,
      'password': _new.text
    };
    await request(servicePath['alertPassword'], formData: formData).then((val) {
      if(val == true) {
        prefs.setString("password", _new.text);
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: "修改密码成功！",
          timeInSecForIos: 2,
        );    
      } else {
        Fluttertoast.showToast(
          msg: "修改密码失败！",
          timeInSecForIos: 2,
        );  
      }
    }); 
  }
}