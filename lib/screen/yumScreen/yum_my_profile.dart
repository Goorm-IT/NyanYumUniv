import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/model/yum_user.dart';
import 'package:deanora/provider/like_store_provider.dart';
import 'package:deanora/provider/save_store_provider.dart';
import 'package:deanora/screen/MyMenu.dart';
import 'package:deanora/screen/yumScreen/yum_like_list.dart';
import 'package:deanora/screen/yumScreen/yum_my_review.dart';
import 'package:deanora/screen/yumScreen/yum_save_list.dart';
import 'package:deanora/screen/yumScreen/yum_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage>
    with SingleTickerProviderStateMixin {
  YumUser yumUser = GetIt.I<YumUser>();
  final _nicknameController = TextEditingController();
  late AnimationController _animationController;
  String errorMessage = "";
  Color errorMessageColor = Colors.red;
  bool _visible = false;

  void _logout_naver() async {
    FlutterNaverLogin.logOutAndDeleteToken();
  }

  void yumDelete() async {
    var yumUserHttp = YumUserHttp();
    print(yumUser.uid);
    try {
      await yumUserHttp.yumLogin(yumUser.uid);
      await yumUserHttp.yumDelete(yumUser.uid);
    } catch (e) {}
  }

  void yumLogout() async {
    var yumUserHttp = YumUserHttp();
    try {
      await yumUserHttp.yumLogin(yumUser.uid);
      await yumUserHttp.yumLogOut();
    } catch (e) {}
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nicknameController.text = yumUser.userAlias;
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 250));
  }

  fadeMessage(newerrorMessage, newerrorMessageColor) {
    setState(() {
      errorMessage = newerrorMessage;
      errorMessageColor = newerrorMessageColor;
    });
    print(errorMessage);
    if (!_visible) {
      _animationController.forward();
      setState(() {
        _visible = !_visible;
      });
    } else {
      _animationController.reverse();
      Future.delayed(const Duration(milliseconds: 500), () {
        _animationController.forward();
      });
    }
  }

  late LikeStoreProvider _likeStoreProvider;
  late SaveStoreProvider _saveStoreProvider;
  @override
  Widget build(BuildContext context) {
    _likeStoreProvider = Provider.of<LikeStoreProvider>(context, listen: false);
    _saveStoreProvider = Provider.of<SaveStoreProvider>(context, listen: false);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Colors.white,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "마이페이지",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: Platform.isIOS
                        ? MediaQuery.of(context).size.height -
                            AppBar().preferredSize.height -
                            MediaQuery.of(context).padding.top -
                            30
                        : MediaQuery.of(context).size.height -
                            AppBar().preferredSize.height -
                            MediaQuery.of(context).padding.top,
                    child: ListView(children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Center(
                        // child: Image.asset(
                        //   'assets/images/defaultImg.png',
                        //   width: 100,
                        // ),
                        child: Container(
                          width: 150,
                          height: 150,
                          child: ClipOval(
                            child: yumUser.imagePath != null
                                ? CachedNetworkImage(
                                    fadeInDuration:
                                        const Duration(milliseconds: 100),
                                    fadeOutDuration:
                                        const Duration(milliseconds: 100),
                                    imageUrl: yumUser.imagePath.toString(),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Image.asset(
                                      'assets/images/defaultImg.png',
                                      width: 110,
                                      height: 110,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  )
                                : Image.asset(
                                    'assets/images/defaultImg.png',
                                    width: 110,
                                    height: 110,
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 19,
                      ),
                      Row(
                        children: [
                          Text(
                            "닉네임",
                            style: TextStyle(fontSize: 12.0),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          FadeTransition(
                            opacity: _animationController,
                            child: Center(
                              child: Text(
                                errorMessage,
                                style: TextStyle(
                                    color: errorMessageColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        height: 52,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _nicknameController,
                                decoration: loginTextFieldStyle(),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  try {
                                    if (_nicknameController.text == "") {
                                      fadeMessage("닉네임을 입력해주세요", Colors.red);
                                    } else if (_nicknameController.text ==
                                        yumUser.userAlias) {
                                      fadeMessage("닉네임을 변경해주세요", Colors.red);
                                    } else {
                                      var yumUserHttp = new YumUserHttp();
                                      var yumLogin = await yumUserHttp
                                          .yumLogin(yumUser.uid);
                                      var yumUpdateNickName =
                                          await yumUserHttp.yumUpdateNickName(
                                              _nicknameController.text);
                                      if (yumUpdateNickName == 200) {
                                        fadeMessage(
                                            "닉네임이 변경되었습니다", Colors.blue);

                                        await yumUserHttp.yumInfo();
                                        setState(() {
                                          yumUser = GetIt.I<YumUser>();
                                        });
                                      } else {
                                        fadeMessage(
                                            "사용 불가능한 닉네임입니다", Colors.red);
                                      }
                                    }
                                  } catch (e) {
                                    fadeMessage("닉네임 변경에 실패했습니다.", Colors.red);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                child: Ink(
                                  decoration: BoxDecoration(
                                      color: Color(0xff6368E6),
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Container(
                                    width: 76,
                                    height: 54,
                                    alignment: Alignment.center,
                                    child: Text("변경하기"),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Divider(color: Color(0xffD6D6D6), thickness: 0.5),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _item(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              YumMyReview())));
                                },
                                image: 'profile_review_icon',
                                title: '내가 쓴 리뷰'),
                            _item(
                                onTap: () async {
                                  await _saveStoreProvider.getSaveStore();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => YumSaveList(),
                                    ),
                                  );
                                },
                                image: 'profile_store_icon',
                                title: '저장한 맛집'),
                            _item(
                                onTap: () async {
                                  await _likeStoreProvider.getLikeStore();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => YumLikeList()));
                                },
                                image: 'profile_like_icon',
                                title: '좋아요한 맛집'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 23,
                      ),
                      Container(
                        height: 170,
                        color: Color(0xfff9f9f9),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      Center(
                        child: Column(
                          children: [
                            Container(
                                width: 150,
                                child: Divider(
                                    color: Color(0xffD6D6D6), thickness: 0.5)),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => YumSupport())));
                              },
                              child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    "건의하기",
                                    style: TextStyle(fontSize: 11),
                                  )),
                            ),
                            Container(
                                width: 150,
                                child: Divider(
                                    color: Color(0xffD6D6D6), thickness: 0.5)),
                            GestureDetector(
                              onTap: () async {
                                return showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    contentPadding: const EdgeInsets.all(0),
                                    content: Container(
                                      width: MediaQuery.of(context).size.width -
                                          100,
                                      height: 60,
                                      child: Center(
                                        child: Text('로그아웃 하시겠습니까?'),
                                      ),
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            child: Center(
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  Navigator.of(context).pop();
                                                  _logout_naver();
                                                  yumLogout();

                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyMenu()),
                                                      (route) => false);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color(0xff7D48D9)),
                                                child: Text('확인'),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            child: Center(
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  Navigator.of(context).pop();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color(0xff7D48D9)),
                                                child: Text('취소'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    "로그아웃",
                                    style: TextStyle(fontSize: 11),
                                  )),
                            ),
                            Container(
                                width: 150,
                                child: Divider(
                                    color: Color(0xffD6D6D6), thickness: 0.5)),
                            GestureDetector(
                              onTap: () async {
                                return showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    contentPadding: const EdgeInsets.all(0),
                                    content: Container(
                                      width: MediaQuery.of(context).size.width -
                                          100,
                                      height: 60,
                                      child: Center(
                                        child: Text('회원탈퇴 하시겠습니까?'),
                                      ),
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            child: Center(
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  yumDelete();
                                                  _logout_naver();
                                                  Navigator.of(context).pop();

                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyMenu()),
                                                      (route) => false);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color(0xff7D48D9)),
                                                child: Text('확인'),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            child: Center(
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  Navigator.of(context).pop();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color(0xff7D48D9)),
                                                child: Text('취소'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    "회원탈퇴",
                                    style: TextStyle(fontSize: 11),
                                  )),
                            ),
                            Container(
                                width: 150,
                                child: Divider(
                                    color: Color(0xffD6D6D6), thickness: 0.5)),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 24, horizontal: 30),
                                        buttonPadding:
                                            const EdgeInsetsDirectional
                                                .fromSTEB(0, 8, 0, 8),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(18))),
                                        title: Text(
                                          "로그인 정보",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900),
                                        ),
                                        content: Container(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                                child: Text(
                                              "이메일 : ${yumUser.uid}",
                                              style: TextStyle(fontSize: 15),
                                            )),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              "가입 일자 : ${yumUser.registerDate}",
                                              style: TextStyle(fontSize: 15),
                                            )
                                          ],
                                        )),
                                        actions: [
                                          Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    top: BorderSide(
                                                        color:
                                                            Color(0xffd2d2d5),
                                                        width: 1.0))),
                                            child: TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Container(
                                                  child: Text(
                                                    "확인",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff755FE7)),
                                                  ),
                                                )),
                                          )
                                        ],
                                      );
                                    });
                              },
                              child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    "로그인 정보",
                                    style: TextStyle(fontSize: 11),
                                  )),
                            ),
                            Container(
                                width: 150,
                                child: Divider(
                                    color: Color(0xffD6D6D6), thickness: 0.5)),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(
      {required Function()? onTap,
      required String image,
      required String title}) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: _ProfileIcon(image: image, title: title),
      ),
    );
  }

  InputDecoration loginTextFieldStyle() {
    return InputDecoration(
      labelStyle: const TextStyle(color: Color(0xff707070)),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        borderSide: BorderSide(width: 1, color: Color(0xff707070)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        borderSide: BorderSide(width: 1, color: Color(0xff707070)),
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
    );
  }
}

class _ProfileIcon extends StatelessWidget {
  final String image;
  final String title;
  const _ProfileIcon({required this.image, required this.title, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: 35,
            height: 35,
            child: Image.asset('assets/images/$image.png')),
        Text(
          title,
          style: TextStyle(fontSize: 10.0),
        ),
      ],
    );
  }
}
