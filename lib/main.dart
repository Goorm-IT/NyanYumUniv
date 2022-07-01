import 'package:deanora/provider/comment_provider.dart';
import 'package:deanora/provider/menu_provider.dart';
import 'package:deanora/provider/review_provider.dart';
import 'package:deanora/provider/storeInfo_provider.dart';
import 'package:deanora/screen/MyMenu.dart';
import 'package:deanora/screen/yumScreen/yumSignUpScreen/naver_login.dart';
import 'package:deanora/screen/yumScreen/naver_login_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

int? isviewed;

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  GetIt.I.allowReassignment = true;
  await Firebase.initializeApp();
  KakaoSdk.init(nativeAppKey: 'ce3fd3b2c65fa60fbe8029b59c6167b0');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('Tutorial');
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (BuildContext context) => StoreInfoProvider(),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => ReviewProvider(),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => MenuProvider(),
    ),
    ChangeNotifierProvider(
      create: (BuildContext context) => CommentProvider(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '냥냠대',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: MyMenu(),
      // home: NaverLoginPage(),
    );
  }
}
