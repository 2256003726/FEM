import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('关于我们'),
        centerTitle: true,
      ),
      body: Container(
        height: ScreenUtil().setHeight(1444),
        width: ScreenUtil().setWidth(750),
        color: Colors.black12,
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Image.asset('lib/images/gate.jpeg',height: ScreenUtil().setHeight(350),fit: BoxFit.fill,),
            Padding(padding: EdgeInsets.only(top:20),),
            Text('电气火灾预警系统', style: TextStyle(color: Colors.blue, fontSize: ScreenUtil().setSp(40)),),
            Padding(padding: EdgeInsets.only(top:20),),
            Text('学校:苏州科技大学', style: TextStyle(color: Colors.blue, fontSize: ScreenUtil().setSp(40)),),
            Padding(padding: EdgeInsets.only(top:20),),
            Text('作者:王金鹏', style: TextStyle(color: Colors.blue, fontSize: ScreenUtil().setSp(40)),),
            Padding(padding: EdgeInsets.only(top:20),),
            Text('QQ:2256003726', style: TextStyle(color: Colors.blue, fontSize: ScreenUtil().setSp(40)),),
          ],
        ),
      ),
    );
  }
}