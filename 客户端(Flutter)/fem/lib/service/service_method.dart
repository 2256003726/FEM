

//import 'dart:html';
import 'dart:io';

import 'package:dio/dio.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

//设置请求头
Future getHeader() async{

  //从shared_preference取出token，放入请求头
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = '';
  if(prefs.getString('token') != null || prefs.getString('token') != '') {    
        token = prefs.getString('token');
    }
  // Map<String ,dynamic> httpHeaders = {
  //   'Accept': 'application/json, text/plain, */*',
  //   'Accept-Encoding': 'gzip, deflate, br',
  //   'Accept-Language': 'zh-CN,zh;q=0.9',
  //   'Connection': 'keep-alive',
  //   'Sec-Fetch-Mode': 'cors',
  //   'Sec-Fetch-Site': 'same-origin',
  //   'Authorization': token,
  //   'User-Agent':
  //       'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36'
  // };
   Map<String ,dynamic> httpHeaders = { 
    'authorization': token, 
  };
  return httpHeaders;
} 

Future request(url, {formData, parms}) async {
  try {
    Response response;
    Dio dio = new Dio();
    Options options = new Options();
    await getHeader().then((val) {   
      dio.options.headers = val;
      options = Options(headers: {HttpHeaders.authorizationHeader: val['authorization']}); 
    }); 
  //   dio.options.contentType = 
  //  ContentType.parse('application/x-www-form-urlencode');
   
   //信任一切证书，因为我的springboot证书是自证的哦
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
    };
    if(formData == null && parms == null) {
      response = await dio.post(url,options: options);
    } else if(parms == null){
      response = await dio.post(url, data: formData, options: options);
    } else if(formData == null) {
       response = await dio.post(url, queryParameters: parms, options: options);
    } else {
      response = await dio.post(url, queryParameters: parms, data: formData, options: options);
    }
    
    if(response.statusCode == 200) {
      
      return response.data;
    } else if(response.statusCode == 111) {
      return 'flag';
    }  else {
      print('错误代码'+response.statusCode.toString());
      throw Exception("后端接口出现异常");
    }
  } catch(e) {
    print("请求ERROR ========> ${e}");
    
    
  }
 
} 