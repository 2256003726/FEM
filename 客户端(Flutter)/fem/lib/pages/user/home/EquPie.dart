import 'package:flutter/material.dart';
import 'package:fem/provider/SpotProvider.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';
class EquPie extends StatefulWidget {
  int type;
  EquPie(this.type);
  @override
  _EquPieState createState() => _EquPieState();
}

class _EquPieState extends State<EquPie> {
  Map<String, double> data;
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }

  //获取数据
  _getData() async{
    //先等provider
    if(Provider.of<SpotProvider>(context, listen: false).selectedSpot == null) {
      await Future.delayed(Duration(seconds: 1));
    }
    

  }
}