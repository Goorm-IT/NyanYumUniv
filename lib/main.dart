import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/screen/MyMenu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/services.dart';
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
  await Firebase.initializeApp();
  KakaoSdk.init(nativeAppKey: 'ce3fd3b2c65fa60fbe8029b59c6167b0');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('Tutorial');
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  runApp(MyApp());
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
        home: MyMenu());
  }
}

// String saved_id = "", saved_pw = "";

// class Cover extends StatefulWidget {
//   const Cover({Key? key}) : super(key: key);
//   @override
//   _CoverState createState() => _CoverState();
// }

// class _CoverState extends State<Cover> {
//   @override
//   void initState() {
//     super.initState();

//     Timer(Duration(milliseconds: 500), () {
//       Navigator.pushReplacement(
//         context,
//         PageTransition(
//           duration: Duration(milliseconds: 800),
//           type: PageTransitionType.fade,
//           alignment: Alignment.topCenter,
//           child: MyMenu(),
//         ),
//       );
//     });
//   }

//   Widget build(BuildContext context) {
//     var windowWidth = MediaQuery.of(context).size.width;
//     var windowHeight = MediaQuery.of(context).size.height;

//     return Stack(
//       children: <Widget>[
//         Positioned(child: cover_Background()),
//         Positioned(
//           bottom: windowHeight / 2,
//           left: windowWidth / 2 - windowWidth * 0.3 / 2,
//           child: putimg(windowWidth * 0.3, windowWidth * 0.3, "coverLogo"),
//         ),
//         Positioned(
//           bottom: windowHeight / 2 - windowWidth * 0.3 * 0.416 - 50,
//           left: windowWidth / 2 - windowWidth * 0.3 / 2,
//           child: putimg(
//               windowWidth * 0.3, windowWidth * 0.3 * 0.416, "coverTitle"),
//         )
//       ],
//     );
//   }
// }
