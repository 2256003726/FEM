import 'package:flutter/material.dart';
import 'package:fem/config/service_url.dart';
import 'package:fem/service/service_method.dart';
import 'package:flutter/material.dart';
import 'package:fem/provider/SpotProvider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fem/model/RecordElec.dart';
import 'package:fem/provider/ElecProvider.dart';
import 'package:fem/provider/TempProvider.dart';
class MyPieChart extends StatefulWidget {
  @override
  _MyPieChartState createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  List<PiePer> elecPie = new List<PiePer>();
  List<PiePer> tempPie = new List<PiePer>();
  @override
  Widget build(BuildContext context) {
    if(Provider.of<SpotProvider>(context, listen: true).selectedSpot == null) {
      return Container(
        height: ScreenUtil().setHeight(800),
        width: ScreenUtil().setWidth(750),
        child: Center(child: Text("饼状图加载中"),),
      );
    } 
      _getData();
      return Container(

      height: ScreenUtil().setHeight(300),
    
      child: _pie(),

    );
    
    
  }

  Widget _pie() {
    

    var series = charts.Series(
        data: elecPie,
        domainFn: (PiePer p, _) => p.state,
        measureFn: (PiePer p, _) => p.num,
        displayName: "电流",
        id: "pie1",
        overlaySeries: true,
        
        

      );
    var seriesPie = [
      
      series,
      
    ];
    
    return charts.PieChart(
        
        seriesPie,
        defaultInteractions: true,
        
        behaviors: [
          
          new charts.DatumLegend(
            showMeasures: true,

            position: charts.BehaviorPosition.end, desiredMaxRows: 3
          )
          
          
        ],
        // Configure the width of the pie slices to 60px. The remaining space in
        // the chart will be left as a hole in the center.
        defaultRenderer: new charts.ArcRendererConfig(arcWidth: 60),
    );
    
  }

  _getData() {
    
      var data = [
      new PiePer("正常", Provider.of<ElecProvider>(context, listen: true).commonNum),
      new PiePer("预警", Provider.of<ElecProvider>(context, listen: true).earlyNum),
      new PiePer("报警", Provider.of<ElecProvider>(context, listen: true).warnNum),
    ];
    var data2 = [
      new PiePer("正常", Provider.of<TempProvider>(context, listen: true).commonNum),
      new PiePer("预警", Provider.of<TempProvider>(context, listen: true).earlyNum),
      new PiePer("报警", Provider.of<TempProvider>(context, listen: true).warnNum),
    ];
    setState(() {
      elecPie = data;
      tempPie = data2;
    });
    }
    
  
  
}

class PiePer {
  String state;
  int num;
  PiePer(this.state, this.num);
}



