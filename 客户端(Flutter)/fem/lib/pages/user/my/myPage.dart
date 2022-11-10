import 'package:fem/pages/user/search/dispose.dart';
import 'package:fem/routes/application.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String  _scanResultStr = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("我的"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.scanner),
            onPressed: () {
             //_scan();
            },
            )
        ],
      ),
      body: Container(
        color: Colors.blueGrey,
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            //infoCard(),
            spotCard(context),
            passwordCard(context),
            aboutCard(context),
            phoneCard(context),
            Text(_scanResultStr),
            logoutCard(context),
          ],
        ),
      ),
    );
  }

  //扫码
// Future _scan() async {
//   //利用try-catch来进行异常处理
//   try {
//     //调起摄像头开始扫码
//     String barcode = await BarcodeScanner.scan();
    
//     setState(() {
//       return this._scanResultStr = barcode;
//     });
//   } on PlatformException catch (e) {
//     //如果没有调用摄像头的权限，则提醒
//     if (e.code == BarcodeScanner.CameraAccessDenied) {
//       setState(() {
//         return this._scanResultStr =
//             'The user did not grant the camera permission!';
//       });
//     } else {
//       setState(() {
//         return this._scanResultStr = 'Unknown error: $e';
//       });
//     }
//   } on FormatException {
//     setState(() => this._scanResultStr =
//         'null (User returned using the "back"-button before scanning anything. Result)');
//   } catch (e) {
//     setState(() => this._scanResultStr = 'Unknown error: $e');
//   }
// }
}

Widget infoCard() {
  return Card(
    color: Colors.black12,
    child: ListTile(
      trailing: Icon(Icons.arrow_forward),
      title: Text("基本信息", style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(30)),),
      onTap: () {},
    ),
  );
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

Widget spotCard(BuildContext context) {
  return Card(
    color: Colors.black12,
    child: ListTile(
      trailing: Icon(Icons.arrow_forward),
      title: Text("项目管理", style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(30)),),
      onTap: () {
        Application.router.navigateTo(context, "/spot");
      },
    ),
  );
}

Widget aboutCard(BuildContext context) {
  return Card(
    color: Colors.black12,
    child: ListTile(
      trailing: Icon(Icons.arrow_forward),
      title: Text("关于我们", style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(30)),),
      onTap: () {
        Application.router.navigateTo(context, "/about");
      },
    ),
  );
}

//服务热线
Widget phoneCard(BuildContext context) {
  return Card(
    color: Colors.black12,
    child: ListTile(
      trailing: Text("18052446780", style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(30)),),
      title: Text("服务热线", style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(30)),),
      onTap: () {
        callMe(context, '18052446780');
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
                  child: Text('退出后您将无法接收到报警提示！'),
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