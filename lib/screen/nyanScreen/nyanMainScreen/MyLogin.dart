import 'package:custom_check_box/custom_check_box.dart';
import 'package:deanora/Widgets/LoginDataCtrl.dart';
import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/http/crawl/crawl.dart';
import 'package:deanora/http/customException.dart';
import 'package:deanora/screen/nyanScreen/nyanMainScreen/myClass.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

class MyLogin extends StatefulWidget {
  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> with SingleTickerProviderStateMixin {
  final id = TextEditingController();
  final pw = TextEditingController();

  var ctrl = new LoginDataCtrl();
  bool _isChecked = false;
  late AnimationController _animationController;
  bool _visible = false;
  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.black,
      ),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        SizedBox(height: 140),
                        putimg(105.0, 105.0, "loginLogo"),
                        SizedBox(height: 60),
                        loginTextF(id, "학번", "loginIdIcon", false),
                        SizedBox(
                          height: 10,
                        ),
                        loginTextF(pw, "비밀번호", "loginPwIcon", true),
                        SizedBox(
                          height: 10,
                        ),
                        FadeTransition(
                          opacity: _animationController,
                          child: Center(
                              child: Text(
                            "입력한 정보가 일치하지 않습니다",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 12),
                          )),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomCheckBox(
                          value: _isChecked,
                          shouldShowBorder: true,
                          borderColor: Color(0xff8E53E9),
                          checkedFillColor: Color(0xff8E53E9),
                          borderRadius: 5,
                          borderWidth: 2.3,
                          checkBoxSize: 13,
                          onChanged: (value) async {
                            if (value == true) {
                            } else {
                              await ctrl.removeLoginData();
                            }
                            setState(() {
                              _isChecked = value; //true가 들어감.
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_isChecked == true) {
                                _isChecked = false;
                              } else {
                                _isChecked = true;
                              }
                            });
                          },
                          child: Text(
                            "로그인 상태 유지",
                            style: TextStyle(color: Color(0xff707070)),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Container(
                      child: ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (_isChecked == true) {
                            print("저장할게요~");
                            await ctrl.saveLoginData(id.text, pw.text);
                          }
                          Crawl.id = id.text;
                          Crawl.pw = pw.text;
                          var crawl = new Crawl();
                          try {
                            var classes = await crawl.crawlClasses();
                            var user = await crawl.crawlUser();

                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                  duration: Duration(milliseconds: 250),
                                  type: PageTransitionType.fade,
                                  child: MyClass(id.text, pw.text),
                                ));
                          } on CustomException catch (e) {
                            print('${e.code} ${e.message}');
                            if (!_visible) {
                              _animationController.forward();
                              _visible = !_visible;
                            } else {
                              _animationController.reverse();
                              Future.delayed(const Duration(milliseconds: 200),
                                  () {
                                _animationController.forward();
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: <Color>[
                                    Color(0xff6D6CEB),
                                    Color(0xff8C65EC),
                                  ]),
                              borderRadius: BorderRadius.circular(50)),
                          child: Container(
                            width: 270,
                            height: 60,
                            alignment: Alignment.center,
                            child: Text(
                              '로그인',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
