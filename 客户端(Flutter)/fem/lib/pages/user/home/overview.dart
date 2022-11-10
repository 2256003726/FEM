import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:fem/provider/ElecProvider.dart';
import '../../../routes/application.dart';
import 'package:fem/provider/SpotProvider.dart';
import 'package:fem/provider/TempProvider.dart';
class Over extends StatefulWidget {
  final int type;
  Over(this.type);
  @override
  _OverState createState() => _OverState();
}

class _OverState extends State<Over> {

  List<int> num = [0,0,0,0];
  
  @override
  Widget build(BuildContext context) {
   
    if(Provider.of<SpotProvider>(context, listen: true).selectedSpot == null) {
      return Container(
        height: ScreenUtil().setHeight(200),
        child: Text("请选择项目哦", style: TextStyle(color: Colors.black26),textAlign: TextAlign.center,),
      );
    }
    if(widget.type == 0) {
      setState(() {
        num[0]= Provider.of<ElecProvider>(context, listen: true).allNum;
        num[1] = Provider.of<ElecProvider>(context, listen: true).commonNum;
        num[2] = Provider.of<ElecProvider>(context, listen: true).earlyNum;
        num[3] = Provider.of<ElecProvider>(context, listen: true).warnNum;
      });
      
    } else {

    }
    
    return Container(
      height: ScreenUtil().setHeight(200),
      padding: EdgeInsets.all(3.0),
      margin: EdgeInsets.all(10.0),
      child: Card(       
        child: GridView.count(     
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 4,   //一行4个
        padding: EdgeInsets.all(5.0),
        children: <Widget>[
          InkWell(                  
            onTap: () {
              String state = '4';
              Application.router.navigateTo(context, "/elecList2?state=${state}");
            },
            child: Container(            
              decoration: BoxDecoration(               
                border: Border(right: BorderSide(width: 0.5, color: Colors.black))
                ),
              child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[      
                          
                Text(num[0].toString(), style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(30)),),
                Text("设备", style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(30)),)
              ],
            ),
            )
          ),
          InkWell(
            onTap: () {
               String state = '0';
               Application.router.navigateTo(context, "/elecList2?state=${state}");
            },
            child: Container(
               decoration: BoxDecoration(               
                border: Border(right: BorderSide(width: 0.5, color: Colors.black))
                ),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(num[1].toString(), style: TextStyle(color: Colors.green,fontSize: ScreenUtil().setSp(30)),),
                Text("正常", style: TextStyle(color: Colors.green,fontSize: ScreenUtil().setSp(30)),)
              ],
            ),
            )
            
          ),
          InkWell(
            onTap: () {
               String state = '1';
               Application.router.navigateTo(context, "/elecList2?state=${state}");
            },
            child: Container(
              decoration: BoxDecoration(               
                border: Border(right: BorderSide(width: 0.5, color: Colors.black))
                ),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(num[2].toString(), style: TextStyle(color: Colors.orange,fontSize: ScreenUtil().setSp(30)),),
                Text("预警", style: TextStyle(color: Colors.orange,fontSize: ScreenUtil().setSp(30)))
              ],
            ),
            )
          ),
          InkWell(
            onTap: () {
              // Application.router.navigateTo(context, "/elecList?level=${Uri.encodeComponent(level)}");
                String state = '2';
               Application.router.navigateTo(context, "/elecList2?state=${state}");
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(num[3].toString(), style: TextStyle(color: Colors.red,fontSize: ScreenUtil().setSp(30))),
                Text("报警", style: TextStyle(color: Colors.red,fontSize: ScreenUtil().setSp(30)))
              ],
            ),
          ),
        ],
      )     ,
        )
      
    );
  }
}






class Over2 extends StatefulWidget {
  final int type;
  Over2(this.type);
  @override
  _Over2State createState() => _Over2State();
}

class _Over2State extends State<Over2> {

  List<int> num = [0,0,0,0];
  
  @override
  Widget build(BuildContext context) {
   
    if(Provider.of<SpotProvider>(context, listen: true).selectedSpot == null) {
      return Container(
        height: ScreenUtil().setHeight(200),
        child: Text("请选择项目哦", style: TextStyle(color: Colors.black26),textAlign: TextAlign.center,),
      );
    }
    if(widget.type == 0) {
      setState(() {
        num[0]= Provider.of<TempProvider>(context, listen: true).allNum;
        num[1] = Provider.of<TempProvider>(context, listen: true).commonNum;
        num[2] = Provider.of<TempProvider>(context, listen: true).earlyNum;
        num[3] = Provider.of<TempProvider>(context, listen: true).warnNum;
      });
      
    } else {

    }
    
    return Container(
      height: ScreenUtil().setHeight(200),
      padding: EdgeInsets.all(3.0),
      margin: EdgeInsets.all(10.0),
      child: Card(       
        child: GridView.count(     
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 4,   //一行4个
        padding: EdgeInsets.all(5.0),
        children: <Widget>[
          InkWell(                  
            onTap: () {
              String state = '4';
              Application.router.navigateTo(context, "/tempList?state=${state}");
            },
            child: Container(            
              decoration: BoxDecoration(               
                border: Border(right: BorderSide(width: 0.5, color: Colors.black))
                ),
              child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[      
                          
                Text(num[0].toString(), style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(30)),),
                Text("设备", style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(30)),)
              ],
            ),
            )
          ),
          InkWell(
            onTap: () {
               String state = '0';
               Application.router.navigateTo(context, "/tempList?state=${state}");
            },
            child: Container(
               decoration: BoxDecoration(               
                border: Border(right: BorderSide(width: 0.5, color: Colors.black))
                ),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(num[1].toString(), style: TextStyle(color: Colors.green,fontSize: ScreenUtil().setSp(30)),),
                Text("正常", style: TextStyle(color: Colors.green,fontSize: ScreenUtil().setSp(30)),)
              ],
            ),
            )
            
          ),
          InkWell(
            onTap: () {
               String state = '1';
               Application.router.navigateTo(context, "/tempList?state=${state}");
            },
            child: Container(
              decoration: BoxDecoration(               
                border: Border(right: BorderSide(width: 0.5, color: Colors.black))
                ),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(num[2].toString(), style: TextStyle(color: Colors.orange,fontSize: ScreenUtil().setSp(30)),),
                Text("预警", style: TextStyle(color: Colors.orange,fontSize: ScreenUtil().setSp(30)))
              ],
            ),
            )
          ),
          InkWell(
            onTap: () {
              // Application.router.navigateTo(context, "/elecList?level=${Uri.encodeComponent(level)}");
                String state = '2';
               Application.router.navigateTo(context, "/tempList?state=${state}");
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(num[3].toString(), style: TextStyle(color: Colors.red,fontSize: ScreenUtil().setSp(30))),
                Text("报警", style: TextStyle(color: Colors.red,fontSize: ScreenUtil().setSp(30)))
              ],
            ),
          ),
        ],
      )     ,
        )
      
    );
  }
}