import 'package:flutter/material.dart';

class MyYumMain extends StatefulWidget {
  final _yumNick, _kakaoNick;
  MyYumMain(this._yumNick, this._kakaoNick);
  @override
  _MyYumMainState createState() =>
      _MyYumMainState(this._yumNick, this._kakaoNick);
}

class _MyYumMainState extends State<MyYumMain> {
  final _yumNick, _kakaoNick;
  _MyYumMainState(this._yumNick, this._kakaoNick);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text("얌 메인")),
      ),
    );
  }
}
