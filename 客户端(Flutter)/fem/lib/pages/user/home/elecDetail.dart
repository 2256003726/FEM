import 'dart:async';
import 'package:fem/model/Spot.dart';
import 'package:fem/pages/user/home/delete.dart';
import 'package:fem/routes/application.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../config/service_url.dart';
import '../../../service/service_method.dart';
import '../../../model/Electricity.dart';
import '../../../provider/SpotProvider.dart';
import '../../../provider/UserProvider.dart';
import 'package:url_launcher/url_launcher.dart';
class ElecDetail extends StatefulWidget {
  final String elecId;
  ElecDetail(this.elecId);
  @override
  _ElecDetailState createState() => _ElecDetailState();
}

class _ElecDetailState extends State<ElecDetail> {
  TabController _tabController;
  ElectricityModel elec;
  Timer _timer;
  int num;
  //获取设备详情数据
  _getDetail() async{
    var formData = {
      'elecId': widget.elecId
    };
    await request(servicePath['getDetail'], parms: formData).then((val) {
      setState(() {   
      elec = ElectricityModel.fromJson(val); 
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
      'elecId': widget.elecId
    };
    await request(servicePath['getDetail'], parms: formData).then((val) {
      if(mounted) {
        setState(() {      
          elec = ElectricityModel.fromJson(val);
        });
      }
    });  
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      appBar: AppBar(
        title: Text('设备详情'),
        backgroundColor: Colors.green,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: (){
             
              Application.router.navigateTo(context, "/elecUpdate?elecId=${elec.elecId}");
            },
            )
        ],

      ),
      
      body: Container(

            child: ListView.builder(
              
              itemCount: 1,
              itemBuilder:(context, index){
                return Card(
                  child: columnList(context, elec)
                );
                
              } 
          )                         
      )  );
  }
  //列表内容
  Widget columnList(BuildContext context, ElectricityModel elec) {
    if(elec != null) {
  Color c;
  if(elec.elecState=='0'){
    c = Colors.green;
  } else if(elec.elecState=='1') {
    c = Colors.orange;
  } else {
    c = Colors.red;
  }
  String state;
  if(elec.elecState == '0') {
    state = "正常";
  } else if(elec.elecState == '1') {
    state = "预警";
  } else {
    state = "报警";
  }
  return Column(
    
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      //Container(padding: EdgeInsets.all(10),color: Colors.black12,),
      Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(750),
        child: Text(" 设备名称        " + elec.elecName??'', style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38), top: BorderSide(width: 1))),
      ),
      Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(750),
        child: Text(" 设备编号        " + elec.elecId??'', style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
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
                Text(elec.elecValue!=null?elec.elecValue.toString() + " mA":'0mA', style: TextStyle(color: c,fontSize: ScreenUtil().setSp(33))),
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
                String type = '0';
                String id = widget.elecId;
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
        width: ScreenUtil().setWidth(750),
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
        width: ScreenUtil().setWidth(750),
        child: Text(" 设备地址        " + Provider.of<SpotProvider>(context, listen: true).selectedSpot.spotName, 
                style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(        
        height: ScreenUtil().setHeight(70),
        padding: EdgeInsets.only(left:5),
        width: ScreenUtil().setWidth(750),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center ,          
          children: <Widget>[
             Text(" 安装地点        " + elec.elecSpotDetail??'', style: TextStyle(fontSize: ScreenUtil().setSp(33)),overflow: TextOverflow.ellipsis,),
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
                 show(context,  elec.elecSpotDetail);
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
            String t = '0';
            String a = elec.elecId;
            Application.router.navigateTo(context, "/recordById?type=$t&id=$a");
          },
        ),
        
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(1000),
        child: Text(" 预警数值        " + elec.elecEarly.toString() + " mA", style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(1000),
        child: Text(" 报警数值        " + elec.elecWarning.toString() + " mA", style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(1000),
        child: Text(" 设备材质        " + elec.elecTexture??'', style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(1000),
        child: Text(" 设备大小        " + elec.elecSize??'', style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(1000),
        child: Text(" 测量范围        " + elec.elecSetting??'', style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(1000),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(" 执行标准        ",style: TextStyle(fontSize: ScreenUtil().setSp(33))),
            Container(
              width: ScreenUtil().setWidth(500),
              child: Text(elec.elecStandard??'', style: TextStyle(fontSize: ScreenUtil().setSp(33),),maxLines: 2,
            overflow: TextOverflow.ellipsis,textWidthBasis: TextWidthBasis.parent,),
              ),
            
          ],
        ),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(1000),
        child: Text(" 工作电压        " + elec.elecVoltage??'', style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(1000),
        child: Text(" 工作电流        " + elec.elecCurrent??'', style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
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
        child: Text(" 设备描述        " + elec.elecDes??'', style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.black38))),
      ),
      Container(
        padding: EdgeInsets.all(5),
        alignment: Alignment.center,
        child: RaisedButton(
          
          child: Text("删除", style: TextStyle(color: Colors.white),),
          color: Colors.red,
          onPressed: () {
            deleteThis(context, 0, elec.elecId);
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


//打开第三方高德地图
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