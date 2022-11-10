import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'router_handler.dart';

class Routes {
  static String root = "/";
  static String userIndexPage = "/userIndex";
  static String adminIndexPage = "/adminIndex";
  static String elecList = "/elecList";
  static String elecList2 = "/elecList2";
  static String elecDetail = "/elecDetail";
  static String elecUpdate = "/elecUpdate";
  static String tempList = "/tempList";
  static String tempDetail = "/tempDetail";
  static String tempUpdate = "/tempUpdate";
  static String recordList = "/recordList";
  static String addEqu = "/addEqu";
  static String myChart = "/myChart";
  static String lineChart = "/lineChart";
  static String changePassword = "/changePassword";
  static String logout = "/logout";
  static String spot = "/spot";
  static String addSpot = "/addSpot";
  static String alloSpot = "/alloSpot";
  static String alertSpot = "/alertSpot";
  static String register = "/register";
  static String forget = "/forget";
  static String about = "/about";
  static String recordById = "/recordById";

  
  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        print("Error===>Route WAS Not Found!!!");
      }
    );
    router.define(userIndexPage, handler: userIndexHandler);
    router.define(adminIndexPage, handler: adminIndexHandler);
    router.define(elecList2, handler: elecListHandler2);
    router.define(elecDetail, handler: elecDetailHandler);
    router.define(elecUpdate, handler: elecUpdateHandler);
    router.define(tempList, handler: tempListHandler);
    router.define(tempDetail, handler: tempDetailHandler);
    router.define(tempUpdate, handler: tempUpdateHandler);
    router.define(recordList, handler: recordListHandler);
    router.define(addEqu, handler: AddHandler);
    router.define(myChart, handler: ChartHandler);
    router.define(lineChart, handler: LineChartHandler);
    router.define(changePassword, handler: ChangePasswordHandler);
    router.define(logout, handler: logoutHandler);
    router.define(spot, handler: spotHandler);
    router.define(addSpot, handler: addSpotHandler);
    router.define(alloSpot, handler: alloSpotHandler);
    router.define(register, handler: registerHandler);
    router.define(forget, handler: forgetHandler);
    router.define(alertSpot, handler: alertSpotHandler);
    router.define(about, handler: aboutHandler);
    router.define(recordById, handler: recordByIdHandler);

  }
}