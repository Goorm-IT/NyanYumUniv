import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/model/yum_user.dart';
import 'package:deanora/screen/yumScreen/yum_my_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:get_it/get_it.dart';

class MyYumMain extends StatefulWidget {
  MyYumMain();
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
          children: [
            Container(
              child: Text("provider test"),
            )
          ],
        )),
      ),
    );
  }
}
