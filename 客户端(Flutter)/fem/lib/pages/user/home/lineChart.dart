import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fem/config/service_url.dart';
import 'package:fem/service/service_method.dart';
import 'package:fem/model/Electricity.dart';
import 'package:fem/model/Temperature.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LineOnTime extends StatefulWidget {
  final int type;
  final String id;
  LineOnTime(this.type, this.id);
  @override
  _LineOnTimeState createState() => _LineOnTimeState();
}

class _LineOnTimeState extends State<LineOnTime> {
  Timer _timer;
  int value;
  List<LineData> data = [];
  String title;
  String detail;
  Text stateText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("实时监控"),
      ),
      body: Container( 
        child: _paint()  
      ),
    );
    
  }

  //初始化！获取数据，然后打开定时器
  @override
  void initState() { 
    _getData();
    super.initState();  
    _start();
  }

  //销毁!一定要关闭定时器
  @override
  void dispose() { 
    _timer.cancel();
    _timer = null;
    super.dispose();
  }
  void _getData() async{
    if(widget.type == 0) {
      var formData = {
      'elecId': widget.id
      };
      await request(servicePath['getDetail'], parms: formData).then((val) {
        if(mounted) {
          setState(() { 
            //String time = formatDate(DateTime.now(), [HH, ":", nn, ":", ss]);
            ElectricityModel elec = ElectricityModel.fromJson(val);  
            int value = elec.elecValue;
            title = elec.elecName;
            if(elec.elecState=='0') {
              stateText = Text("设备正常", 
              style: TextStyle(color: Colors.green, fontSize: ScreenUtil().setSp(30)),);
            }
            if(elec.elecState=='1') {
              stateText = Text("设备已预警", 
              style: TextStyle(color: Colors.orange, fontSize: ScreenUtil().setSp(30)),);
            }
            if(elec.elecState=='2') {
              stateText = Text("设备已报警", 
              style: TextStyle(color: Colors.red, fontSize: ScreenUtil().setSp(30)),);
            }
            if(data.length > 5) {
              data.removeAt(0);
            }
            data.add(new LineData(new DateTime.now(), value));
          }); 
        }   
      });
    } else if(widget.type == 1) {
      var formData = {
      'tempId': widget.id
      };
      await request(servicePath['getTempDetail'], parms: formData).then((val) {
        if(mounted) {
          setState(() { 
            //String time = formatDate(DateTime.now(), [HH, ":", nn, ":", ss]);
             
            TempModel temp = TempModel.fromJson(val);
            int value = temp.tempVal;
            title = temp.tempName;
            if(temp.tempState=='0') {
              stateText = Text("设备正常", 
              style: TextStyle(color: Colors.green, fontSize: ScreenUtil().setSp(30)),);
            }
            if(temp.tempState=='1') {
              stateText = Text("设备已预警", 
              style: TextStyle(color: Colors.orange, fontSize: ScreenUtil().setSp(30)),);
            }
            if(temp.tempState=='2') {
              stateText = Text("设备已报警", 
              style: TextStyle(color: Colors.red, fontSize: ScreenUtil().setSp(30)),);
            }
            if(data.length > 5) {
              data.removeAt(0);
            }
            data.add(new LineData(new DateTime.now(), value));
          }); 
        }   
      });
    }
  }

  void _start() {
    //设置2秒执行一次
    const period = const Duration(seconds: 2);
    _timer = Timer.periodic(period, (time) async{
      _getData();
    });
  }

  Widget _paint() {
    if(data == null || data.length == 0) {
      return Container(child: Text("加载中"),);
    } else {
      var seriseLine = [
        charts.Series(
          data: data,
          domainFn: (LineData l, _) => l.time,
          measureFn: (LineData l, _) => l.val,
          displayName: "实时数据",
          id: "lineVal",
          
        )
      ];
      charts.AxisSpec a;
      
      if(data.length>=6) {
         a = new charts.DateTimeAxisSpec(
          tickProviderSpec: new charts.StaticDateTimeTickProviderSpec(
            [
                new charts.TickSpec(
                   data[0].time,
                   label: '${data[0].time.minute}: ${data[0].time.second}',
                ),
                new charts.TickSpec(
                   data[1].time,
                   label: '${data[1].time.minute}: ${data[1].time.second}',
                ),
                new charts.TickSpec(
                   data[2].time,
                   label: '${data[2].time.minute}: ${data[2].time.second}',
                ),
                new charts.TickSpec(
                   data[3].time,
                   label: '${data[3].time.minute}: ${data[3].time.second}',
                ),
                new charts.TickSpec(
                   data[4].time,
                   label: '${data[4].time.minute}: ${data[4].time.second}',
                ),
                new charts.TickSpec(
                   data[5].time,
                   label: '${data[5].time.minute}: ${data[5].time.second}',
                ),
              ]
          )
        );
      } else if(data.length==5) {
        a = new charts.DateTimeAxisSpec(
          tickProviderSpec: new charts.StaticDateTimeTickProviderSpec(
            [
                new charts.TickSpec(
                   data[0].time,
                   label: '${data[0].time.minute}: ${data[0].time.second}',
                ),
                new charts.TickSpec(
                   data[1].time,
                   label: '${data[1].time.minute}: ${data[1].time.second}',
                ),
                new charts.TickSpec(
                   data[2].time,
                   label: '${data[2].time.minute}: ${data[2].time.second}',
                ),
                new charts.TickSpec(
                   data[3].time,
                   label: '${data[3].time.minute}: ${data[3].time.second}',
                ),
                new charts.TickSpec(
                   data[4].time,
                   label: '${data[4].time.minute}: ${data[4].time.second}',
                ),]));
      } else if(data.length==4) {
        a = new charts.DateTimeAxisSpec(
          tickProviderSpec: new charts.StaticDateTimeTickProviderSpec(
            [
                new charts.TickSpec(
                   data[0].time,
                   label: '${data[0].time.minute}: ${data[0].time.second}',
                ),
                new charts.TickSpec(
                   data[1].time,
                   label: '${data[1].time.minute}: ${data[1].time.second}',
                ),
                new charts.TickSpec(
                   data[2].time,
                   label: '${data[2].time.minute}: ${data[2].time.second}',
                ),
                new charts.TickSpec(
                   data[3].time,
                   label: '${data[3].time.minute}: ${data[3].time.second}',
                ),
               ]));
      }else if(data.length==3) {
        a = new charts.DateTimeAxisSpec(
          tickProviderSpec: new charts.StaticDateTimeTickProviderSpec(
            [
                new charts.TickSpec(
                   data[0].time,
                   label: '${data[0].time.minute}: ${data[0].time.second}',
                ),
                new charts.TickSpec(
                   data[1].time,
                   label: '${data[1].time.minute}: ${data[1].time.second}',
                ),
                new charts.TickSpec(
                   data[2].time,
                   label: '${data[2].time.minute}: ${data[2].time.second}',
                ),
               
               ]));
      }else if(data.length==2) {
        a = new charts.DateTimeAxisSpec(
          tickProviderSpec: new charts.StaticDateTimeTickProviderSpec(
            [
                new charts.TickSpec(
                   data[0].time,
                   label: '${data[0].time.minute}: ${data[0].time.second}',
                ),
                new charts.TickSpec(
                   data[1].time,
                   label: '${data[1].time.minute}: ${data[1].time.second}',
                ),
               
               
               ]));
      }else if(data.length==1) {
        a = new charts.DateTimeAxisSpec(
          tickProviderSpec: new charts.StaticDateTimeTickProviderSpec(
            [
                new charts.TickSpec(
                   data[0].time,
                   label: '${data[0].time.minute}: ${data[0].time.second}',
                ),     
               ]));
      }
      return Container(
        child: Column(
          children: <Widget>[
            Container(
              height: ScreenUtil().setHeight(800),
              child: Card(
                child: charts.TimeSeriesChart(
                seriseLine,
                animate: true,
                domainAxis: a,           
                behaviors: [
                new charts.SeriesLegend(
                  position: charts.BehaviorPosition.bottom,
                  showMeasures: true,
                    )
                  ],
                ),
              ),
            ),
            
            Card(
              child: Column(
                children: <Widget>[
                  Text("设备名称：$title", style: TextStyle(color: Colors.green, fontSize: ScreenUtil().setSp(30)),),
                  Text("设备编号：${widget.id}", style: TextStyle(color: Colors.green, fontSize: ScreenUtil().setSp(30)),),
                  stateText
                ],
               
              ),
            ),
          ],
        )
        
      );
    }
  }
}

class LineData {
  final DateTime time;
  //final String time;
  final int val;
  LineData(this.time, this.val);
}