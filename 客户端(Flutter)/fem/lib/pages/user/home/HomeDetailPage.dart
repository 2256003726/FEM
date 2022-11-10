import 'package:fem/pages/user/home/overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:fem/provider/ElecProvider.dart';
import 'package:fem/provider/TempProvider.dart';
class HomeDetailPage extends StatefulWidget {
  @override
  _HomeDetailPageState createState() => _HomeDetailPageState();
}

class _HomeDetailPageState extends State<HomeDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: EasyRefresh(
         header: ClassicalHeader(             
          refreshedText: "刷新完成",
          refreshingText: "刷新中",
          refreshText: "刷新",
          refreshReadyText: "上拉刷新"
        ),
        onRefresh: () async {               
          await Provider.of<ElecProvider>(context, listen: false).setStateList(context);
          await Provider.of<TempProvider>(context, listen: false).setStateList(context);
        },
        child: ListView(
          children: <Widget>[
            Text("剩余电流式监控器",
            style: TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(40)),textAlign: TextAlign.center,),   
            Over(0),
            Text("测温式监控器",
            style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(40)),textAlign: TextAlign.center),
            Over2(0),
          ],
        ),
      ),
    );
  }

}