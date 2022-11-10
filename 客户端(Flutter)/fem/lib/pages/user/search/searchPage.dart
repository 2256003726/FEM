import 'package:fem/pages/user/search/outlinePage.dart';
import 'package:fem/pages/user/search/recordPage.dart';
import 'package:fem/pages/user/search/todayPage.dart';
import 'package:fem/routes/application.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin{
  TextStyle _barStyle = TextStyle(
    //fontSize: ScreenUtil().setSp(10),
    //fontWeight: FontWeight.bold,
    //color: Colors.blac
  );
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this,length: 3,);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(ScreenUtil().setHeight(250)),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/images/appbar.jpg'),
              fit: BoxFit.cover
            )
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,     
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text("我的消息"),   
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(200),          
              child: _tabBar(),          
          ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.insert_chart, size: 30, color: Colors.orange,),
            onPressed: () {
              Application.router.navigateTo(context, "/myChart");
            }
          )
        ],
        
      ),
        )
        
        )
      ,
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          OutlinePage(),
          TodayPage(),
          RecordCard(),
        ],
      ),
      // body: ListView(
      //   children: <Widget>[
      //     RecordCard(),
      //   ],
      // ),
    );
  }

  TabBar _tabBar() {
    return TabBar(
      indicatorSize: TabBarIndicatorSize.tab,
      controller: _tabController,  // 记得要带上tabController
      tabs: <Widget>[
      
      Tab(
        child: Column(
          children: <Widget>[
            Icon(Icons.apps),            
            Text("概要", style: _barStyle,),
          ],
        ),
      ),
      Tab(
        child: Column(
          children: <Widget>[
            Icon(Icons.today),
            Text("今日", style: _barStyle,)
          ],
        ),
      ),
      Tab(
        child: Column(
          children: <Widget>[
            Icon(Icons.assignment),
            Text("详细", style: _barStyle,)
          ],
        ),
      ),
    ],
    );
  }
}