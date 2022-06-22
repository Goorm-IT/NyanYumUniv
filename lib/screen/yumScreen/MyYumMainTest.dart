import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/object/yum_user.dart';
import 'package:deanora/screen/yumScreen/yum_my_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:get_it/get_it.dart';

class MyYumMain extends StatefulWidget {
  final _yumNick, n_email;
  MyYumMain(this._yumNick, this.n_email);
  @override
  _MyYumMainState createState() => _MyYumMainState();
}

class _MyYumMainState extends State<MyYumMain> {
  _MyYumMainState();
  String tmp = "";
  YumUser yumUser = GetIt.I<YumUser>();
  @override
  void initState() {
    super.initState();
    asd();
  }

  void _logout_naver() async {
    FlutterNaverLogin.logOutAndDeleteToken();
    Navigator.of(context).pop();
  }

  void _yum_delete() async {
    var yumUserHttp = YumUserHttp(widget.n_email);
    await yumUserHttp.yumLogin();
    await yumUserHttp.yumDelete();
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
            yumUser.imagePath != null
                ? Image.network(
                    'https://picsum.photos/250?image=9',
                    fit: BoxFit.cover,
                  )
                : Image.asset('assets/images/defaultImg.png'),
            Text(widget.n_email),
            ElevatedButton(
              onPressed: _logout_naver,
              child: Text("네이버연결 끊기"),
            ),
            ElevatedButton(
              onPressed: _yum_delete,
              child: Text("얌 회탈"),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyProfilePage()));
                },
                child: Text("프로필 화면"))
          ],
        )),
      ),
    );
  }

  Future<String> asd() async {
    var yumUserHttp = new YumUserHttp(widget.n_email);
    var yumLogin = await yumUserHttp.yumLogin();
    var yumInfo = await yumUserHttp.yumInfo();
    return yumInfo[0]["userAlias"];
  }
}
