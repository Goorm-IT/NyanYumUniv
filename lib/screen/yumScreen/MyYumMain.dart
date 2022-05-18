import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';

class MyYumMain extends StatefulWidget {
  final _yumNick, n_email;
  MyYumMain(this._yumNick, this.n_email);
  @override
  _MyYumMainState createState() => _MyYumMainState();
}

class _MyYumMainState extends State<MyYumMain> {
  _MyYumMainState();
  String tmp = "";
  @override
  void initState() {
    super.initState();
    asd();
  }

  void _logout_naver() async {
    FlutterNaverLogin.logOutAndDeleteToken();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.n_email),
            ElevatedButton(
              onPressed: _logout_naver,
              child: Text("네이버연결 끊기"),
            )
          ],
        )),
      ),
    );
  }

  Future<String> asd() async {
    var yumUserHttp = new YumUserHttp(widget.n_email);
    var yumLogin = await yumUserHttp.yumLogin();
    var yumInfo = await yumUserHttp.yumInfo();
    print('${yumInfo[0]["userAlias"]} adadasdsad');
    return yumInfo[0]["userAlias"];
  }
}
