import 'dart:async';
import 'dart:io';

import 'package:deanora/Widgets/LoginDataCtrl.dart';
import 'package:deanora/Widgets/custom_loading_image.dart';
import 'package:deanora/model/lecture.dart';
import 'package:deanora/model/user.dart';
import 'package:deanora/screen/nyanScreen/nyanMainScreen/myClass.dart';
import 'package:deanora/screen/nyanScreen/nyanSubScreen/Tutorial.dart';
import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/http/crawl/crawl.dart';
import 'package:deanora/http/customException.dart';
import 'package:deanora/main.dart';
import 'package:deanora/screen/MyKakaoLogin.dart';
import 'package:deanora/screen/yumScreen/MyYumMainTest.dart';
import 'package:deanora/screen/yumScreen/yumSignUpScreen/yum_alias_set.dart';
import 'package:deanora/screen/nyanScreen/nyanMainScreen/MyLogin.dart';
import 'package:deanora/screen/yumScreen/yumSignUpScreen/naver_login.dart';
import 'package:deanora/screen/yumScreen/yum_main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:get_it/get_it.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:page_transition/page_transition.dart';

class MyMenu extends StatefulWidget {
  const MyMenu({Key? key}) : super(key: key);

  @override
  _MyMenuState createState() => _MyMenuState();
}

class _MyMenuState extends State<MyMenu> {
  late FirebaseMessaging messaging;
  NyanUser userInfo = NyanUser('', '');
  List<Lecture> classesInfo = [];
  String saved_id = "", saved_pw = "";
  bool _loadingVisible = false;
  getLoginSaveDate() async {
    var ctrl = new LoginDataCtrl();
    var assurance = await ctrl.loadLoginData();
    saved_id = assurance["user_id"] ?? "";
    saved_pw = assurance["user_pw"] ?? "";
  }

  @override
  void initState() {
    super.initState();
    getLoginSaveDate();
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {});
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
              buttonPadding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18))),
              title: Center(
                  child: Text(
                event.notification!.title!,
                style: TextStyle(fontWeight: FontWeight.w900),
              )),
              content: Container(
                  child: Text(
                event.notification!.body!,
                textAlign: TextAlign.center,
              )),
              actions: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: Color(0xffd2d2d5), width: 1.0))),
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        child: Text(
                          "확인",
                          style: TextStyle(color: Color(0xff755FE7)),
                        ),
                      )),
                )
              ],
            );
          });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              color: Colors.black,
              child: SafeArea(
                  bottom: false,
                  left: false,
                  right: false,
                  child: Container(
                    margin: EdgeInsets.only(top: 30, left: 30, right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text("냥냠대 컨텐츠",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w800)),
                        SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: ListView(
                            children: [
                              SizedBox(
                                height: 18,
                              ),
                              contentsMenu(nyanLogintest, "nyanTitle",
                                  "냥대 - 내 강의실", "각 과목의 과제 정보와 학사 일정을 확인"),
                              SizedBox(
                                height: 30,
                              ),
                              contentsMenu(isYumLogin, "yumTitle", "냠대 - 맛집 정보",
                                  "안양대생만의 숨은 꿀 맛집 정보를 공유"),
                              SizedBox(
                                height: 18,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            _loadingVisible
                ? Stack(
                    children: [
                      Opacity(
                        opacity: 0.5,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          color: Colors.black,
                        ),
                      ),
                      Center(
                        child: CustomLoadingImage(),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Future<void> nyanLogintest() async {
    var crawl = new Crawl(id: saved_id, pw: saved_pw);
    try {
      try {
        userInfo = GetIt.I<NyanUser>(instanceName: "userInfo");
        classesInfo = GetIt.I<List<Lecture>>(instanceName: "classesInfo");
      } catch (e) {
        await crawl.crawlUser();
        await crawl.crawlClasses();
        userInfo = GetIt.I<NyanUser>(instanceName: "userInfo");
        classesInfo = GetIt.I<List<Lecture>>(instanceName: "classesInfo");
      }

      Navigator.push(
          context,
          PageTransition(
            duration: Duration(milliseconds: 250),
            type: PageTransitionType.fade,
            child: MyClass(
              saved_id,
              saved_pw,
            ),
          ));
    } on CustomException {
      Navigator.push(
        context,
        PageTransition(
          duration: Duration(milliseconds: 800),
          type: PageTransitionType.fade,
          alignment: Alignment.topCenter,
          child: isviewed != 0 ? Tutorial() : MyLogin(),
        ),
      );
    }
  }

  Future<bool> _isLogin_naver() async {
    NaverAccessToken res = await FlutterNaverLogin.currentAccessToken;

    bool isLogin = res.accessToken.isNotEmpty && res.accessToken != 'no token';
    return isLogin;
  }

  Future<void> _logout_naver() async {
    await FlutterNaverLogin.logOutAndDeleteToken();
  }

  Future<String> _login_naver() async {
    NaverLoginResult res = await FlutterNaverLogin.logIn();

    return res.account.email;
  }

  Future<String> _get_user() async {
    NaverAccountResult res = await FlutterNaverLogin.currentAccount();
    return res.email;
  }

  Future<void> isYumLogin() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
    bool isLogin_naver = await _isLogin_naver();

    String nEmail = "";
    if (isLogin_naver == true) {
      nEmail = await _get_user().timeout(const Duration(milliseconds: 2000),
          onTimeout: () async {
        print('_get_user 오류');
        await _logout_naver();
        return await _login_naver();
      });
      try {
        var yumUserHttp = new YumUserHttp(nEmail);
        var yumLogin = await yumUserHttp.yumLogin();
        if (yumLogin == 200) {
          var yumInfo = await yumUserHttp.yumInfo();

          setState(() {
            _loadingVisible = !_loadingVisible;
          });
          print("여기");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => YumMain(),
            ),
          );
        } else if (yumLogin == 400) {
          setState(() {
            _loadingVisible = !_loadingVisible;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyYumNickRegist(nEmail),
            ),
          );
        } else {
          print(yumLogin);
        }
      } catch (e) {
        print(e);
      }
    } else {
      setState(() {
        _loadingVisible = !_loadingVisible;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NaverLoginPage(),
        ),
      );
    }
  }

  Widget contentsMenu(_ontapcontroller, image, title, descrition) {
    var windowHeight = MediaQuery.of(context).size.height;
    var windowWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () async {
        await _ontapcontroller();
      },
      child: Center(
        child: Container(
          width: windowWidth - 60,
          child: Column(
            children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: Stack(
                    children: [
                      Container(
                        child: Image.asset('assets/images/$image.png'),
                      ),
                      Opacity(
                        opacity: 0.1,
                        child: Container(
                          color: Colors.black,
                          width: 500,
                          height: 212,
                        ),
                      )
                    ],
                  )),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15))),
                    child: Container(
                      padding: EdgeInsets.only(left: 20, top: 15, bottom: 14),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              title,
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(descrition, style: TextStyle(fontSize: 13))
                          ]),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
