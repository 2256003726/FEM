import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:fem/provider/RecordProvider.dart';

class TimePickerPage extends StatefulWidget {
  @override
  _TimePickerPageState createState() => _TimePickerPageState();
}

class _TimePickerPageState extends State<TimePickerPage> {
  
  //显示的时间
  DateTime _beginDateTime = DateTime.parse('1998-11-24 10:10:10');
  DateTime _overDateTime = DateTime.now();
  //取消时恢复的时间
  DateTime _confirmBegin = DateTime.parse('1998-11-24 10:10:10');
  DateTime _confirmOver = DateTime.now();
  //默认选择时间
  DateTime _initBegin;
  DateTime _initOver;

  @override
  void initState() {
    _beginDateTime = Provider.of<RecordProvider>(context, listen: false).beginTime;
    _overDateTime = Provider.of<RecordProvider>(context, listen: false).overTime;
    _initBegin = Provider.of<RecordProvider>(context, listen: false).beginTime;
    _initOver = Provider.of<RecordProvider>(context, listen: false).overTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      //decoration: BoxDecoration(color: Colors.white38),
      padding: EdgeInsets.only(top:50),
      child: Column(
        children: <Widget>[
          row1(),
          Container(
            padding: EdgeInsets.all(8),
            child: card(),
          ),
        ],
      ),
      
    );
    
  }
  Widget row1() {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Icon(Icons.search, color: Colors.orange,size: 30,),
          Text("日期选择",style: TextStyle(fontSize: ScreenUtil().setSp(40),fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
  
  Widget card() {
    return Card(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("开始时间", style: TextStyle(fontSize: ScreenUtil().setSp(40),fontWeight: FontWeight.bold),),
              Padding(padding: EdgeInsets.only(right: 10),),
              InkWell(
                onTap: () {
                  _showDatePicker1(context);
                },
                child: Row(
                  children: <Widget>[
                    Text(formatDate(
                        _beginDateTime, [yyyy, "-", mm, "-", dd, " ", HH, ":", nn]),
                        style: TextStyle(color: Colors.blue,fontSize: ScreenUtil().setSp(30)),
                        ),
                    Icon(Icons.arrow_drop_down,color: Colors.blue,)
                  ],
                ),
              )
            ],
          ),
          Padding(padding: EdgeInsets.only(top:20),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("截止时间", style: TextStyle(fontSize: ScreenUtil().setSp(40),fontWeight: FontWeight.bold),),
              Padding(padding: EdgeInsets.only(right: 10),),
              InkWell(
                onTap: () {
                  _showDatePicker2(context);
                },
                child: Row(
                  children: <Widget>[
                    Text(formatDate(
                        _overDateTime, [yyyy, "-", mm, "-", dd, " ", HH, ":", nn]),
                        style: TextStyle(color: Colors.blue,fontSize: ScreenUtil().setSp(30)),
                        ),
                    Icon(Icons.arrow_drop_down,color: Colors.blue,)
                  ],
                ),
              )
            ],
          ),
          Padding(padding: EdgeInsets.only(top:10),),
          RaisedButton(
            onPressed: () {
              Provider.of<RecordProvider>(context, listen: false).setBeginTime(_confirmBegin);
              Provider.of<RecordProvider>(context, listen: false).setOverTime(_confirmOver);
              Navigator.of(context).pop(1);
            },
            color: Colors.blue,
            child: Text("确定",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(35)),),
          )
        ],
      ),
    );
  }
  void _showDatePicker1(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      //选择主题
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
      ),
      minDateTime: DateTime.parse('1998-11-24 10:10:10'),   //选择器上最早时间
      maxDateTime: DateTime.parse('2021-11-24 10:10:10'),   //选择器上最晚时间
      //默认选择时间
     // initialDateTime: DateTime.parse(
     //   formatDate(DateTime.parse('2019-11-24 10:10:10'), [yyyy, "-", mm, "-", "dd", " ", HH, ":", nn, ":", ss])),
     initialDateTime: _initBegin,
      dateFormat: 'yy年M月d日    EEE,H时:m分',   //时间格式
      locale: DateTimePickerLocale.zh_cn,       //国际化配置
      pickerMode: DateTimePickerMode.datetime,
      onCancel: () {
        setState(() {
          _beginDateTime = _confirmBegin;
        });       
      },
      onChange: (dateTime, List<int> index) {
        setState(() {
          _beginDateTime = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _beginDateTime = dateTime;
          _confirmBegin = dateTime;
          _initBegin = dateTime;
          //Provider.of<RecordProvider>(context, listen: false).setBeginTime(_confirmBegin);
        });
      },

    );
  }

  void _showDatePicker2(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      //选择主题
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        //confirm: Text('custom Done',style: TextStyle(color: Colors.red),),
        //cancel: Text('custom cancel', style: TextStyle(color: Colors.cyan),)
      ),
      minDateTime: DateTime.parse('2010-11-24 10:10:10'),   //选择器上最早时间
      maxDateTime: DateTime.parse('2021-11-24 10:10:10'),   //选择器上最晚时间
      //默认选择时间
      //initialDateTime: DateTime.parse(
      //  formatDate(DateTime.now(), [yyyy, "-", mm, "-", "dd", " ", HH, ":", nn, ":", ss])),
      initialDateTime: _initOver,
      dateFormat: 'yy年M月d日    EEE,H时:m分',   //时间格式
      locale: DateTimePickerLocale.zh_cn,       //国际化配置
      pickerMode: DateTimePickerMode.datetime,
      onCancel: () {
        setState(() {
          _overDateTime = _confirmOver;         
        });
      },
      onChange: (dateTime, List<int> index) {
        setState(() {
          _overDateTime = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _overDateTime = dateTime;
          _confirmOver = dateTime;
          _initOver = dateTime;
          //Provider.of<RecordProvider>(context, listen: false).setOverTime(_confirmOver);
        });
      },

    );
  }
}