
import 'package:fem/model/Temperature.dart';
import 'package:fem/service/service_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fem/provider/SpotProvider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../routes/application.dart';
import '../../../config/service_url.dart';
import 'package:fem/provider/TempProvider.dart';

class TempList extends StatefulWidget {
  final String state;
  TempList(this.state);
  @override
  _TempListState createState() => _TempListState();
}

class _TempListState extends State<TempList> {
  String local = '';
  int page = 1;
  List<TempModel> list = [];
  EasyRefreshController _controller = EasyRefreshController();
  TextEditingController _searchController = TextEditingController();
  String searchName = '';
  //点击空白收起键盘
  FocusNode blankNode = FocusNode();
  @override
  void initState() { 
    super.initState();
   
   _getList();
  }
  //获取数据
  _getList() async{
    var formData = {
      'curPage': page,
      'state': widget.state,
      'spotId': Provider.of<SpotProvider>(context, listen: false).selectedSpot.spotId,
      'size': 5,
      'name': searchName
    };
    await request(servicePath['getTemp'], formData: formData).then((val) {  
     
      if(page > val['pages']) {
          page --;
      } else {
        List json = (val['list'] as List).cast();      
        List<TempModel> e = TempListModel.fromJson(json).data;
        setState(() {     
        this.list.addAll(e);
        });
      }
      
    });
    
  }
  @override
  Widget build(BuildContext context) {
    if(mounted) {
      setState(() {
        local = Provider.of<SpotProvider>(context, listen: true).local;
      });
    }
    return Scaffold(
       appBar: AppBar(
         backgroundColor: Colors.indigo,
         centerTitle: true,
         title: Text("测温设备列表"),
         actions: widget.state == '4'? <Widget>[
           IconButton(
             icon: Icon(Icons.add),
             onPressed: (){
               String type = "1";
               Application.router.navigateTo(context, "/addEqu?type=${type}").then((result) {
                 if(result == 'yes') {
                   Provider.of<TempProvider>(context,listen: false).setStateList(context);
                 }
                 _controller.resetLoadState();
               });
             },
           )
         ]:null
         ),
       body: GestureDetector(
         //拖拽取消键盘
          onVerticalDragDown: (context1){
            FocusScope.of(context).requestFocus(blankNode);
          },
          //点击取消键盘
          onTap: () {
            FocusScope.of(context).requestFocus(blankNode);
           },
           child: Stack(
             children: <Widget>[
               Positioned(
              top: 0,
              left: 0,               
              child: _searchText(),
             ),
              Container(
                padding: EdgeInsets.only(top:50),
                child: EasyRefresh(
                  controller: _controller,
                  child: _tempList(),
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
                  onLoad: () async {
                    page++;
                    await _getList();
                  },
                  onRefresh: ()async{
                    var formData = {
                        'curPage': 1,
                        'state': widget.state,
                        'spotId': Provider.of<SpotProvider>(context, listen: false).selectedSpot.spotId,
                        'size': page*5,
                        'name': searchName
                    };
                      await request(servicePath['getTemp'], formData: formData).then((val) {                       
                        List json = (val['list'] as List).cast();
                        List<TempModel> e = TempListModel.fromJson(json).data;
                        setState(() {     
                          list.clear();
                          this.list.addAll(e);
                        });                      
                    });
                  },
                ),
       ),
             ],
           ),
       ) 
    );
  }

  Widget _searchText() {
    return Container(
      color: Colors.black12,
      padding: EdgeInsets.only(top:5.0,bottom: 5.0,right: 5.0),
          width: ScreenUtil().setWidth(750),
          height: ScreenUtil().setHeight(100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(              
                width: ScreenUtil().setWidth(500),
                child:Card(
                  color: Colors.white,
                  child:TextField(            
                controller: _searchController,
                keyboardType: TextInputType.text,
                
                obscureText: false,
                decoration: InputDecoration(
                  hintText: "输入设备名称",
                  //labelText: "设备",
                ),            
              ),
                ),
              ),
              RaisedButton(
                color: Colors.green,
                child: Text("搜索"),
                onPressed: () {
                  
                  setState(() {
                    _controller.resetLoadState();
                    page = 1;
                    searchName = _searchController.text;
                    list.clear();
                    _getList();
                    
                  });
                },
              )
            ],
          )
    );
}

 Color _getColor(String state) {
    Color c;
    if(state == '0') {
      c = Colors.green;
    } else if(state == '1') {
      c = Colors.orange;
    } else if(state == '2') {
      c = Colors.red; 
    }
    return c;
  }
  Widget _tempList() {
 
  if(list.length != 0) {
    List<Widget> listWidget = list.map((val){
      return Column(
        children: <Widget>[
          Container(
            color: Colors.white,
        padding: EdgeInsets.all(5),
        child: Column(
        children: <Widget>[
          //第一部分
          InkWell(
            onTap: () {
              Application.router.navigateTo(context, "/tempDetail?tempId=${val.tempId}").then((result) {
                if(result != null) {
                  list.remove(val);
                  Provider.of<TempProvider>(context,listen: false).setStateList(context);
                }
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  width: ScreenUtil().setWidth(600),
                  child: Text(val.tempName??'',
                  style: TextStyle(fontSize: ScreenUtil().setSp(40),color: Colors.blue),
                  overflow: TextOverflow.ellipsis,),
                ),
               
                Container(
                  alignment: Alignment.centerRight,
                  width: ScreenUtil().setWidth(100),
                  child: Text(val.tempVal.toString()+'℃',style: TextStyle(
                          color: _getColor(val.tempState),
                          fontSize: ScreenUtil().setSp(30)))
                )
              ],
            ),
          ),
          //分割线
          Divider(height: 1,color: Colors.grey,), 
          //第二部分
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.reorder, size: 25,color: Colors.indigo,),
                  Container(width: ScreenUtil().setWidth(5),),
                  Text("设备编号:",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                  Container(width: ScreenUtil().setWidth(5),),
                  Text(val.tempId??'',
                    style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.grey),),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.category,size: 25,color: Colors.orange,),
                  Container(width: ScreenUtil().setWidth(5),),
                  Text("设备类型:",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                  Container(width: ScreenUtil().setWidth(5),),
                  Text("剩余电流监测器",
                    style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.grey),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.contact_phone,size: 25,color: Colors.purple,),
                  Container(width: ScreenUtil().setWidth(5),),
                  Text("联系人员:",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                  Container(width: ScreenUtil().setWidth(5),),     
                  Text(val.tempLinkman??'',
                    style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.grey),),                   
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.near_me  ,size: 25,color: Colors.blue,),
                  Container(width: ScreenUtil().setWidth(5),),
                  
                  Text("安装位置:",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                  Container(width: ScreenUtil().setWidth(5),),
                  Container(
                    width: ScreenUtil().setWidth(545),
                    child: Text(local+val.tempSpotDetail??'',
                    style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.grey),overflow: TextOverflow.ellipsis),
                  )
                  
                ],
              ),
              //分割线
              Divider(height: 1,color: Colors.grey,), 
              //第三部分，按钮
              Container(
                height: ScreenUtil().setHeight(120),
                alignment: Alignment.centerRight,
                child: RaisedButton(
                  child: Text("监测数据",style: TextStyle(color: Colors.white,
                  fontSize: ScreenUtil().setSp(40)),),
                  color: Colors.blueAccent,
                  onPressed: () {
                    String type = '1';
                    String id = val.tempId;
                    Application.router.navigateTo(context, "/lineChart?type=${type}&id=${id}");
                  },
                ),
              ),
              
            ],
          ), 
        ],
      ),
      ),
      Container(height: ScreenUtil().setHeight(30),)
        ],
      );
      // return ListTile(
      //   onTap: () {
      //     Application.router.navigateTo(context, "/tempDetail?tempId=${val.tempId}").then((result) {
      //       if(result != null) {
      //         list.remove(val);
      //       }
      //     });
      //   },
      //   isThreeLine: false,
      //   leading: Icon(Icons.language,),
      //   title: Text(val.tempName, style: TextStyle(fontSize: ScreenUtil().setSp(35)),),
         
      //   trailing: Icon(Icons.arrow_forward),
      //   subtitle: Container(
      //     child: Row(
      //       children: <Widget>[
      //         Container(
      //            width: ScreenUtil().setWidth(400),
      //           child: Column(
      //            crossAxisAlignment: CrossAxisAlignment.start,
      //           children: <Widget>[
      //             Text("设备ID: "+ val.tempId,style: TextStyle(fontSize: ScreenUtil().setSp(30)),textAlign: TextAlign.left,),
      //             Text("安装地点: " + val.tempSpotDetail,style: TextStyle(fontSize: ScreenUtil().setSp(30)),textAlign: TextAlign.left,)
      //           ],
      //         ),
      //         ),
              
             
      //         //Text("当前值：",style: TextStyle(fontSize: ScreenUtil().setSp(30))),
      //         Text(val.tempVal.toString()+'℃',style: TextStyle(
      //           color: _getColor(val.tempState),
      //           fontSize: ScreenUtil().setSp(30)
      //         )
             
      //         )
      //       ],
      //     ),
      //   ),
      // );
    } ).toList();
    return ListView(
      children: listWidget,
      padding: EdgeInsets.only(bottom:1.0),
      
    );
  } else {
    return Text("没有数据哦");
  }
}
}

