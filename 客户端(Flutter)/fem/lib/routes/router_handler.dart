import 'package:charts_flutter/flutter.dart';
import 'package:fem/pages/admin/alloSpot.dart';
import 'package:fem/pages/forget.dart';
import 'package:fem/pages/login.dart';
import 'package:fem/pages/register.dart';
import 'package:fem/pages/user/home/addEqu.dart';
import 'package:fem/pages/user/home/elecDetail.dart';
import 'package:fem/pages/user/home/lineChart.dart';
import 'package:fem/pages/user/home/recordById.dart';
import 'package:fem/pages/user/home/updateElec.dart';
import 'package:fem/pages/user/my/SpotPage.dart';
import 'package:fem/pages/user/my/aboutPage.dart';
import 'package:fem/pages/user/my/addSpot.dart';
import 'package:fem/pages/user/my/alertSpot.dart';
import 'package:fem/pages/user/my/changePassword.dart';
import 'package:fem/pages/user/search/myChart.dart';
import 'package:fem/pages/user/search/recordList.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import '../pages/user/index_page.dart';
import '../pages/admin/index_page.dart';

import '../pages/user/home/elecList.dart';
import 'package:fem/pages/user/home/updateTemp.dart';
import 'package:fem/pages/user/home/tempDetail.dart';
import 'package:fem/pages/user/home/tempList.dart';
Handler userIndexHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String userId = params['id'].first;
    return UserIndexPage(userId);
  }
);

Handler adminIndexHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String userId = params['id'].first;
    return AdminIndexPage(userId);
  }
);

// Handler elecListHandler = Handler(
//   handlerFunc: (BuildContext context, Map<String, List<String>> params) {
//     String level = params['level'].first;
//     return ElecListPage(level);
//   }
// );

Handler elecListHandler2 = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String level;
    level = params['state'].first;   
    return ElecList(level);
  }
);

Handler elecDetailHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String level = params['elecId'].first;
    return ElecDetail(level);
  }
);

Handler elecUpdateHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String level = params['elecId'].first;
    return UpdateElec(level);
  }
);

Handler tempListHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String level = params['state'].first;
    return TempList(level);
  }
);

Handler tempDetailHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String level = params['tempId'].first;
    return TempDetail(level);
  }
);

Handler tempUpdateHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String level = params['tempId'].first;
    return UpdateTemp(level);
  }
);

Handler recordListHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    int type = int.parse(params['type'].first);
    String state = params['state'].first;
    return RecordList(type, state);
  }
);

Handler AddHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    int type = int.parse(params['type'].first);
    return AddEqu(type);
  }
);

Handler ChartHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return MyChart();
  }
);

Handler LineChartHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    int type = int.parse(params['type'].first);
    String id = params['id'].first;
    return LineOnTime(type, id);
  }
);

Handler ChangePasswordHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return ChangePassword();
  }
);

Handler logoutHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return LoginPage();
  }
);

Handler spotHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return SpotPage();
  }
);

Handler addSpotHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return AddSpotPage();
  }
);

Handler alertSpotHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    int spotId = int.parse(params['spotId'].first);
    return AlertSpot(spotId);
  }
);

Handler alloSpotHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String userId = params['userId'].first;
    return AlloSpot(userId);
  }
);

Handler registerHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return RegisterPage();
  }
);

Handler forgetHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return ForgetPage();
  }
);

Handler aboutHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return AboutPage();
  }
);

Handler recordByIdHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    int type = int.parse(params['type'].first);
    String id = params['id'].first;
    return RecordById(type, id);
  }
);