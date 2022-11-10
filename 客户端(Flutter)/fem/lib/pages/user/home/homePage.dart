import 'package:fem/pages/user/home/HomeDetailPage.dart';
import 'package:fem/pages/user/home/HomeOutlinePage.dart';
import 'package:fem/pages/user/home/dropdown.dart';
import 'package:fem/pages/user/home/pieChart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fem/provider/UserProvider.dart';
import 'package:fem/provider/SpotProvider.dart';
import 'package:provider/provider.dart';
import 'package:fem/config/service_url.dart';
import '../../../model/Spot.dart';
import 'package:fem/service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../provider/ElecProvider.dart';
import 'package:fem/provider/TempProvider.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

//SingleTickerProviderStateMixin混入是为了使用tabbar
class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    
    _tabController = TabController(vsync: this,length: 2,);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(ScreenUtil().setHeight(250)),
        child: Container(
          
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage('lib/images/flutter1.jpg'),
              fit: BoxFit.cover
            ),
          ),
          child: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            centerTitle: true,
            bottomOpacity: 1,
            elevation: 0, 
            title: Text("我的设备",style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(50)),),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(200),     
              child: _tabBar(),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          HomeOutlinePage(),
          HomeDetailPage()
        ],
      ),
        
        // body: FutureBuilder(
        //   future: _getSpotList(),
        //   initialData: "正在加载。。",
        //   builder: (context, snapshot) {
        //     if(snapshot.connectionState == ConnectionState.waiting) {
        //       return Center(child:Text("加载中"));
        //     } else if(snapshot.connectionState == ConnectionState.done) {
        //       return Container(
        //         decoration: BoxDecoration(
        //             image: DecorationImage(
        //               image: AssetImage('lib/images/app.jpg'),
        //               fit: BoxFit.cover,
        //             )
                    
        //           ),
        //         child: EasyRefresh(
        //          header: ClassicalHeader(             
        //         refreshedText: "刷新完成",
        //         refreshingText: "刷新中",
        //         refreshText: "刷新",
        //         refreshReadyText: "上拉刷新"
        //    ),
        //         onRefresh: () async {               
        //         await Provider.of<ElecProvider>(context, listen: false).setStateList(context);
        //         await Provider.of<TempProvider>(context, listen: false).setStateList(context);
        //         },
              
                  
        //           child: ListView(
        //           children: <Widget>[

        //             Text("欢迎您！" + Provider.of<UserProvider>(context, listen: true).user.userName,
        //             style: TextStyle(color: Colors.pink,fontSize: ScreenUtil().setSp(40)),textAlign: TextAlign.center),
        //             Text("请选择项目",style: TextStyle(color: Colors.blue,fontSize: ScreenUtil().setSp(40)),textAlign: TextAlign.center),
        //             Dropdown(),
                    
        //             Image.asset('lib/images/gate.jpeg',height: ScreenUtil().setHeight(350),fit: BoxFit.fill,),
        //             MyPieChart(),
        //             Text("剩余电流式监控器",style: TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(40)),textAlign: TextAlign.center,),
                  
        //             Over(0),
        //            Text("测温式监控器",style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(40)),textAlign: TextAlign.center),
        //            Over2(0),
              
        //     ],
          
        //         )
                
        // ),
        //       );
              
        //     }
        //   },
        // ),
        
    );
  }

  //顶部导航栏tabbar
  TabBar _tabBar() {
    return TabBar(
      indicatorSize: TabBarIndicatorSize.tab,
      controller: _tabController,
      tabs: <Widget>[
        Tab(
          child: Column(
            children: <Widget>[
              Icon(Icons.apps),            
              Text("概要", style: TextStyle(color: Colors.black),),
            ],
          ),
        ),
        Tab(
          child: Column(
            children: <Widget>[
              Icon(Icons.assignment),            
              Text("详细", style: TextStyle(color: Colors.black),),         
            ],
          ),
        )
      ],
    );
  }
}
