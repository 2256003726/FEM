import 'package:date_format/date_format.dart';
import 'package:fem/config/CustomIcon.dart';
import 'package:fem/config/service_url.dart';
import 'package:fem/service/service_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fem/provider/SpotProvider.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';
class OutlinePage extends StatefulWidget {
  @override
  _OutlinePageState createState() => _OutlinePageState();
}

class _OutlinePageState extends State<OutlinePage> {
  int selected = 0;
  int allAmount = 0;
  int unAmount = 0;
  double elec = 0;
  double temp = 0;
  
  String begin = '';
  //String begin = formatDate(overDate.add(Duration(days: -1)), [yyyy, "-", mm, "-", dd, " ", HH, ":", nn]);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(230, 250, 255, 250),
      child: ListView(
        children: <Widget>[
          row1(),
          row2(),
          row3(),
          row4(),
          row5()
          
        ],
      ),
    );
  }
  @override
  void initState() { 
    super.initState();
    DateTime today = DateTime.now();
    int year = today.year;
    int month = today.month;
    int day = today.day;
    DateTime beginDay = DateTime(year, month, day);
    if(mounted) {
      setState(() {
        selected = 0;
        begin = formatDate(beginDay, [yyyy, "-", mm, "-", dd, " ", HH, ":", nn]);
      });
      }
    _getData();
  }
  Widget row1() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          RaisedButton(
            padding: EdgeInsets.all(5),
            child: Text("今日", style: TextStyle(color: selected==0? Colors.white: Colors.black54),),
            focusColor: Colors.blue,
            color: selected==0? Colors.blue: Colors.white,
            onPressed: () {
              DateTime today = DateTime.now();
              int year = today.year;
              int month = today.month;
              int day = today.day;
              DateTime beginDay = DateTime(year, month, day);
              setState(() {
                selected = 0;
                begin = formatDate(beginDay, [yyyy, "-", mm, "-", dd, " ", HH, ":", nn]);
              });
              _getData();
            },
          ),
          RaisedButton(
            color: selected==1? Colors.blue: Colors.white,
            padding: EdgeInsets.all(5),
            child: Text("最近一周",style: TextStyle(color: selected==1? Colors.white: Colors.black54),),
            focusColor: Colors.blue,
            onPressed: () {
              DateTime today = DateTime.now();
              DateTime beginDay = today.add(Duration(days: -7));
              setState(() {
                selected = 1;
                begin = formatDate(beginDay, [yyyy, "-", mm, "-", dd, " ", HH, ":", nn]);
              });
              _getData();
            },
          ),
          RaisedButton(
            color: selected==2? Colors.blue: Colors.white,
            padding: EdgeInsets.all(5),
            child: Text("最近一个月",style: TextStyle(color: selected==2? Colors.white: Colors.black54),),
            focusColor: Colors.blue,
            onPressed: () {
              DateTime today = DateTime.now();
              DateTime beginDay = today.add(Duration(days: -30));
              setState(() {
                selected = 2;
                begin = formatDate(beginDay, [yyyy, "-", mm, "-", dd, " ", HH, ":", nn]);
              });
              _getData();
            },
          ),
        ],
      )
    );
  }

  Widget row2() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Row(
        children: <Widget>[
          Icon(Icons.important_devices, size: 30, color: Colors.red,),
          Container(width: 10,),
          Text("警情数量", style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtil().setSp(40)
          ),)
        ],
      ),
    );
  }

  Widget row3() {
    return Container(
      width: ScreenUtil().setWidth(700),
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Card(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(300),
              alignment: Alignment.center,
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top:5),),
                Text("总数量:", style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(35)),),
                Padding(padding: EdgeInsets.only(top:5),),
                Text("未处理数量:",style: TextStyle(color: Colors.yellow, fontSize: ScreenUtil().setSp(35)),),
                Padding(padding: EdgeInsets.only(top:5),),
              ],
            ),
            ),
            Container(
              width: ScreenUtil().setWidth(300),
              child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top:5),),
                Text(allAmount.toString(),style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(35)),),
                Padding(padding: EdgeInsets.only(top:5),),
                Text(unAmount.toString(),style: TextStyle(color: Colors.red, fontSize: ScreenUtil().setSp(35)),),
                Padding(padding: EdgeInsets.only(top:5),),
              ],
            ),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget row4() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Row(
        children: <Widget>[
          Icon(CustomIcon.percent, color: Colors.blueAccent,),
          Container(width: 10,),
          Text("类型分布", style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtil().setSp(40)
          ),)
        ],
      ),
  );
  }
  
  Widget row5() {
    Map<String, double> dataMap = Map();
    dataMap.putIfAbsent("剩余电流式", () => elec);
    dataMap.putIfAbsent("测温式", () => temp);
    PieChart myPie = PieChart(
      dataMap: dataMap,

      chartType: ChartType.ring,
      initialAngle: 0,
      showChartValueLabel: true,
      decimalPlaces: 1,
      legendPosition: LegendPosition.right,
      chartLegendSpacing: 32.0,
      animationDuration: Duration(milliseconds: 500),
      chartValueBackgroundColor: Colors.white,
      showLegends: true,
      showChartValues: true,
      showChartValuesInPercentage: false,
      );
    return Container(
       padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
       child: Card(
         color: Colors.white,
         child: Container(
           padding: EdgeInsets.all(10),
           child: myPie,
         ),
       ),
    );
  }

  //获取数据
  _getData() async{
    if(Provider.of<SpotProvider>(context, listen: false).selectedSpot == null) {
      await Future.delayed(Duration(seconds: 1));
    }
    if(Provider.of<SpotProvider>(context, listen: false).selectedSpot != null) {
      var formData = {
        "spotId": Provider.of<SpotProvider>(context, listen: false).selectedSpot.spotId,
        "begin": begin,
        'over':formatDate(DateTime.now(), [yyyy, "-", mm, "-", dd, " ", HH, ":", nn])
      };
      await request(servicePath['getRecordOutline'], formData: formData).then((val) {
        if(val != null) {
          if(mounted) {
            setState(() {
              allAmount = val['allAmount'];
              unAmount = val['unAmount'];
              elec = double.parse(val['elec'].toString());
              temp = double.parse(val['temp'].toString());
            });
          }
          
        }
      });
     
    }
    
  }
}

