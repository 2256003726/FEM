import 'dart:async';
import 'package:fem/model/Temperature.dart';
import 'package:fem/pages/user/home/delete.dart';
import 'package:fem/routes/application.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../config/service_url.dart';
import '../../../service/service_method.dart';
import 'package:fem/model/Spot.dart';
import 'package:fem/provider/SpotProvider.dart';
import '../../../provider/SpotProvider.dart';
import '../../../provider/UserProvider.dart';
import 'package:url_launcher/url_launcher.dart';
class TempDetail extends StatefulWidget {
  final String tempId;
  TempDetail(this.tempId);
  @override
  _TempDetailState createState() => _TempDetailState();
}

class _TempDetailState extends State<TempDetail> {
  TempModel temp;
 
  Timer _timer;
  int num;
  //获取设备详情数据
  _getDetail() async{
    var formData = {
      'tempId': widget.tempId
    };
    await request(servicePath['getTempDetail'], parms: formData).then((val) {
      setState(() {   
      temp = TempModel.fromJson(val); 
      });  
    });
  } 
  @override
  void initState() {  
     _getDetail();
    super.initState();
    _start();
  }
   @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  void _start() {
    //设置5秒执行一次
    const period = const Duration(seconds: 5);
    _timer = Timer.periodic(period, (time) async{
      var formData = {
      'tempId': widget.tempId
    };
    await request(servicePath['getTempDetail'], parms: formData).then((val) {
      if(mounted) {

      setState(() {      
      temp = TempModel.fromJson(val);
      });
      }
    });  
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text('设备详情'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: (){             
              Application.router.navigateTo(context, "/tempUpdate?tempId=${temp.tempId}");
            },
            )
        ],
      ),
      body: Container(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder:(context, index){
                return columnList(context, temp);
              } 
          )                         
      )  );
  }
  //列表内容
  Widget columnList(BuildContext context, TempModel temp) {
    if(temp != null) {
     
   
  Color c;
  if(temp.tempState=='0'){
    c = Colors.green;
  } else if(temp.tempState=='1') {
    c = Colors.orange;
  } else {
    c = Colors.red;
  }
  String state;
  if(temp.tempState == '0') {
    state = "正常";
  } else if(temp.tempState == '1') {
    state = "预警";
  } else {
    state = "报警";
  }
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(padding: EdgeInsets.all(10),color: Colors.black12,),
      Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(1000),
        child: Text(" 设备名称        " + temp.tempName??'', style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38), top: BorderSide(width: 1))),
      ),
      Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(1000),
        child: Text(" 设备编号        " + temp.tempId??'', style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(
        height: ScreenUtil().setHeight(70), 
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(750),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center ,
          children: <Widget>[
            Row(           
              children: <Widget>[
                Text(" 设备数值        ", style: TextStyle(fontSize: ScreenUtil().setSp(33))),
                Text(temp.tempVal!=null?temp.tempVal.toString() + " ℃":'0℃', style: TextStyle(color: c,fontSize: ScreenUtil().setSp(33))),
              ],
            ),
            Container(
              width: ScreenUtil().setWidth(200),
              alignment: Alignment.centerLeft,
              child:  IconButton(
              padding: EdgeInsets.only(right: 50),
              alignment: Alignment.centerRight,
              iconSize: 32,
              color: Colors.yellow,
              icon: Icon(Icons.show_chart,), 
              onPressed: () {             
                String type = '1';
                String id = widget.tempId;
                Application.router.navigateTo(context, "/lineChart?type=${type}&id=${id}");
              },
              autofocus: false,
              ),
            ),
          ],
        ),
        
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(1000),
        child: Row(
          children: <Widget>[
            Text(" 设备状态        ", style: TextStyle(fontSize: ScreenUtil().setSp(33))),
            Text(state, style: TextStyle(color: c,fontSize: ScreenUtil().setSp(33)))
          ],
        ),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(1000),
        child: Text(" 设备地址        " + Provider.of<SpotProvider>(context, listen: true).selectedSpot.spotName, 
                style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(
       height: ScreenUtil().setHeight(70),
        padding: EdgeInsets.only(left:5),
        width: ScreenUtil().setWidth(1000),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center ,          
          children: <Widget>[
             Container(
               width: ScreenUtil().setWidth(500),
               child: Text(" 安装地点        " + temp.tempSpotDetail??'',
              style: TextStyle(fontSize: ScreenUtil().setSp(33)),overflow: TextOverflow.ellipsis),),
            // Padding(padding: EdgeInsets.only(left: 50),),
             Container(
               width: ScreenUtil().setWidth(200),
               alignment: Alignment.centerLeft,
               child:  IconButton(
               padding: EdgeInsets.only(right: 50),
               alignment: Alignment.centerRight,
               iconSize: 32,
               color: Colors.blue,
               icon: Icon(Icons.near_me,), 
               onPressed: () {             
                 show(context,  temp.tempSpotDetail);
               },
             autofocus: false,
             ),
               ),
            
          ],
        ),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(1000),
        child: InkWell(
          child: Text(" 报警记录        ", style: TextStyle(fontSize: ScreenUtil().setSp(33),color: Colors.blue),),
          onTap: () {
            String t = '1';
            String a = temp.tempId;
            Application.router.navigateTo(context, "/recordById?type=$t&id=$a");
          },
        ),
        
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(1000),
        child: Text(" 预警数值        " + temp.tempEarly.toString() + " ℃", style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(1000),
        child: Text(" 报警数值        " + temp.tempWarning.toString() + " ℃", style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(1000),
        child: Text(" 设备材质        " + temp.tempTexture??'', style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(1000),
        child: Text(" 设备大小        " + temp.tempSize??'', style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(1000),
        child: Text(" 测量范围        " + temp.tempSetting??'', style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(1000),
        child: Text(" 执行标准        " + temp.tempStandard??'', style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(1000),
        child: Text(" 工作电压        " + temp.tempVoltage??'', style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(1000),
        child: Text(" 工作电流        " + temp.tempCurrent??'', style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(1000),
        child: Text(" 管理人员        " + Provider.of<UserProvider>(context, listen: true).user.userName,
             style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(1000),
        child: Text(" 设备描述        " + temp.tempDes??'', style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(
        padding: EdgeInsets.all(5),
        alignment: Alignment.center,
        child: RaisedButton(
          
          child: Text("删除", style: TextStyle(color: Colors.white),),
          color: Colors.red,
          onPressed: () {
            deleteThis(context, 1, temp.tempId);
          },
        ),
      )
    ],
  );
}  else {
       return Center(child: Text("加载中"),);
    }
}
}

 _toMap(BuildContext context, String detail) async{
  SpotModel spot = Provider.of<SpotProvider>(context, listen: false).selectedSpot;
  String spotUrl = spot.spotState + spot.spotCity + spot.spotCounty + spot.spotName + detail;
  String web = 'https://mobile.amap.com/#/';
  String url = 'androidamap://keywordNavi?sourceApplication=softname&keyword='+spotUrl+'&style=2';
  if(await canLaunch(url)) {
    await launch(url);
  } else {
    await launch(web);
  }
}

show(BuildContext context, String detail) {
  showDialog(context: context,
    builder: (BuildContext context) {
      
      return CupertinoAlertDialog(
        title: Text("将要打开高德地图，是否打开？"),
        actions: <Widget>[
          CupertinoDialogAction(
                child: Text("取消"),
                onPressed: () {
                  Navigator.pop(context);                 
                },
            ),
          CupertinoDialogAction(
            child: Text("确定"),
            onPressed: () {
              Navigator.pop(context);
              _toMap(context, detail);
            },
          )
        ],
      );
    }
  );
}