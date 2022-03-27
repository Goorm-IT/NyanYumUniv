import 'package:flutter/material.dart';

class MyYumNickName extends StatefulWidget {
  final _kakaoNick;
  MyYumNickName(this._kakaoNick);

  @override
  _MyYumNickNameState createState() => _MyYumNickNameState(this._kakaoNick);
}

class _MyYumNickNameState extends State<MyYumNickName> {
  final _kakaoNick;
  _MyYumNickNameState(this._kakaoNick);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text("얌 닉네임")),
      ),
    );
  }
}
