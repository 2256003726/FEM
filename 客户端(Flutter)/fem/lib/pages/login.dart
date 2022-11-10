
import 'package:fem/main.dart';
import 'package:fem/model/Spot.dart';
import 'package:fem/pages/user/search/dispose.dart';
import 'package:fem/provider/ElecProvider.dart';
import 'package:fem/provider/SpotProvider.dart';
import 'package:fem/provider/TempProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fem/provider/UserProvider.dart';
import '../service/service_method.dart';
import '../config/service_url.dart';
import '../routes/application.dart';
import 'package:provider/provider.dart';
import 'package:fem/config/demo.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userId = TextEditingController();      //用户id
  final _password = TextEditingController();    //密码
  final _servicePath = TextEditingController();     //服务器地址
  GlobalKey _globalKey = new GlobalKey<FormState>();      //用于检查输入框是否为空
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("欢迎登录"),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        
        child: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          autovalidate: false, //自动校验
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(10),),
              Card(
                child: Text("电气火灾预警系统",
                style: TextStyle(color: Colors.red, fontSize: ScreenUtil().setSp(40),fontStyle: FontStyle.normal,fontWeight: FontWeight.w700),
                ),
              ),
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
                  return v.trim().length > 0 ? null : "用户名不能为空";
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
                        _login();                    
                      }
                    },
                    child: Text(
                      "登录",
                      style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)), //字体白色
                    ),
                    color: Colors.blue,
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(45.0)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30.0),
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.white,
                      onPressed: () {
                        Application.router.navigateTo(context, "/forget");
                      },
                      child: Text('忘记密码', style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                    ),
                    RaisedButton(
                      color: Colors.white,
                      onPressed: () {
                        Application.router.navigateTo(context, "/register");
                      },
                      child: Text('注册账号', style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                    ),
                    // Text(serviceUrl),
                    // Text(test),
                    // Text(justTest),
                    // Text(just2)
                    
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30.0),
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: RaisedButton(
                  color: Colors.white,
                  onPressed: () {
                    callMe(context, '18052446780');
                  },
                  child: Text('联系客服', style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                ),
              )
              
              
            ],
          ),
        ),
      ),
      )
      
      
    );
  }

  //修改服务器地址
  _setService() {
    // justTest = '7777';
    serviceUrl = 'https://' + _servicePath.text+':8888/';
    //test = serviceUrl + 'test';
    servicePath = {
    //登录
    'login': serviceUrl + 'user/login',
    //根据userId获取spotList
    'getSpotList': serviceUrl + 'user/getSpotList',
    //修改密码
    'alertPassword': serviceUrl + 'user/alertPassword',
    //添加项目
    'addSpot': serviceUrl + 'user/addSpot',
    //修改项目
    'alertSpot': serviceUrl + 'user/alertSpot',
    //分配项目
    'alloSpot': serviceUrl + 'user/alloSpot',
    //移除项目
    'removeSpot': serviceUrl + 'user/removeSpot',
    //查找userList
    'getUsers': serviceUrl + 'user/getUsers',

    //根据spotId查找电流list
    'getElec': serviceUrl + 'elec/getElec',
    //根据elecId查找电流
    'getDetail': serviceUrl + 'elec/getDetail',
    //修改elec
    'updateElec': serviceUrl + 'elec/updateElec',
    //删除elec
    'deleteElec': serviceUrl + 'elec/deleteElec',
    //添加elec
    'addElec': serviceUrl + 'elec/addElec',

    'getTemp': serviceUrl + 'temp/getTemp',
    'getTempDetail': serviceUrl + 'temp/getDetail',
    'updateTemp': serviceUrl + 'temp/updateTemp',
    'deleteTemp': serviceUrl + 'temp/deleteTemp',
    'addTemp': serviceUrl + 'temp/addTemp',

    'getRecordElecList': serviceUrl + 'record/getElecList',
    'getRecordTempList': serviceUrl + 'record/getTempList',
    'disposeRecordElec': serviceUrl + 'record/disposeElec',
    'disposeRecordTemp': serviceUrl + 'record/disposeTemp',
    'deleteRecordElec': serviceUrl + 'record/deleteElec',
    'deleteRecordTemp': serviceUrl + 'record/deleteTemp',
    'getRecordOutline': serviceUrl + 'record/getOutline',
    'getReElecById': serviceUrl + 'record/getElecListById',
    'getReTempById': serviceUrl + 'record/getTempListById',
  };
    
  }
  //登录
  void _login() async{
    // print(a);
    // print(b);
    // a = 10;
    // print(a);
    // print(b);
    // b = a + 4;
    // print(b);
    _setService();
  
    var formData = {
      'userId': _userId.text,
      'password': _password.text
    };
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    await request(servicePath['login'], formData: formData).then((val) async{
      if(val == '' || val == null) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("用户名不存在或密码错误"),
            );
          }
          );
      } else if(val == 'flag') {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("服务器地址有误"),
              );
            }
          );
      }
      else {
        Fluttertoast.showToast(
          msg: "登录成功",
          timeInSecForIos: 2
        );
        
        await _saveLoginMsg();
        await prefs.setString('token', val['token']);
        Provider.of<UserProvider>(context, listen: false).setUser(val['user']);
        
        if(val['user']['userRole'] == '用户') {
          await _getSpotList();
          Application.router.navigateTo(context, "/userIndex?id=${val['user']['userId']}");
          await initJPush(val['user']['userId']);
        } else {
           Application.router.navigateTo(context, "/adminIndex?id=${val['user']['userId']}");
          await initJPush(val['user']['userId']);
        }

      }
    });
  }
  
  //获取spotlist
  Future _getSpotList() async {
    var formData = {
      'userId': Provider.of<UserProvider>(context, listen: false).user.userId
    };
   return await request(servicePath['getSpotList'], parms: formData).then((val) {
     if(val != null && val != '') {
       SpotListModel model = SpotListModel.fromJson(val);
       Provider.of<SpotProvider>(context, listen: false).setSpotList(model.data);
       //如果未选择地址
       if( Provider.of<SpotProvider>(context, listen: false).selectedSpot == null) {
         Provider.of<SpotProvider>(context, listen: false).setSelectedSpot(model.data[0].spotId);
         Provider.of<ElecProvider>(context, listen: false).setStateList(context);
         Provider.of<TempProvider>(context, listen: false).setStateList(context);
       }
     } else {
       Provider.of<SpotProvider>(context, listen: false).setSpotList([]);
       Provider.of<SpotProvider>(context, listen: false).selectedSpot = null;
       Provider.of<TempProvider>(context, listen: false).setStateList(context);
       Provider.of<ElecProvider>(context, listen: false).setStateList(context);
       print('没有spot');
     }
           
    });
  }
  // 保存账号密码
   _saveLoginMsg() async{
      SharedPreferences preferences=await SharedPreferences.getInstance();
      preferences.setString("userId", _userId.text);
      preferences.setString("password", _password.text);
      preferences.setString("service", _servicePath.text);
  }
  // 读取账号密码，并将值直接赋给账号框和密码框
  void _getLoginMsg()async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    _userId.text=preferences.get("userId");
    _password.text=preferences.get("password");
    _servicePath.text=preferences.get("service");
  }
   @override
  void initState(){
    super.initState();
    _getLoginMsg();
  
  }
}

//极光推送相关
  initJPush(String alias) async{
  if(alias == '') {
    print('卡了');
    await Future.delayed(Duration(seconds: 1));
  }
  JPush jpush = new JPush();
  //获取注册的id
  await jpush.getRegistrationID().then((rid) async{
    print("这是注册的id：$rid");
    //设置别名 实现指定用户推送
   await jpush.setAlias(alias).then((onValue) {
    print("设置别名成功");
  });
  });
  //初始化
  jpush.setup(
    appKey: "da37fa7a3226fc41171e4855",
    channel: "developer-default",
    production: false,
    debug: true,
  );
  
  
  
  

  try {
      
      //监听消息通知
      jpush.addEventHandler(
        // 接收通知回调方法。
        onReceiveNotification: (Map<String, dynamic> message) async {
          print("flutter onReceiveNotification: $message");
        },
        // 点击通知回调方法。
        onOpenNotification: (Map<String, dynamic> message) async {
          print("flutter onOpenNotification: $message");
        },
        // 接收自定义消息回调方法。
        onReceiveMessage: (Map<String, dynamic> message) async {
          print("flutter onReceiveMessage: $message");
        },
      );
    } catch (e) {
      print('极光sdk配置异常');
    }

}