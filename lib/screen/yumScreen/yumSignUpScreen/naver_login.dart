import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/screen/yumScreen/MyYumMainTest.dart';
import 'package:deanora/screen/yumScreen/yumSignUpScreen/yum_alias_set.dart';
import 'package:deanora/screen/yumScreen/yum_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';

class NaverLoginPage extends StatefulWidget {
  const NaverLoginPage({Key? key}) : super(key: key);

  @override
  State<NaverLoginPage> createState() => _NaverLoginPageState();
}

class _NaverLoginPageState extends State<NaverLoginPage> {
  @override
  Future<String> _login_naver() async {
    NaverLoginResult res = await FlutterNaverLogin.logIn();
    return res.account.email;
  }

  Future<bool> _isLogin_naver() async {
    NaverAccessToken res = await FlutterNaverLogin.currentAccessToken;
    bool isLogin = res.accessToken.isNotEmpty && res.accessToken != 'no token';
    return isLogin;
  }

  Future<void> _logout_naver() async {
    await FlutterNaverLogin.logOutAndDeleteToken();
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/kakaologinback.png'),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SafeArea(
              child: Container(
                height: 30,
                margin: const EdgeInsets.only(left: 25, top: 10),
                alignment: Alignment.topLeft,
                child: GestureDetector(
                    onTap: () => {
                          Navigator.pop(context),
                        },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20,
                    )),
              ),
            ),
            Flexible(
              child: SizedBox(
                height: 90,
              ),
            ),
            putimg(127.0, 127.0, "coverLogo"),
            SizedBox(
              height: 19,
            ),
            putimg(127.0, 127.0, "kakaologintitle"),
            Flexible(
              child: SizedBox(
                height: 80,
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  String nEmail = "";
                  try {
                    nEmail = await _login_naver();
                  } catch (e) {
                    await _logout_naver();
                    nEmail = await _login_naver();
                  }

                  bool isLogin = await _isLogin_naver();
                  if (isLogin) {
                    var yumUserHttp = new YumUserHttp(nEmail);
                    var yumLogin = await yumUserHttp.yumLogin();
                    if (yumLogin == 200) {
                      var yumInfo = await yumUserHttp.yumInfo();

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => YumMain()),
                      );
                    } else if (yumLogin == 400) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyYumNickRegist(nEmail),
                        ),
                      );
                    } else {
                      print(yumLogin);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                child: Ink(
                  decoration: BoxDecoration(
                      color: Color(0xff794cdd),
                      borderRadius: BorderRadius.circular(50)),
                  child: Container(
                    width: 270,
                    height: 60,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'N  ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w900)),
                              TextSpan(text: ' 네이버로 로그인하기'),
                            ],
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'NanumSquare_acB',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: SizedBox(
                height: 20,
              ),
            ),
            Text(
              "더욱 다양한 서비스 사용을 위해\n 냥 기능을 활성화해주세요 :)",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontFamily: "NotoSansKR_Regular",
                  fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
