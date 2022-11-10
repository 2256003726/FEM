import 'package:fem/config/service_url.dart';
import 'package:fem/model/Spot.dart';
import 'package:fem/routes/application.dart';
import 'package:fem/service/service_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:fem/provider/SpotProvider.dart';
import 'package:fem/provider/UserProvider.dart';
class SpotPage extends StatefulWidget {
  @override
  _SpotPageState createState() => _SpotPageState();
}

class _SpotPageState extends State<SpotPage> {
  //spotList
  List<SpotModel> spotList = List<SpotModel>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Application.router.navigateTo(context, "/addSpot").then((result) async{
                if(result == 'yes') {
                  //重新获取spotList
                  var formData = {
                    'userId': Provider.of<UserProvider>(context, listen: false).user.userId
                  };                
                  await request(servicePath['getSpotList'], parms: formData).then((val) {
                    if(val != null) {
                      SpotListModel model = SpotListModel.fromJson(val);
                      Provider.of<SpotProvider>(context, listen: false).setSpotList(model.data);
                      if(mounted) {
                        setState(() {
                          spotList = Provider.of<SpotProvider>(context, listen: false).spotList;
                        });
                      }
                    }
                  });
                }
              });
            },
          ),
        ],
        title: Text("我的项目"),
        centerTitle: true,
      ),
      body: Container(
        child: _spotList(),
      )
    );
  }

  @override
  void initState() { 
    super.initState();
    spotList = Provider.of<SpotProvider>(context, listen: false).spotList;
  }
  Widget _spotList() {
    if(spotList.length == 0) {
      return Container(
        child: Text("您还没有任何项目哦"),
      );
    }
    //遍历spotList，转换成一个个小卡片
    List<Widget> spotViewList = spotList.map((val) {
      return Container(
        child:Slidable(
          actionPane: SlidableScrollActionPane(),   //滑出选项面板 动画
          actionExtentRatio: 0.25,
          child: Card(
            child: Column(
              children: <Widget>[
                //第一行，标题
                Row(
                  children: <Widget>[
                    Icon(Icons.near_me, color: Colors.blue, size: 30,),
                    Padding(padding: EdgeInsets.only(left:5),),
                    Container(
                      width: ScreenUtil().setWidth(650),
                      child: Text(val.spotName??'', style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(40)),overflow: TextOverflow.ellipsis,),
                    )
                    
                  ],
                ),
                //分割线
                Divider(color: Colors.grey, height: 1,),
                //第二部分--详细地址
                Column(
                  children: <Widget>[
                    Row(children: <Widget>[
                      Icon(Icons.map, color: Colors.orange, size: 25,),
                      Padding(padding: EdgeInsets.only(left:5),),
                      Text(val.spotState??'', style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(30)),),
                    ],),
                    Row(children: <Widget>[
                      Icon(Icons.location_city, color: Colors.yellow, size: 25,),
                      Padding(padding: EdgeInsets.only(left:5),),
                      Text(val.spotCity, style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(30)),),
                    ],),
                    Row(children: <Widget>[
                      Icon(Icons.person_pin_circle, color: Colors.pink, size: 25,),
                      Padding(padding: EdgeInsets.only(left:5),),
                      Text(val.spotCounty??'', style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(30)),),
                    ],),
                    
                  ],
                ),
              ],
            ),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: '编辑',
              color: Colors.blue,
              icon: Icons.edit,
              onTap: () {
                String id = val.spotId.toString();
                Application.router.navigateTo(context, "/alertSpot?spotId=${id}").then((result) async{
                  if(result == 'yes') {
                    //重新获取spotList
                    var formData = {
                      'userId': Provider.of<UserProvider>(context, listen: false).user.userId
                    };                
                    await request(servicePath['getSpotList'], parms: formData).then((value) {
                      if(value != null) {
                        SpotListModel model = SpotListModel.fromJson(value);
                        Provider.of<SpotProvider>(context, listen: false).setSpotList(model.data);
                        setState(() {
                          spotList = Provider.of<SpotProvider>(context, listen: false).spotList;
                        });
                        
                      }
                    });
                  }
                });
                
              },
            ),
            IconSlideAction(
              caption: '移除项目',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () async{
                
                await _myDialog(val.spotId);
              },
            ),
          ],
        )
        
      );
    }).toList();
    return ListView(
      children: spotViewList,
    );

  }

  _deleteSpot(int spotId) async{
    var formData = {
      'userId': Provider.of<UserProvider>(context, listen: false).user.userId,
      'spotId': spotId
    };
    await request(servicePath['removeSpot'], formData: formData).then((val) async{
      
      if(val == true) {
        setState(() {
          spotList.remove(val);
        });
        //重新获取spotList
          var formData = {
            'userId': Provider.of<UserProvider>(context, listen: false).user.userId
          };                
          await request(servicePath['getSpotList'], parms: formData).then((val) {
            if(val != null) {
              SpotListModel model = SpotListModel.fromJson(val);
              Provider.of<SpotProvider>(context, listen: false).setSpotList(model.data);
              if(mounted) {
                setState(() {
                  spotList = Provider.of<SpotProvider>(context, listen: false).spotList;
                });
              }
            }
          });
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: "移除项目成功！",
          gravity: ToastGravity.CENTER
        );
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: "移除失败！",
          gravity: ToastGravity.CENTER
        );
      }
    });
  }

  _myDialog(int spotId) {
    showDialog(
      
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("移除项目"),
          content: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Align(
                child: Text('确定移除？'),
                alignment: Alignment(0, 0),
              ),
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("取消"),
              onPressed: () {
                Navigator.pop(context);
                
              },
            ),
            CupertinoDialogAction(
              child: Text("确定"),
              onPressed: () async{
                
                await _deleteSpot(spotId);
               
              },
            ),
          ],
        );
       
      }
    );
  }
}

