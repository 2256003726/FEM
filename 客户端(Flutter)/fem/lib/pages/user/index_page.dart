
import 'package:fem/pages/user/my/myPage.dart';
import 'package:fem/pages/user/search/myChart.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fem/pages/user/home/homePage.dart';
import 'package:fem/pages/user/search/searchPage.dart';
class UserIndexPage extends StatefulWidget {
  final String userId;
  UserIndexPage(this.userId);
  @override
  _UserIndexPageState createState() => _UserIndexPageState();
}
class _UserIndexPageState extends State<UserIndexPage> {
  
  //底部导航栏list
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.home),
      title: Text("设备")
    ),
     BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.mail),
      title: Text("消息")
    ),
     BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.profile_circled),
      title: Text("我的")
    ),
    // BottomNavigationBarItem(
    //   icon: Icon(CupertinoIcons.profile_circled),
    //   title: Text("测试")
    // ),
  ];

  //导航栏实际界面list
  final List<Widget> tabBodies = [
    HomePage(),
    SearchPage(),
    MyPage(),

  ];

  //定义界面索引变量
  int currentIndex = 0;
  //定义界面主体变量
  var currentPage;

  @override
  void initState() {
    //_getSpotList();
    currentPage = tabBodies[currentIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  //  _getSpotList();
    
    return Scaffold(
       backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
       bottomNavigationBar: BottomNavigationBar(
         type: BottomNavigationBarType.fixed,
         currentIndex: currentIndex,
         items: bottomTabs,
         //点击切换
         onTap: (index) {
           setState(() {
             currentIndex = index;
             currentPage = tabBodies[currentIndex];         
           });
         },
         
       ),
      body: IndexedStack(

        index: currentIndex,
        children: tabBodies
      ),
    );
  }
}