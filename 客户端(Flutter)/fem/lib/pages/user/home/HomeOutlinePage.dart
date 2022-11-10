import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fem/provider/ElecProvider.dart';
import 'package:fem/provider/UserProvider.dart';
import 'package:provider/provider.dart';
import 'dropdown.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:fem/provider/TempProvider.dart';
//首页概要信息
class HomeOutlinePage extends StatefulWidget {
  @override
  _HomeOutlinePageState createState() => _HomeOutlinePageState();
}

class _HomeOutlinePageState extends State<HomeOutlinePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 240,248,255),
      child: EasyRefresh(
        child: ListView(
          children: <Widget>[
            _row1(),
            _row2(),
            _pie1(),
            _pie2()
          ],
        ),
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
      )
    );
  }

  //第一行-----用户欢迎
  Widget _row1() {
    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Icon(Icons.person_pin_circle, color: Colors.pink, size: 30,),
          Padding(padding: EdgeInsets.only(right:10),),
          Text("欢迎您！" + Provider.of<UserProvider>(context, listen: true).user.userName,
            style: TextStyle(fontSize: ScreenUtil().setSp(40),color: Colors.orange),
          ),
        ],
      ),
    );
  }

  //第二行-----地址选择框
  Widget _row2() {
    return Container(
      child: Column(
        children: <Widget>[
          Text("请选择项目",style: TextStyle(color: Colors.black54),),
          Dropdown(),
        ],
      )
    );
  }

  //第三部分------电流饼图
  Widget _pie1() {
    Map<String, double> dataMap = Map();
    dataMap.putIfAbsent("报警", 
      () => double.parse(Provider.of<ElecProvider>(context, listen: true).warnNum.toString()));  
    dataMap.putIfAbsent("预警",
      () => double.parse(Provider.of<ElecProvider>(context, listen: true).earlyNum.toString()));
    dataMap.putIfAbsent("正常", 
      () => double.parse(Provider.of<ElecProvider>(context, listen: true).commonNum.toString()));
    
    PieChart myPie = PieChart(
      dataMap: dataMap,
      chartType: ChartType.disc,
      initialAngle: 0,
      showChartValueLabel: true,
      decimalPlaces: 1,
      legendPosition: LegendPosition.right,
      chartLegendSpacing: 32.0,
      animationDuration: Duration(milliseconds: 500),
      chartValueBackgroundColor: Colors.white,
      showLegends: true,
      showChartValues: true,
      showChartValuesInPercentage: true,
    );
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.pie_chart_outlined, color: Colors.orange,size: 30,),
              Padding(padding: EdgeInsets.only(right:5),),
              Text("剩余电流式设备",style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(40)) ,
              ),
            ],
          ),
          Card(
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.all(10),
              child: myPie,
            ),
          ),
          
        ],
        
      ),
    );

  }

  //第四部分------测温饼图
  Widget _pie2() {
    Map<String, double> dataMap = Map();
    dataMap.putIfAbsent("报警", 
      () => double.parse(Provider.of<TempProvider>(context, listen: true).warnNum.toString()));
    dataMap.putIfAbsent("预警",
      () => double.parse(Provider.of<TempProvider>(context, listen: true).earlyNum.toString()));
    dataMap.putIfAbsent("正常", 
    () => double.parse(Provider.of<TempProvider>(context, listen: true).commonNum.toString()));
    
    PieChart myPie = PieChart(
      dataMap: dataMap,
      chartType: ChartType.disc,
      initialAngle: 0,
      showChartValueLabel: true,
      decimalPlaces: 1,
      legendPosition: LegendPosition.right,
      chartLegendSpacing: 32.0,
      animationDuration: Duration(milliseconds: 500),
      chartValueBackgroundColor: Colors.white,
      showLegends: true,
      showChartValues: true,
      showChartValuesInPercentage: true,
    );
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.pie_chart_outlined, color: Colors.orange,size: 30,),
              Padding(padding: EdgeInsets.only(right:5),),
              Text("测温设备",style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(40)) ,
              ),
            ],
          ),
          Card(
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.all(10),
              child: myPie,
            ),
          ),
          
        ],
        
      ),
    );
  }
}