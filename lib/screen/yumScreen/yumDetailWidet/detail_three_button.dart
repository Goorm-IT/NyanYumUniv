import 'dart:io';

import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/Widgets/star_rating.dart';
import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/model/menu_by_store.dart';
import 'package:deanora/model/yum_store_list_composition.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/gery_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ThreeButton extends StatefulWidget {
  bool isNull;
  String imagePath;
  List<MenuByStore> menuList;
  bool isBlack;
  final StoreComposition storeInfo;
  ThreeButton(
      {required this.isNull,
      required this.menuList,
      required this.storeInfo,
      required this.isBlack,
      this.imagePath = "",
      Key? key})
      : super(key: key);

  @override
  State<ThreeButton> createState() => _ThreeButtonState();
}

class _ThreeButtonState extends State<ThreeButton> {
  final ScrollController _scrollController = ScrollController();
  final _content = TextEditingController();
  File? myimage;
  int isChecked = 0;
  int _menuId = -1;
  int writeResult = -1;
  void _scrollToTop() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _scrollController.animateTo(MediaQuery.of(context).viewInsets.bottom,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: 28,
          child: ElevatedButton(
            onPressed: () {
              bool isLoading = false;
              isChecked = 0;

              showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      topLeft: Radius.circular(30.0)),
                ),
                isScrollControlled: true,
                builder: (context) {
                  return StatefulBuilder(builder:
                      (BuildContext context, StateSetter setModalState) {
                    FloatingActionButton renderFloatingActionButton() {
                      isLoading = false;
                      return FloatingActionButton(
                        onPressed: () async {
                          if (myimage == null) {
                            _showdialog(context, "이미지");
                          } else if (_content.text == "") {
                            _showdialog(context, "한줄평");
                          } else if (_menuId == -1) {
                            _showdialog(context, "메뉴");
                          } else if (isChecked == 0) {
                            _showdialog(context, "점수");
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            await postReview(myimage?.path, _content.text,
                                _menuId, isChecked, widget.storeInfo.storeId);
                            setState(() {
                              isLoading = false;
                            });
                          }
                          if (writeResult == 200) {
                            setModalState(() {
                              myimage = null;
                              _content.clear();
                              _menuId = -1;
                              isChecked = 0;
                            });
                            _showdialog(context, "리뷰 완료");
                          }
                        },
                        backgroundColor: Colors.black,
                        child: Text(
                          "저장",
                          style: TextStyle(fontSize: 11.0),
                        ),
                      );
                    }

                    return !isLoading
                        ? GestureDetector(
                            onTap: () => FocusScope.of(context).unfocus(),
                            child: Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 35),
                                  height:
                                      MediaQuery.of(context).size.height * 0.9,
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: SingleChildScrollView(
                                      controller: _scrollController,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 25.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              "리뷰하기",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            SizedBox(
                                              height: 25,
                                            ),
                                            Container(
                                              child: Center(
                                                child: Text(
                                                  "가게 찾기",
                                                  style: TextStyle(
                                                      color: Color(0xff707070),
                                                      fontSize: 12.0),
                                                ),
                                              ),
                                              height: 40.0,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: greyBorder(20.0),
                                            ),
                                            SizedBox(height: 15),
                                            GestureDetector(
                                              onTap: () {
                                                showBottomSheet(context);
                                              },
                                              child: Container(
                                                height: 310,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: greyBorder(15.0),
                                                child: Center(
                                                  child: myimage == null
                                                      ? Text(
                                                          "사진추가",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff707070),
                                                              fontSize: 12.0),
                                                        )
                                                      : ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                          child: Image.file(
                                                            File(myimage!.path),
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            height: 310,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: InkWell(
                                                onTap: () {
                                                  print("변경추가");
                                                },
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 15),
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                          color:
                                                              Color(0xff707070),
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "사진 변경 / 추가",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff707070),
                                                          fontSize: 12.0,
                                                          letterSpacing: -0.5),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "한줄평",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 95,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: TextField(
                                                controller: _content,
                                                onTap: () {
                                                  _scrollToTop();
                                                },
                                                maxLines: 10,
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                      color: Color(0xffD6D6D6),
                                                      fontSize: 13.0),
                                                  hintText: "20자 이상 작성해주세요",
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xfff4f4f6),
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xfff4f4f6),
                                                    ),
                                                  ),
                                                  fillColor: Color(0xfff4f4f6),
                                                  filled: true,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("메뉴 추천"),
                                            Wrap(
                                              children:
                                                  widget.menuList.map((e) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _menuId = e.menuId;
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 35,
                                                    width: 90,
                                                    margin:
                                                        const EdgeInsets.all(5),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 5),
                                                    decoration:
                                                        greyBorder(10.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          e.menuAlias,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                        Text(
                                                          '${e.cost.toString()}원',
                                                          style: TextStyle(
                                                              fontSize: 7),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                            SizedBox(
                                              height: 36,
                                              child: TextField(
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                      color: Color(0xffD6D6D6),
                                                      fontSize: 13.0),
                                                  hintText: "메뉴  추가하기는 어캐하는거지?",
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xfff4f4f6),
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xfff4f4f6),
                                                    ),
                                                  ),
                                                  fillColor: Color(0xfff4f4f6),
                                                  filled: true,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 24,
                                            ),
                                            Text("별점"),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children:
                                                  [1, 2, 3, 4, 5].map((e) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    setModalState(() {
                                                      isChecked = e;
                                                    });
                                                    print(isChecked);
                                                  },
                                                  child: StarRating(
                                                    isChecked: e <= isChecked
                                                        ? true
                                                        : false,
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                            Text("건의하기"),
                                          ],
                                        ),
                                      )),
                                ),
                                Positioned(
                                    right: 50,
                                    bottom: 50 +
                                        MediaQuery.of(context)
                                            .viewInsets
                                            .bottom,
                                    child: SizedBox(
                                        width: 45,
                                        height: 45,
                                        child: renderFloatingActionButton()))
                              ],
                            ),
                          )
                        : Container();
                  });
                },
                context: context,
              );
            },
            child: putimg(20.0, 20.0,
                widget.isBlack ? 'detail_review_black' : 'detail_review'),
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              padding: const EdgeInsets.all(0.0),
              shadowColor: Colors.transparent,
            ),
          ),
        ),
        Container(
          width: 28,
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              print("리뷰");
            },
            child: putimg(20.0, 20.0,
                widget.isBlack ? 'detail_like_black' : 'detail_like'),
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              padding: const EdgeInsets.all(0.0),
              shadowColor: Colors.transparent,
            ),
          ),
        ),
        Container(
          width: 30,
          height: 28,
          child: ElevatedButton(
            onPressed: () {
              print("리뷰");
            },
            child: putimg(20.0, 20.0,
                widget.isBlack ? 'detail_store_black' : 'detail_store'),
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              padding: const EdgeInsets.all(0.0),
              shadowColor: Colors.transparent,
            ),
          ),
        ),
      ],
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

                      print(myimage);
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

  Future<void> postReview(file, content, menuId, score, storeId) async {
    var yumReviewhttp = YumReviewhttp();
    writeResult =
        await yumReviewhttp.writeReview(file, content, menuId, score, storeId);
  }
}

Future<dynamic> _showdialog(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      content: Text('$message 추가하세요'),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(), child: Text('확인')),
      ],
    ),
  );
}