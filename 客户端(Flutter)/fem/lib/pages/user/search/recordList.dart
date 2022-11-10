import 'dart:math';
import 'package:fem/pages/user/search/dispose.dart';
import 'package:fem/config/service_url.dart';
import 'package:fem/model/RecordElec.dart';
import 'package:fem/model/RecordTemp.dart';
import 'package:fem/provider/RecordProvider.dart';
import 'package:fem/routes/application.dart';
import 'package:fem/service/service_method.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fem/pages/user/search/selectTime.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fem/provider/SpotProvider.dart';
class RecordList extends StatefulWidget {
  final int type;
  final String state;
  RecordList(this.type, this.state);
  @override
  _RecordListState createState() => _RecordListState();
}
class _RecordListState extends State<RecordList> {
  
  String local = '';
  DateTime initBegin;
  DateTime initOver;
  int page = 1;
  EasyRefreshController _controller = EasyRefreshController();
  
  
  List<RecordElecModel> reElecList = [];
  List<RecordTempModel> reTempList = [];
  //加载数据
  _getRecordList(int type) async{     
    if(Provider.of<SpotProvider>(context, listen: false).selectedSpot != null) {
      DateTime beginTime = Provider.of<RecordProvider>(context, listen: false).beginTime;
      String begin = formatDate(beginTime, [yyyy, "-", mm, "-", dd, " ", HH, ":", nn]);
      DateTime overTime = Provider.of<RecordProvider>(context, listen: false).overTime;
      String over = formatDate(overTime, [yyyy, "-", mm, "-", dd, " ", HH, ":", nn]);
      var formData = {
        'begin': begin,
        'over': over,
        'page': page,
        'size': 5,
        'spotId': Provider.of<SpotProvider>(context, listen: false).selectedSpot.spotId,
        'state': widget.state
      };
      if(type == 0) {
        await request(servicePath['getRecordElecList'], formData: formData).then((val) {
          if(val != null) {
            if(page > val['pages']) {
              page --;
              _controller.finishLoad(success: true, noMore: true);
            
            } else {        
                setState(() {                
                  List<RecordElecModel> l = RecordElecListModel.fromJson(val['list']).data;
                  reElecList.addAll(l);           
            });
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
              setState(() {
                List<RecordTempModel> l = RecordTempListModel.fromJson(val['list']).data;
                reTempList.addAll(l);
              });
            }
          }
        });
      }
    }
  
}

  //刷新
  _refreshList(int type) async {
    if(Provider.of<SpotProvider>(context, listen: false).selectedSpot != null) {
      DateTime beginTime = Provider.of<RecordProvider>(context, listen: false).beginTime;
      String begin = formatDate(beginTime, [yyyy, "-", mm, "-", dd, " ", HH, ":", nn]);
      DateTime overTime = Provider.of<RecordProvider>(context, listen: false).overTime;
      String over = formatDate(overTime, [yyyy, "-", mm, "-", dd, " ", HH, ":", nn]);
      if(type == 0) {
        if(beginTime != initBegin || overTime != initOver) {
          initBegin = beginTime;
          initOver = overTime;
          setState(() {
            _controller.resetLoadState();
            reElecList.clear();
            page = 1;
            _getRecordList(0);
          });
        } else {
          var formData = {
          'begin': begin,
          'over': over,
          'page': 1,
          'size': page*5,
          'spotId': Provider.of<SpotProvider>(context, listen: false).selectedSpot.spotId,
          'state': widget.state
          };
          await request(servicePath['getRecordElecList'], formData: formData).then((val) {              
            setState(() {                       
              List<RecordElecModel> l = RecordElecListModel.fromJson(val['list']).data;
              reElecList.clear();
              reElecList.addAll(l);               
            });              
          });           
        } 
      } else if(type == 1){
        if(beginTime != initBegin || overTime != initOver) {
          initBegin = beginTime;
          initOver = overTime;
          setState(() {
            _controller.resetLoadState();
            reTempList.clear();
            page = 1;
            _getRecordList(1);
          });        
        } else {
          var formData = {
          'begin': begin,
          'over': over,
          'page': 1,
          'size': page*5,
          'spotId': Provider.of<SpotProvider>(context, listen: false).selectedSpot.spotId,
          'state': widget.state
          };
          await request(servicePath['getRecordTempList'], formData: formData).then((val) {       
            setState(() {                              
              List<RecordTempModel> l = RecordTempListModel.fromJson(val['list']).data;
              reTempList.clear(); 
              reTempList.addAll(l);
            });
          });

        }
      }
    }
    
  }
@override
  void initState() {
  initBegin = Provider.of<RecordProvider>(context, listen: false).beginTime;
  initOver = Provider.of<RecordProvider>(context, listen: false).overTime;
  super.initState();
  _getRecordList(widget.type);
  }
  @override
  
  @override
  Widget build(BuildContext context) {
    if(Provider.of<RecordProvider>(context, listen: true).overTime != initOver) {
      _controller.callRefresh();
    }
    Text _title;
    if(widget.type == 0) {
      if(widget.state == '0') {
        _title = Text('已处理记录',style: TextStyle(fontSize: ScreenUtil().setSp(35)),);
      } else {
        _title = Text('电流报警',style: TextStyle(fontSize: ScreenUtil().setSp(40)),);
      } 
    } else {
      if(widget.state == '0') {
        _title = Text('已处理记录',style: TextStyle(fontSize: ScreenUtil().setSp(35)),);
      } else {
         _title = Text('测温报警',style: TextStyle(fontSize: ScreenUtil().setSp(40)),);
      }
    }
    if(mounted) {
      setState(() {
        local = Provider.of<SpotProvider>(context, listen: true).local;
      });
    }
    
    return Scaffold(      
      drawerDragStartBehavior: DragStartBehavior.start,
      endDrawer: Drawer(
        child: TimePickerPage(),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.orange,
        title: _title,
        // actions: <Widget>[
        //  TimePickerPage()          
        // ],
      ),
      body: Container(      
        color: Color.fromARGB(230, 250, 255, 250),
        child:  EasyRefresh(
          controller: _controller,       
          header: ClassicalHeader(             
            refreshedText: "刷新完成",
            refreshingText: "刷新中",
            refreshText: "刷新",
            refreshReadyText: "上拉刷新"
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
            await _getRecordList(widget.type);
          },
          onRefresh: () async {     
            _refreshList(widget.type);
          },         
          child:  reList(widget.type)
          ),
      ),
    );
  }
  Widget reList(int type) {
  
  List<Widget> l;
    if(type == 0) {
      if(reElecList == null) {
        return Center(child: Text("数据加载。。。"),);
      }
      l = reElecList.map((val) {
      return Column(
        children: <Widget>[
          reElec(val),
          Container(padding: EdgeInsets.all(8),)
        ],
      );
    }).toList();
    } else if(type == 1) {
       if(reTempList == null) {
        return Center(child: Text("数据加载。。。"),);
      }
       l = reTempList.map((val) {
      return Column(
        children: <Widget>[
          reTemp(val),
          Container(padding: EdgeInsets.all(8),)
        ],
      );
    }).toList();
    }
    return ListView(
      children: l,
       padding: EdgeInsets.only(bottom:1.0),
    );

  
}

Widget reElec(RecordElecModel reElec) {
  
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
                show(context, reElec.foreSpotDetail);
              },
              child: Column(
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(750),
                    child:  Row(children: <Widget>[
                      Icon(Icons.access_time, size: 25,color: Colors.red,),
                      Text(" "+formatDate(reElec.recordTime, [yyyy, "年", mm, "月", "dd", "日", HH, ":", nn, ":", ss]),
                      style: TextStyle(fontSize: ScreenUtil().setSp(30))      
                      ),
                      Container(
                        width: ScreenUtil().setWidth(300),
                        alignment: Alignment.centerRight,
                        child: Text("漏电流达到"+reElec.recordVal.toString()+'mA',
                          style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.red)),
                      ),
                  ],),
                  ),  
                  Row(children: <Widget>[
                    Icon(Icons.near_me, size: 25,color: Colors.red,),
                    Text(" "+local+reElec.foreSpotDetail,
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
                callMe(context, reElec.elecPhone??'');
              },
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.reorder, size: 25,color: Colors.indigo,),
                      Container(width: ScreenUtil().setWidth(5),),
                      Text("设备编号:",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                      Container(width: ScreenUtil().setWidth(5),),
                      Text(reElec.foreElecId??'',
                        style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.grey),),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.category,size: 25,color: Colors.orange,),
                      Container(width: ScreenUtil().setWidth(5),),
                      Text("设备类型:",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                      Container(width: ScreenUtil().setWidth(5),),
                      Text(widget.type == 0? "剩余电流监测器":"温度检测器",
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
                      Text(reElec.foreElecName??'',
                        style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.grey),),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.contact_phone,size: 25,color: Colors.purple,),
                      Container(width: ScreenUtil().setWidth(5),),
                      Text("联系人员:",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                      Container(width: ScreenUtil().setWidth(5),),     
                      Text(reElec.elecLinkman??'',
                        style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.grey),),                   
                    ],
                  ),        
                ],
              ),
            ),                       
          ],  
        ) ,
      secondaryActions: widget.state == '1'?<Widget>[
      IconSlideAction(
        caption: '已处理',
        color: Colors.blue,
        icon: Icons.book,
        onTap: () async{
          setState(() {
            reElecList.remove(reElec);
          });
          await dispose(0, reElec.recordElecId);         
        },
      ),
    ]:<Widget>[
       IconSlideAction(
        caption: '删除',
        color: Colors.red,
        icon: Icons.delete,
        onTap: () async{
          setState(() {
            reElecList.remove(reElec);
          });
          await delete(0, reElec.recordElecId);         
        },
      ),
    ]
    ),
  );
   
}

Widget reTemp(RecordTempModel reTemp) {
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
              show(context, reTemp.foreSpotDetail??'');
            },
            child: Column(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(750),
                  child:  Row(children: <Widget>[
                    Icon(Icons.access_time, size: 25,color: Colors.red,),
                    Text(" "+formatDate(reTemp.recordTime, [yyyy, "年", mm, "月", "dd", "日", HH, ":", nn, ":", ss]),
                    style: TextStyle(fontSize: ScreenUtil().setSp(30))      
                    ),
                    Container(
                      width: ScreenUtil().setWidth(300),
                      alignment: Alignment.centerRight,
                      child: Text("温度达到"+reTemp.recordVal.toString()+'℃',
                        style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.red)),
                    ),
                ],),
                ),  
                Row(children: <Widget>[
                  Icon(Icons.near_me, size: 25,color: Colors.red,),
                  Text(" "+local+reTemp.foreSpotDetail,
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
              callMe(context, reTemp.tempPhone??'');
            },
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.reorder, size: 25,color: Colors.indigo,),
                    Container(width: ScreenUtil().setWidth(5),),
                    Text("设备编号:",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                    Container(width: ScreenUtil().setWidth(5),),
                    Text(reTemp.foreTempId??'',
                      style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.grey),),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.category,size: 25,color: Colors.orange,),
                    Container(width: ScreenUtil().setWidth(5),),
                    Text("设备类型:",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                    Container(width: ScreenUtil().setWidth(5),),
                    Text(widget.type == 0? "剩余电流监测器":"温度检测器",
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
                    Text(reTemp.foreTempName??'',
                      style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.grey),),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.contact_phone,size: 25,color: Colors.purple,),
                    Container(width: ScreenUtil().setWidth(5),),
                    Text("联系人员:",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                    Container(width: ScreenUtil().setWidth(5),),     
                    Text(reTemp.tempLinkman??'',
                      style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.grey),),                   
                  ],
                ),        
              ],
            ),
          ),                       
        ],  
      ),
    secondaryActions: widget.state == '1'?<Widget>[
      IconSlideAction(
        caption: '已处理',
        color: Colors.blue,
        icon: Icons.book,
        onTap: () async{
          setState(() {
            reTempList.remove(reTemp);
          });
          await dispose(1, reTemp.recordTempId);
        },
      ),
      
    ]: <Widget>[
        IconSlideAction(
        caption: '删除',
        color: Colors.red,
        icon: Icons.delete,
        onTap: () async{
          setState(() {
            reTempList.remove(reTemp);
          });
          await delete(1, reTemp.recordTempId);
        },
      ),
    ]
  ));
}

 
}



