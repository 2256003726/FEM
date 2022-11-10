import 'package:fem/pages/login.dart';
import 'package:fem/provider/RecordProvider.dart';
import 'package:fem/provider/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './routes/application.dart';
import './routes/routers.dart';
import 'package:fluro/fluro.dart';
import 'package:fem/provider/SpotProvider.dart';
import 'package:fem/provider/ElecProvider.dart';
import 'package:fem/provider/TempProvider.dart';
import 'provider/ServiceProvider.dart';
 String justTest = '8888';
 String just2 = justTest + 'k';
void main() {
 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //配置全局路由
    final router = new Router();
    Routes.configureRoutes(router);
    Application.router = router;
    

    
    return MultiProvider(
      providers: [
        //这里是关键注册通知
        ChangeNotifierProvider(create: (_)=>ServiceProvider(),),
         ChangeNotifierProvider(create: (_)=>UserProvider(),),
         ChangeNotifierProvider(create: (_)=>SpotProvider(),),
         ChangeNotifierProvider(create: (_)=>ElecProvider(),),
         ChangeNotifierProvider(create: (_)=>TempProvider(),),
         ChangeNotifierProvider(create: (_)=>RecordProvider(),),
      ],
      child: Container(
        child: MaterialApp(
          title: "电气火灾预警系统",
          onGenerateRoute: Application.router.generator,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.blue,
          ),
          home: LoginPage(),
        ),
      ),

    );
  }
}