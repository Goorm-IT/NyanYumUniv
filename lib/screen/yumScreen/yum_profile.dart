import 'dart:io';

import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/screen/yumScreen/MyYumMain.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class MyProfileImg extends StatefulWidget {
  var _yumInfo;
  var nEmail;
  MyProfileImg(this._yumInfo, this.nEmail);

  @override
  State<MyProfileImg> createState() => _MyProfileImgState();
}

class _MyProfileImgState extends State<MyProfileImg> {
  _MyProfileImgState();
  File? myimage;
  @override
  Widget build(BuildContext context) {
    final yumUserhttp = YumUserHttp(widget.nEmail);
    return MaterialApp(
      home: Scaffold(
          body: FutureBuilder(
        future: yumUserhttp.yumLogin(),
        builder: (futurecontext, snap) {
          if (snap.hasData) {
            return Container(
              margin: const EdgeInsets.only(left: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafeArea(
                      bottom: false,
                      child: Container(
                        alignment: Alignment.topLeft,
                        height: 30,
                        margin: const EdgeInsets.only(top: 10),
                        child: GestureDetector(
                            onTap: () => {
                                  Navigator.pop(context),
                                },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.grey,
                              size: 25,
                            )),
                      ),
                    ),
                    Flexible(
                      child: SizedBox(
                        height: 30,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        "회원님을 표현해주세요",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Flexible(
                        child: SizedBox(
                      height: 40,
                    )),
                    Center(
                      child: InkWell(
                        onTap: () {
                          showBottomSheet(context);
                        },
                        customBorder: new CircleBorder(),
                        child: Ink(
                            width: 160,
                            height: 160,
                            child: Stack(children: [
                              myimage == null
                                  ? Center(
                                      child:
                                          putimg(150.0, 150.0, "profilelogo"))
                                  : Center(
                                      child: ClipOval(
                                        child: Image.file(
                                          File(myimage!.path),
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Ink(
                                    decoration:
                                        BoxDecoration(shape: BoxShape.circle),
                                    child: Image.asset(
                                      'assets/images/profilebutton.png',
                                      width: 60,
                                      height: 60,
                                    ),
                                  )),
                            ])),
                      ),
                    ),
                    Flexible(
                        child: SizedBox(
                      height: 50,
                    )),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          final getpath =
                              await yumUserhttp.yumProfileImg(myimage?.path);
                          print(getpath);
                          if (getpath == 200) {
                            final newInfo = await yumUserhttp.yumInfo();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MyYumMain(newInfo[0], widget.nEmail)));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: <Color>[
                                    Color(0xff7C4DF1),
                                    Color(0xff6D6CEB),
                                  ]),
                              borderRadius: BorderRadius.circular(50)),
                          child: Container(
                            width: 270,
                            height: 60,
                            alignment: Alignment.center,
                            child: Text(
                              '설정하기',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'NanumSquare_acB',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                        child: SizedBox(
                      height: 15,
                    )),
                    Center(
                      child: Text(
                        "설정하신 프로필은 냠 페이지에 적용됩니다.",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff707070)),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyYumMain(
                                      widget._yumInfo, widget.nEmail)));
                        },
                        child: Text("Skip")),
                  ]),
            );
          } else {
            return Container();
          }
        },
      )),
    );
  }

  Future<ImageSource?> showBottomSheet(BuildContext context) async {
    if (Platform.isIOS) {
      return showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(
                actions: [
                  CupertinoActionSheetAction(
                      onPressed: () {
                        getImage(ImageSource.camera);
                        return Navigator.of(context).pop();
                      },
                      child: Text(
                        "카메라",
                      )),
                  CupertinoActionSheetAction(
                      onPressed: () {
                        getImage(ImageSource.gallery);
                        return Navigator.of(context).pop(ImageSource.gallery);
                      },
                      child: Text("갤러리"))
                ],
              ));
    } else {
      return showModalBottomSheet(
          context: context,
          builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.camera_alt,
                    ),
                    title: Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        "카메라",
                      ),
                    ),
                    onTap: () {
                      getImage(ImageSource.camera);
                      return Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.image),
                    title: Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: Text("갤러리")),
                    onTap: () {
                      getImage(ImageSource.gallery);
                      return Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    }
  }

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imagePath = File(image.path);
      setState(() {
        myimage = imagePath;
      });
    } on PlatformException catch (e) {
      print('Failed to get image $e');
    }
  }
}
