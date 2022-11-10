import 'package:fem/pages/admin/admin_managePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fem/pages/admin/admin_homePage.dart';


import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminIndexPage extends StatefulWidget {
  final String userId;
  AdminIndexPage(this.userId);
  @override
  _AdminIndexPageState createState() => _AdminIndexPageState();
}

class _AdminIndexPageState extends State<AdminIndexPage> {
   //底部导航栏list
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.home),
      title: Text("首页")
    ),
     BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.profile_circled),
      title: Text("我的")
    ),
  ];

  //导航栏实际界面list
  final List<Widget> tabBodies = [
    AdminHomePage(),
    AdminManagePage()
  ];

   //定义界面索引变量
  int currentIndex = 0;
  //定义界面主体变量
  var currentPage;

  @override
  void initState() {
    currentPage = tabBodies[currentIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  // ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
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