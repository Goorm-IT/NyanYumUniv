import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';

class NaverLoginTest extends StatefulWidget {
  const NaverLoginTest({Key? key}) : super(key: key);

  @override
  State<NaverLoginTest> createState() => _NaverLoginTestState();
}

class _NaverLoginTestState extends State<NaverLoginTest> {
  String n_name = "";
  String n_email = "";

  void _login_naver() async {
    NaverLoginResult res = await FlutterNaverLogin.logIn();
    setState(() {
      n_name = res.account.name;
      n_email = res.account.email;
    });
  }

  void _logout_naver() async {
    FlutterNaverLogin.logOut();
    setState(() {
      n_name = "";
      n_email = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                _login_naver();
              },
              child: Text("로그인"),
            ),
            ElevatedButton(
              onPressed: () async {
                _logout_naver();
              },
              child: Text("로그아웃"),
            ),
            Text(n_name),
            Text(n_email),
          ],
        ),
      ),
    );
  }
}
