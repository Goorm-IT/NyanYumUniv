import 'package:flutter/material.dart';

class MyKakaoLogin extends StatefulWidget {
  const MyKakaoLogin({Key? key}) : super(key: key);

  @override
  _MyKakaoLoginState createState() => _MyKakaoLoginState();
}

class _MyKakaoLoginState extends State<MyKakaoLogin> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text("카카오 로그인")),
      ),
    );
  }
}
