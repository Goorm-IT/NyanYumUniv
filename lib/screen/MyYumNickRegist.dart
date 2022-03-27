import 'package:flutter/material.dart';

class MyYumNickRegist extends StatefulWidget {
  final _kakaoNick;
  MyYumNickRegist(this._kakaoNick);

  @override
  _MyYumNickRegistState createState() => _MyYumNickRegistState(this._kakaoNick);
}

class _MyYumNickRegistState extends State<MyYumNickRegist> {
  final _kakaoNick;
  _MyYumNickRegistState(this._kakaoNick);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text("얌 닉네임")),
      ),
    );
  }
}
