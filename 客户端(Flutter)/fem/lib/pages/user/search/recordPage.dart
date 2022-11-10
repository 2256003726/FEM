import 'package:fem/routes/application.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecordCard extends StatefulWidget {
  
  @override
  _RecordCardState createState() => _RecordCardState();
}

class _RecordCardState extends State<RecordCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          MyCard(context,0, "1"),
          MyCard(context,1, '1'),
          MyCard(context, 0, '0'),
          MyCard(context, 1, '0')
        ],
      ),
    );
  }
}

Widget MyCard(BuildContext context, int type, String state) {
  String text;
  TextStyle style;
  Icon icon;
  if(type == 0) {
    if(state == '0') {
      text = "已处理电流设备记录";
      style = TextStyle(color: Colors.green, fontSize: ScreenUtil().setSp(40));
      icon = Icon(Icons.access_alarm, color: Colors.green,size: 30 ,);
    } else {
      text = "电流设备报警记录";
      style = TextStyle(color: Colors.red, fontSize: ScreenUtil().setSp(40));
      icon = Icon(Icons.access_alarm, color: Colors.red,size: 30 ,);
    }
    
  } else if(type == 1) {
    if(state == '0') {
      text = '已处理测温设备记录';
      style = TextStyle(color: Colors.green, fontSize: ScreenUtil().setSp(40));
      icon = Icon(Icons.lightbulb_outline, color: Colors.green, size: 30,);
    } else {
      text = "测温设备报警记录";
      style = TextStyle(color: Colors.red, fontSize: ScreenUtil().setSp(40));
      icon = Icon(Icons.lightbulb_outline,color: Colors.red, size: 30,);
    }
    
  }
  return Container(
    width: ScreenUtil().setWidth(800),
    child: Card(
      child: ListTile(
      leading: icon,
      title: Text(text, style: style,),
      contentPadding: EdgeInsets.all(5),
      onTap: () {
        String t = type.toString();
        Application.router.navigateTo(context, "/recordList?type=$t&state=$state");
      },
    ),
    ),
  ); 
}
