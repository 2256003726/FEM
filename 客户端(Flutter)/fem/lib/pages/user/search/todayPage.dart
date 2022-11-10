import 'package:fem/model/Electricity.dart';
import 'package:fem/model/RecordElec.dart';
import 'package:fem/model/RecordTemp.dart';
import 'package:fem/model/Temperature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fem/provider/SpotProvider.dart';
import 'package:fem/pages/user/search/dispose.dart';
import 'package:fem/service/service_method.dart';
import 'package:fem/config/service_url.dart';
class TodayPage extends StatefulWidget {
  @override
  _TodayPageState createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {

  List list = [];
  int selected = 0;
  int page = 1;
  EasyRefreshController _controller = EasyRefreshController();
  String local = '';
  @override
  void initState() { 
    super.initState();
    _getRecordList(0);
  }
  //获取数据
  _getRecordList(int type) async{   
    if(Provider.of<SpotProvider>(context, listen: false).selectedSpot == null) {
        await Future.delayed(Duration(seconds: 1));
    }
    if(Provider.of<SpotProvider>(context, listen: false).selectedSpot != null) {
      DateTime today = DateTime.now();
      int year = today.year;
      int month = today.month;
      int day = today.day;
      DateTime beginDay = DateTime(year, month, day);
      var formData = {
        'begin': formatDate(beginDay, [yyyy, "-", mm, "-", dd, " ", HH, ":", nn]),
        'over': formatDate(DateTime.now(), [yyyy, "-", mm, "-", dd, " ", HH, ":", nn]),
        'page': page,
        'size': 5,
        'spotId': Provider.of<SpotProvider>(context, listen: false).selectedSpot.spotId,
        'state': null
      };
      if(type == 0) {
        await request(servicePath['getRecordElecList'], formData: formData).then((val) {
          if(val != null) {
            if(page > val['pages']) {      
              page --;
              _controller.finishLoad(success: true, noMore: true);
            } else {        
              if(mounted) {
                setState(() {            
                  List<RecordElecModel> l = RecordElecListModel.fromJson(val['list']).data;
                  list.addAll(l);        
                });
              }
            }    
          }      
        });
      } else {
        await request(servicePath['getRecordTempList'], formData: formData).then((val) {     
          if(val != null) {
            if(page > val['pages']) {
              page --;
              _controller.finishLoad();
            } else {
              if(mounted) {
                setState(() {
                  List<RecordTempModel> l = RecordTempListModel.fromJson(val['list']).data;
                  list.addAll(l);
                });
              }
              
            }
          }
        });
      }
    }
    
  }
  @override
  Widget build(BuildContext context) {
    if(mounted) {
      setState(() {
        local = Provider.of<SpotProvider>(context, listen: true).local;
      });
    }
    return Container(
       color: Color.fromARGB(230, 250, 255, 250),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: row1(),
            ),
            Container( 
              padding: EdgeInsets.only(top:60),
              child: EasyRefresh(
                controller: _controller,         
                header: ClassicalHeader(               
                  refreshedText: "刷新完成",
                  refreshingText: "刷新中",
                  refreshText: "刷新",
                  refreshReadyText: "上拉刷新",    
                ),
                footer: ClassicalFooter(
                  textColor: Colors.pink,
                  noMoreText: "没有更多了哦",
                  bgColor: Colors.white,
                  infoColor: Colors.blue,
                  loadedText: "加载完成",
                  loadFailedText: "加载失败",
                  loadReadyText: "上拉加载中。。",
                  showInfo: true,
                ),
                onLoad: () async{
                  page++;
                  await _getRecordList(selected);
                },
                onRefresh: () async {     
                  _refresh();
                },    
                child: content(),
              ),
            ),
          ],
        ),
    );
  }
  //刷新
  _refresh() async{
    DateTime today = DateTime.now();
    int year = today.year;
    int month = today.month;
    int day = today.day;
    DateTime beginDay = DateTime(year, month, day);
    var formData = {
      'begin': formatDate(beginDay, [yyyy, "-", mm, "-", dd, " ", HH, ":", nn]),
      'over': formatDate(DateTime.now(), [yyyy, "-", mm, "-", dd, " ", HH, ":", nn]),
      'page': 1,
      'size': page*5,
      'spotId': Provider.of<SpotProvider>(context, listen: false).selectedSpot.spotId,
      'state': null
    };
    //电流
    if(selected == 0) {
      await request(servicePath['getRecordElecList'], formData: formData).then((val) {              
        setState(() {                       
          List<RecordElecModel> l = RecordElecListModel.fromJson(val['list']).data;
          list.clear();
          list.addAll(l);               
        });              
      });    
    } else {
      await request(servicePath['getRecordTempList'], formData: formData).then((val) {       
          setState(() {                              
            List<RecordTempModel> l = RecordTempListModel.fromJson(val['list']).data;
            list.clear(); 
            list.addAll(l);
          });
        });
    }
    
  }
  Widget row1() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          RaisedButton(
            padding: EdgeInsets.all(5),
            child: Text("电流设备", style: TextStyle(color: selected==0? Colors.white: Colors.black54),),
            color: selected==0? Colors.blue: Colors.white,
            onPressed: () {
              if(selected != 0) {           
                if(mounted) {        
                  setState(() {
                    page = 1;
                    list.clear();
                    selected = 0;
                    _getRecordList(0);
                  });
                }
              }
            },
          ),
          RaisedButton(
            padding: EdgeInsets.all(5),
            child: Text("测温设备", style: TextStyle(color: selected==1? Colors.white: Colors.black54),),
            color: selected==1? Colors.blue: Colors.white,
            onPressed: () {
              if(selected != 1) {
                if(mounted) {
                  setState(() {
                    page = 1;
                    list.clear();
                    selected = 1;
                    _getRecordList(1);
                  });
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget item(var val) {
    if(selected == 0) {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.all(5),
        child: Slidable(
          actionPane: SlidableScrollActionPane(),   //滑出选项面板 动画
          actionExtentRatio: 0.25,
          child: Column(
            children: <Widget>[
              //第一部分
              InkWell(
                onTap: (){
                  show(context, val.foreSpotDetail);
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(750),
                      child:  Row(children: <Widget>[
                        Icon(Icons.access_time, size: 25,color: Colors.red,),
                        Text(" "+formatDate(val.recordTime, [yyyy, "年", mm, "月", "dd", "日", HH, ":", nn, ":", ss]),
                        style: TextStyle(fontSize: ScreenUtil().setSp(30))      
                        ),
                        Container(
                          width: ScreenUtil().setWidth(300),
                          alignment: Alignment.centerRight,
                          child: Text("漏电流达到"+val.recordVal.toString()+'mA',
                            style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.red)),
                        ),
                    ],),
                    ),  
                    Row(children: <Widget>[
                      Icon(Icons.near_me, size: 25,color: Colors.red,),
                      Text(" "+local+val.foreSpotDetail,
                        style: TextStyle(fontSize: ScreenUtil().setSp(27),color: Colors.grey) ),             
                    ],),         
                  ],
                ),
              ),
              //分割线
              Divider(height: 1,color: Colors.grey,),
              //第二部分
              InkWell(
                onTap: (){
                  callMe(context, val.elecPhone??'');
                },
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.reorder, size: 25,color: Colors.indigo,),
                        Container(width: ScreenUtil().setWidth(5),),
                        Text("设备编号:",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                        Container(width: ScreenUtil().setWidth(5),),
                        Text(val.foreElecId??'',
                          style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.grey),),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.category,size: 25,color: Colors.orange,),
                        Container(width: ScreenUtil().setWidth(5),),
                        Text("设备类型:",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                        Container(width: ScreenUtil().setWidth(5),),
                        Text(selected == 0? "剩余电流监测器":"温度检测器",
                          style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.grey),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.menu,size: 25,color: Colors.blueAccent,),
                        Container(width: ScreenUtil().setWidth(5),),
                        Text("设备名称:",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                        Container(width: ScreenUtil().setWidth(5),),
                        Text(val.foreElecName??'',
                          style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.grey),),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.contact_phone,size: 25,color: Colors.purple,),
                        Container(width: ScreenUtil().setWidth(5),),
                        Text("联系人员:",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                        Container(width: ScreenUtil().setWidth(5),),     
                        Text(val.elecLinkman??'',
                          style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.grey),),                   
                      ],
                    ),        
                  ],
                ),
              ),                       
            ],  
          ),
          secondaryActions: val.recordState == '1'?<Widget>[
              IconSlideAction(
                caption: '已处理',
                color: Colors.blue,
                icon: Icons.book,
                onTap: () async{
                  if(mounted) {
                    setState(() {
                      val.recordState = '0';
                    });
                  }
                 
                  await dispose(0, val.recordElecId);         
                },
              ),     
            ]:<Widget>[
              IconSlideAction(
                caption: '删除',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () async{
                  if(mounted) {
                    setState(() {
                      list.remove(val);
                    });
                  }
                  
                  await delete(0, val.recordElecId);         
                },
              ),
            ]
        ),
      );
    } else {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.all(5),
        child: Slidable(
          actionPane: SlidableScrollActionPane(),   //滑出选项面板 动画
          actionExtentRatio: 0.25,
          child: Column(
            children: <Widget>[
              //第一部分
              InkWell(
                onTap: (){
                  show(context, val.foreSpotDetail);
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(750),
                      child:  Row(children: <Widget>[
                        Icon(Icons.access_time, size: 25,color: Colors.red,),
                        Text(" "+formatDate(val.recordTime, [yyyy, "年", mm, "月", "dd", "日", HH, ":", nn, ":", ss]),
                        style: TextStyle(fontSize: ScreenUtil().setSp(30))      
                        ),
                        Container(
                          width: ScreenUtil().setWidth(300),
                          alignment: Alignment.centerRight,
                          child: Text("温度达到"+val.recordVal.toString()+'℃',
                            style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.red)),
                        ),
                    ],),
                    ),  
                    Row(children: <Widget>[
                      Icon(Icons.near_me, size: 25,color: Colors.red,),
                      Text(" "+local+val.foreSpotDetail,
                        style: TextStyle(fontSize: ScreenUtil().setSp(27),color: Colors.grey) ),             
                    ],),         
                  ],
                ),
              ),
              //分割线
              Divider(height: 1,color: Colors.grey,),
              //第二部分
              InkWell(
                onTap: (){
                  callMe(context, val.tempPhone);
                },
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.reorder, size: 25,color: Colors.indigo,),
                        Container(width: ScreenUtil().setWidth(5),),
                        Text("设备编号:",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                        Container(width: ScreenUtil().setWidth(5),),
                        Text(val.foreTempId,
                          style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.grey),),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.category,size: 25,color: Colors.orange,),
                        Container(width: ScreenUtil().setWidth(5),),
                        Text("设备类型:",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                        Container(width: ScreenUtil().setWidth(5),),
                        Text(selected == 0? "剩余电流监测器":"温度检测器",
                          style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.grey),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.menu,size: 25,color: Colors.blueAccent,),
                        Container(width: ScreenUtil().setWidth(5),),
                        Text("设备名称:",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                        Container(width: ScreenUtil().setWidth(5),),
                        Text(val.foreTempName,
                          style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.grey),),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.contact_phone,size: 25,color: Colors.purple,),
                        Container(width: ScreenUtil().setWidth(5),),
                        Text("联系人员:",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                        Container(width: ScreenUtil().setWidth(5),),     
                        Text(val.tempLinkman,
                          style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.grey),),                   
                      ],
                    ),        
                  ],
                ),
              ),                       
            ],  
          ),
          secondaryActions: val.recordState == '1'?<Widget>[
              IconSlideAction(
                caption: '已处理',
                color: Colors.blue,
                icon: Icons.book,
                onTap: () async{
                  if(mounted) {
                    setState(() {
                      val.recordState = '0';
                    });
                  }
                  
                  await dispose(1, val.recordTempId);         
                },
              ),     
            ]:<Widget>[
              IconSlideAction(
                caption: '删除',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () async{
                  if(mounted) {
                    setState(() {
                      list.remove(val);
                    });
                  }
                 
                  await delete(1, val.recordTempId);         
                },
              ),
            ]
        ),
      );
    }
  }
  Widget content() {
    List<Widget> l;
    if(list.length == 0) {
      return Container(
        alignment: Alignment.center,
        child: Text("没有报警记录哦"),
      );
    } else {
      //遍历list
      l = list.map((val) {
        return Column(
          children: <Widget>[
            item(val),
            Container(padding: EdgeInsets.all(8),)
          ],
        );
      }).toList();
      return ListView(
      
      children: l,
       padding: EdgeInsets.only(bottom:1.0),
    );
    }
  }
}