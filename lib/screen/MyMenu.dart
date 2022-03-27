import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MyMenu extends StatefulWidget {
  const MyMenu({Key? key}) : super(key: key);

  @override
  _MyMenuState createState() => _MyMenuState();
}

class _MyMenuState extends State<MyMenu> {
  late FirebaseMessaging messaging;
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
    return Container(child: Text("여기는 파이어베이스 테스트"));
  }
}
