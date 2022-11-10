import 'package:fem/config/service_url.dart';
import 'package:fem/model/User.dart';
import 'package:fem/routes/application.dart';
import 'package:fem/service/service_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int page = 1;
  List<UserModel> list = [];
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('用户列表'),
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
                onRefresh: () async{
                  await _refresh();
                },
                child: _userList(),
              ),
            )
          ],
        ),
      )
      
    );
  }
  //获取数据
  _getList() async {
    var formData = {
      'page': page,
      'size': 5,
      'id': searchName
    };
    await request(servicePath['getUsers'], formData: formData).then((val) {
      if(page > val['pages']) {
         page --;
         _controller.finishLoad(noMore: true,success: true);
        } else {
          List json = (val['list'] as List).cast();
          List<UserModel> e = UserListModel.fromJson(json).data;
          setState(() {     
          this.list.addAll(e);
          });
        }
    });
  }
  //刷新
  _refresh() async {
    var formData = {
      'page': 1,
      'size': 5*page,
      'id': searchName
    };
    await request(servicePath['getUsers'], formData: formData).then((val) {
          List json = (val['list'] as List).cast();
          List<UserModel> e = UserListModel.fromJson(json).data;
          if(mounted) {
            setState(() {     
              list.clear();
              this.list.addAll(e);
            });
          }
          
        
    });
  }
  //搜索框
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
                  hintText: "输入用户名称",
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

  //用户列表
  Widget _userList() {
    if(list.length > 0) {
      List<Widget> listWidget = list.map((val) {
        return  Container(
          child: Card(
            child: Slidable(
              actionPane: SlidableScrollActionPane(),   //滑出选项面板 动画
              actionExtentRatio: 0.25,
              child: InkWell(
                onTap: () {
                  String userId = val.userId;
                  Application.router.navigateTo(context, '/alloSpot?userId=$userId');
                },
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.person, size: 26, color: Colors.blue,),
                        Text(val.userName??'', style: TextStyle(
                          fontSize: ScreenUtil().setSp(35), color: Colors.black
                        ),)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.confirmation_number, size: 26, color: Colors.yellow,),
                        Text(val.userId??'', style: TextStyle(
                          fontSize: ScreenUtil().setSp(35), color: Colors.black
                        ),)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.security, size: 26, color: Colors.blue,),
                        Text(val.userPassword??'', style: TextStyle(
                          fontSize: ScreenUtil().setSp(35), color: Colors.black
                        ),)
                      ],
                    ),
                  ],
                ),
              ),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: '删除',
                  color: Colors.blue,
                  icon: Icons.book,
                  onTap: () async{
                    setState(() {
                      list.remove(val);
                    });
                    //await dispose(1, reTemp.recordTempId);
                  },
                ),
              ],
            ),
          ),
        );
      }).toList();
      return ListView(
        children: listWidget,
      );
    } 
  }
}
