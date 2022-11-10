import 'package:fem/config/service_url.dart';
import 'package:fem/service/service_method.dart';
import 'package:flutter/material.dart';
import 'package:fem/provider/SpotProvider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fem/model/RecordElec.dart';
class MyChart extends StatefulWidget {
  @override
  _MyChartState createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> {
  //柱状图数据
  List<BarNum> myList = new List<BarNum>();
  List<BarNum> myList2 = new List<BarNum>();
  //文本显示
  String _year = DateTime.now().year.toString();
  String _elecNums = '';
  String _tempNums = '';
  
 @override
 void initState() { 
   super.initState();
    _getData();
    _getData2();
 }
  _getData() async {        
    if(Provider.of<SpotProvider>(context, listen: false).selectedSpot != null) {
      var formData = {
        'begin': '',
        'over': '',
        'page': 1,
        'size': 0,
        'spotId': Provider.of<SpotProvider>(context, listen: false).selectedSpot.spotId,
        'state': ''
      };
      await request(servicePath['getRecordElecList'], formData: formData).then((val) {
        if(val != null) {
          if(val['size'] > 0) {
            List<RecordElecModel> l = RecordElecListModel.fromJson(val['list']).data;          
            List<BarNum> m = new List<BarNum>();          
            for(int i = 1; i <= 12; i++) {
              BarNum b = new BarNum(i.toString()+"月", 0);
              m.add(b);
            }
            l.forEach((f) {
              if(f.recordTime.month == 1) {
                m[0].num++;
              } else if(f.recordTime.month == 2) {
                m[1].num++;
              } else if(f.recordTime.month == 3) {
                m[2].num++;
              } else if(f.recordTime.month == 4) {
                m[3].num++;
              } else if(f.recordTime.month == 5) {
                m[4].num++;
              } else if(f.recordTime.month == 6) {
                m[5].num++;
              } else if(f.recordTime.month == 7) {
                m[6].num++;
              } else if(f.recordTime.month == 8) {
                m[7].num++;
              } else if(f.recordTime.month == 9) {
                m[8].num++;
              } else if(f.recordTime.month == 10) {
                m[9].num++;
              } else if(f.recordTime.month == 11) {
                m[10].num++;
              } else if(f.recordTime.month == 12) {
                m[11].num++;
              } 
            });
            if(mounted) {
                setState(() {
                myList = m;
              });
          
            }
            
          }
        }
    });
    }
    
}

  _getData2() async {     
    if(Provider.of<SpotProvider>(context, listen: false).selectedSpot != null) {
      var formData = {
        'begin': '',
        'over': '',
        'page': 1,
        'size': 0,
        'spotId': Provider.of<SpotProvider>(context, listen: false).selectedSpot.spotId,
        'state': ''
      };
      await request(servicePath['getRecordTempList'], formData: formData).then((val) {
        if(val != null) {
          if(val['size'] > 0) {
            List<RecordElecModel> l = RecordElecListModel.fromJson(val['list']).data;       
            List<BarNum> m = new List<BarNum>();      
            for(int i = 1; i <= 12; i++) {
              BarNum b = new BarNum(i.toString()+"月", 0);
              m.add(b);
            }
            l.forEach((f) {
              if(f.recordTime.month == 1) {
                m[0].num++;
              } else if(f.recordTime.month == 2) {
                m[1].num++;
              } else if(f.recordTime.month == 3) {
                
                m[2].num++;
              } else if(f.recordTime.month == 4) {
                m[3].num++;
              } else if(f.recordTime.month == 5) {
                m[4].num++;
              } else if(f.recordTime.month == 6) {
                m[5].num++;
              } else if(f.recordTime.month == 7) {
                m[6].num++;
              } else if(f.recordTime.month == 8) {
                m[7].num++;
              } else if(f.recordTime.month == 9) {
                m[8].num++;
              } else if(f.recordTime.month == 10) {
                m[9].num++;
              } else if(f.recordTime.month == 11) {
                m[10].num++;
              } else if(f.recordTime.month == 12) {
                m[11].num++;
              } 
            });
            if(mounted) {
              setState(() {
                myList2 = m;
              });
            }
            
          
          }
        }
    });
    }    
    
}
  @override
  void dispose() {
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: Text("本年度报警次数柱状图"),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[

            Container(
              height: ScreenUtil().setHeight(800),
              child: _getBar(),
            ),
            

          ],
        )
      ),
     
    );
  }

  //获取柱状图数据
  Widget _getBar() {

    if(myList.length == 0) {
      return Container(child: Center(child: Text("无数据"),));
    }
    myList.removeRange(DateTime.now().month, myList.length);
    myList2.removeRange(DateTime.now().month, myList2.length);

    var seriesBar = [
      charts.Series(        
        // colorFn: (BarNum b, _) {
        //   if (b.num < 10) {            
        //     return charts.MaterialPalette.blue.shadeDefault;
        //   } else if (10 < b.num && b.num< 20) {
        //     return charts.MaterialPalette.deepOrange.shadeDefault;
        //   } else {
        //     return charts.MaterialPalette.red.shadeDefault;
        //   }
        // },

        data: myList, 
        domainFn: (BarNum b, _) => b.month,
        measureFn: (BarNum b, _) => b.num,
        displayName: "电流",
        id: "statis"
      ),
       charts.Series(     
        colorFn: (BarNum b, _) {
          if (b.num < 10) {            
            return charts.MaterialPalette.cyan.shadeDefault;
          } else if (10 < b.num && b.num< 20) {
            return charts.MaterialPalette.indigo.shadeDefault;
          } else {
            return charts.MaterialPalette.purple.shadeDefault;
          }
        },   
        data: myList2, 
        domainFn: (BarNum b, _) => b.month,
        measureFn: (BarNum b, _) => b.num,
        displayName: "测温",
        
        id: "statis2"
      )
    ];
    return charts.BarChart(    
      seriesBar,
      animate: true,
      animationDuration: Duration(seconds: 1),
      barGroupingType: charts.BarGroupingType.grouped,
      flipVerticalAxis: false,
      behaviors: [
          new charts.SeriesLegend(
              position: charts.BehaviorPosition.end, desiredMaxRows: 2),
        ],
      
      );
  }
}

// 柱状图数据类型
class BarNum {
  String month;
  int num;
  BarNum(this.month, this.num);
}




