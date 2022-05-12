import 'package:deanora/Widgets/LoginDataCtrl.dart';
import 'package:deanora/Widgets/Tutorial.dart';
import 'package:deanora/Widgets/yumHttp.dart';
import 'package:deanora/crawl/crawl.dart';
import 'package:deanora/crawl/customException.dart';
import 'package:deanora/main.dart';
import 'package:deanora/screen/MyKakaoLogin.dart';
import 'package:deanora/screen/MyLogin.dart';
import 'package:deanora/screen/MyClass.dart';
import 'package:deanora/screen/MyYumMain.dart';
import 'package:deanora/screen/MyYumNickRegist.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:page_transition/page_transition.dart';

class MyMenu extends StatefulWidget {
  const MyMenu({Key? key}) : super(key: key);

  @override
  _MyMenuState createState() => _MyMenuState();
}

class _MyMenuState extends State<MyMenu> {
  late FirebaseMessaging messaging;
  String saved_id = "", saved_pw = "";
  @override
  void initState() {
    super.initState();

    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print(value);
    });
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
    var windowHeight = MediaQuery.of(context).size.height;
    var windowWidth = MediaQuery.of(context).size.width;

    Widget contentsMenu(_ontapcontroller, image, title, descrition) {
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
                    child: Container(
                      child: Image.asset('assets/images/$image.png'),
                    )),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30))),
                      child: Container(
                        padding: EdgeInsets.only(left: 20, top: 15, bottom: 15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                title,
                                style: TextStyle(fontWeight: FontWeight.w800),
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

    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
          color: Colors.black,
          width: windowWidth,
          height: windowHeight,
          child: Container(
            margin: EdgeInsets.only(top: 30, left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Text("냥냠대 컨텐츠",
                    style: TextStyle(color: Colors.white, fontSize: 25)),
                SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 18,
                      ),
                      contentsMenu(isNyanLogin, "nyanTitle", "냥대 - 내 강의실",
                          "각 과목의 과제 정보와 학사 일정을 확인"),
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
          ),
        )),
      ),
    );
  }

  isNyanLogin() async {
    var ctrl = new LoginDataCtrl();
    var assurance = await ctrl.loadLoginData();
    saved_id = assurance["user_id"] ?? "";
    saved_pw = assurance["user_pw"] ?? "";
    var crawl = new Crawl(saved_id, saved_pw);
    try {
      var classes = await crawl.crawlClasses();
      var user = await crawl.crawlUser();
      print("Saved_login");
      Navigator.push(
          context,
          PageTransition(
            duration: Duration(milliseconds: 250),
            type: PageTransitionType.fade,
            child: MyClass(saved_id, saved_pw, classes, user),
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

  isYumLogin() async {
    if (await AuthApi.instance.hasToken()) {
      print("여기는 바로 가능");
      try {
        // await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
        User _user = await UserApi.instance.me();
        String _email =
            _user.kakaoAccount!.profile?.toJson()['nickname'].toString() ?? "";
        var yumHttp = new YumUserHttp(_email);
        var yumLogin = await yumHttp.yumLogin();
        if (yumLogin == 200) {
          //로그인 성공
          var yumInfo = await yumHttp.yumInfo();
          print(yumInfo);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyYumMain(yumInfo[0]["nickName"], _email)),
          );
        } else if (yumLogin == 400) {
          // 로그인 실패, 회원가입 으로
          print("닉네임 설정 해야함 토큰은 있음");
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => MyYumNickRegist(_email)));
        } else {
          // 기타 에러
          print(yumLogin);
        }
      } catch (e) {
        if (e is KakaoException && e.isInvalidTokenError()) {
          print('토큰 만료 $e');
        } else {
          print('토큰 정보 조회 실패 $e');
        }
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyKakaoLogin()));
      }
    } else {
      print("토큰 없음");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyKakaoLogin()));
    }
  }
}
