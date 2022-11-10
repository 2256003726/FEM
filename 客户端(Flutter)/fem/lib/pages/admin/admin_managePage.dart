import 'package:fem/routes/application.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminManagePage extends StatefulWidget {
  @override
  _AdminManagePageState createState() => _AdminManagePageState();
}

class _AdminManagePageState extends State<AdminManagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Colors.blueGrey,
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            //infoCard(),
            passwordCard(context),
            logoutCard(context),
          ],
        ),
      ),
    );
  }
}

//修改密码
Widget passwordCard(BuildContext context) {
  return Card(
    color: Colors.black12,
    child: ListTile(
      trailing: Icon(Icons.arrow_forward),
      title: Text("修改密码", style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(30)),),
      onTap: () {
        Application.router.navigateTo(context, "/changePassword");
      },
    ),
  );
}

//退出登录
Widget logoutCard(BuildContext context) {
  return Container(
      padding: EdgeInsets.all(5),
      child: RaisedButton(
        padding: EdgeInsets.all(5),
        child: Text("退出登录", 
        style: TextStyle(fontSize: ScreenUtil().setSp(35),color: Colors.white),),
        color: Colors.red,
        
        onPressed: () {
          _logout(context);
        },
      ),
  );
}

_logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        
        return CupertinoAlertDialog(
            title: Text("即将退出"),
            content: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Align(
                  child: Text('是否退出？'),
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
                child: Text("确定退出"),
                onPressed: () async{
                SharedPreferences preferences = await SharedPreferences.getInstance();
                preferences.setString("password", null);
                JPush jpush = new JPush();
                jpush.setAlias('0').then((val) {
                  print('取消别名成功');
                });
                Application.router.navigateTo(context, "/logout");
                },
              ),
          ],
        );
      }
    );
  }