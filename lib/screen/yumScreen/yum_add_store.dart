import 'dart:io';
import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/Widgets/custom_loading_image.dart';
import 'package:deanora/Widgets/star_rating.dart';
import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/model/menu_by_store.dart';
import 'package:deanora/model/yum_store_list_composition.dart';
import 'package:deanora/provider/menu_provider.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/gery_border.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/yum_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class YumAddStore extends StatefulWidget {
  List<MenuByStore> menuList;
  final StoreComposition storeInfo;
  YumAddStore({required this.menuList, required this.storeInfo, Key? key})
      : super(key: key);

  @override
  State<YumAddStore> createState() => _YumAddStoreState();
}

class _YumAddStoreState extends State<YumAddStore> {
  final ScrollController _scrollController = ScrollController();
  TextEditingController addMenuAlias = TextEditingController();
  TextEditingController addMenuCost = TextEditingController();
  final _content = TextEditingController();
  late MenuProvider _menuProvider;
  File? myimage;
  int writeResult = -1;
  int isChecked = 0;
  int flag = 0;
  int _menuId = -1;
  bool isLoading = false;
  int _dropselected = -1;
  List<bool> isMenuChecked = [];
  List<MenuByStore> _menuList = [];
  List<DropdownMenuItem<String>> items = [];
  String? dropinit = "";
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
    _menuList = widget.menuList;

    for (int i = 0; i < widget.menuList.length; i++) {
      isMenuChecked.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    _menuProvider = Provider.of<MenuProvider>(context, listen: false);
    if (_menuList.length > 3) {
      items.clear();
      for (int i = 2; i < _menuList.length; i++) {
        items.add(
          DropdownMenuItem(
            child: Container(
              width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _menuList[i].menuAlias,
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${_menuList[i].cost.toString()}원',
                    style: TextStyle(fontSize: 7),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
            value: i.toString(),
          ),
        );
      }
      if (flag == 0) {
        dropinit = items[0].value.toString();
        flag = 1;
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 35),
            child: SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          padding: const EdgeInsets.all(0.0),
                          splashRadius: 20.0,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close_sharp),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "리뷰하기",
                          style: TextStyle(fontSize: 23),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              putimg(18.0, 18.0, "write_review_location"),
                              Text(
                                widget.storeInfo.storeAlias.toString(),
                                style: TextStyle(
                                    color: Color(0xff707070), fontSize: 13.0),
                              ),
                            ],
                          ),
                        ),
                        height: 40.0,
                        width: MediaQuery.of(context).size.width,
                        decoration: greyBorder(20.0),
                      ),
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          showBottomSheet(context);
                        },
                        child: Container(
                          height: 310,
                          width: MediaQuery.of(context).size.width,
                          decoration: greyBorder(15.0),
                          child: Center(
                            child: myimage == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      putimg(25.0, 25.0, "write_review_photo"),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "사진추가",
                                        style: TextStyle(
                                            color: Color(0xff707070),
                                            fontSize: 12.0),
                                      ),
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Image.file(
                                      File(myimage!.path),
                                      width: MediaQuery.of(context).size.width,
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
                        child: Material(
                          child: InkWell(
                            onTap: () {
                              showBottomSheet(context);
                            },
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                margin: const EdgeInsets.only(right: 15),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color(0xff707070),
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "사진 변경",
                                  style: TextStyle(
                                      color: Color(0xff707070),
                                      fontSize: 12.0,
                                      letterSpacing: -0.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "한줄평",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        height: 95,
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          controller: _content,
                          onTap: () {
                            _scrollToTop();
                          },
                          maxLines: 10,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: Color(0xffD6D6D6), fontSize: 13.0),
                            hintText: "리뷰를 작성해주세요",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xfff4f4f6),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
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
                        height: 30,
                      ),
                      Text(
                        "메뉴 추천",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      if (_menuList.length == 0)
                        Center(child: Text("등록된 메뉴가 없습니다"))
                      else if (_menuList.length <= 3)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _menuList.asMap().entries.map((e) {
                            var val = e.value;
                            int idx = e.key;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _menuId = val.menuId;
                                  for (int i = 0;
                                      i < isMenuChecked.length;
                                      i++) {
                                    setState(() {
                                      if (idx == i) {
                                        isMenuChecked[i] = true;
                                      } else {
                                        isMenuChecked[i] = false;
                                      }
                                    });
                                  }
                                });
                              },
                              child: Container(
                                height: 35,
                                width: 90,
                                margin: const EdgeInsets.all(5),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: greyBorderNChangeColor(
                                    5.0, isMenuChecked[idx]),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      val.menuAlias,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      '${val.cost.toString()}원',
                                      style: TextStyle(fontSize: 7),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      else if (_menuList.length > 3)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _menuId = _menuList[0].menuId;
                                  _dropselected = 1;
                                });
                              },
                              child: Container(
                                height: 35,
                                width: 90,
                                margin: const EdgeInsets.all(5),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: greyBorderNChangeColor(
                                    5.0, _dropselected == 1),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _menuList[0].menuAlias,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      '${_menuList[0].cost.toString()}원',
                                      style: TextStyle(fontSize: 7),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _menuId = _menuList[1].menuId;
                                  _dropselected = 2;
                                });
                              },
                              child: Container(
                                height: 35,
                                width: 90,
                                margin: const EdgeInsets.all(5),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: greyBorderNChangeColor(
                                    5.0, _dropselected == 2),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _menuList[1].menuAlias,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      '${_menuList[1].cost.toString()}원',
                                      style: TextStyle(fontSize: 7),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 35,
                              decoration:
                                  greyBorderNChangeColor(5, _dropselected == 3),
                              child: DropdownButton(
                                value: dropinit,
                                underline: SizedBox(),
                                items: items,
                                onChanged: (String? str) {
                                  setState(() {
                                    _menuId = _menuList[int.parse(str!)].menuId;
                                    _dropselected = 3;
                                    dropinit = str;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      Material(
                        color: Color(0xffF3F3F5),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                contentPadding:
                                    const EdgeInsets.only(top: 0, bottom: 10),
                                buttonPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 8),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18))),
                                content: Container(
                                  height: 130,
                                  width: 400,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Align(
                                            child: IconButton(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                splashRadius: 15,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(Icons.close)),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "메뉴 추가",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "NotoSansKR_Regular",
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                              width: 100,
                                              child: TextField(
                                                controller: addMenuAlias,
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                      color: Color(0xffD6D6D6),
                                                      fontSize: 13.0),
                                                  hintText: "메뉴명",
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
                                              )),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Container(
                                              width: 100,
                                              child: TextField(
                                                controller: addMenuCost,
                                                keyboardType:
                                                    TextInputType.number,
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  suffixText: "원",
                                                  suffixStyle: TextStyle(
                                                      color: Colors.black),
                                                  hintStyle: TextStyle(
                                                      color: Color(0xffD6D6D6),
                                                      fontSize: 13.0),
                                                  hintText: "가격",
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
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                                onPressed: () async {
                                                  try {
                                                    if (addMenuCost.text !=
                                                            "" &&
                                                        addMenuAlias.text !=
                                                            "") {
                                                      YumMenuhttp yumMenuhttp =
                                                          YumMenuhttp();

                                                      try {
                                                        int rst = await yumMenuhttp
                                                            .addMenu(
                                                                cost: int.parse(
                                                                    addMenuCost
                                                                        .text),
                                                                menuAlias:
                                                                    addMenuAlias
                                                                        .text
                                                                        .toString(),
                                                                storeId: widget
                                                                    .storeInfo
                                                                    .storeId
                                                                    .toString());
                                                        await _menuProvider
                                                            .getMenubyStore(
                                                                widget.storeInfo
                                                                    .storeId
                                                                    .toString());
                                                        _menuList =
                                                            await yumMenuhttp
                                                                .menuByStore(widget
                                                                    .storeInfo
                                                                    .storeId
                                                                    .toString());
                                                        setState(() {
                                                          isMenuChecked
                                                              .add(false);
                                                        });

                                                        Navigator.pop(context);
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              AlertDialog(
                                                            content:
                                                                Text('추가 완료'),
                                                            actions: [
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor:
                                                                          Color(
                                                                              0xff7D48D9)),
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(),
                                                                  child: Text(
                                                                      '확인')),
                                                            ],
                                                          ),
                                                        );
                                                      } catch (e) {
                                                        Navigator.pop(context);
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              AlertDialog(
                                                            content: Text(
                                                                ' 오류가 발생했습니다\n 잠시후에 다시 시도해주세요'),
                                                            actions: [
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor:
                                                                          Color(
                                                                              0xff7D48D9)),
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(),
                                                                  child: Text(
                                                                      '확인')),
                                                            ],
                                                          ),
                                                        );
                                                      }

                                                      addMenuAlias.clear();
                                                      addMenuCost.clear();
                                                    }
                                                  } catch (e) {
                                                    showdialog(context,
                                                        "가격에는 숫자만 입력해주세요");
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color(0xff7D48D9)),
                                                child: Text('저장')),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(),
                            height: 36,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
                                "메뉴 추가하기",
                                style: TextStyle(color: Color(0xffD6D6D6)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: [
                          Text(
                            "별점",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [1, 2, 3, 4, 5].map((e) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                isChecked = e;
                              });
                            },
                            child: StarRating(
                              isChecked: e <= isChecked ? true : false,
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                )),
          ),
          Positioned(
            right: 50,
            bottom: 50 + MediaQuery.of(context).viewInsets.bottom,
            child: SizedBox(
              width: 45,
              height: 45,
              child: renderFloatingActionButton(),
            ),
          ),
          Stack(
            children: [
              isLoading == false
                  ? Container()
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.grey.withOpacity(0.6),
                      child: Center(
                        child: Center(
                          child: CustomLoadingImage(),
                        ),
                      ),
                    ),
            ],
          )
        ],
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

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        if (myimage == null) {
          showdialog(
            context,
            "리뷰 사진을 등록해 주세요",
          );
        } else if (_content.text == "") {
          showdialog(
            context,
            "한줄평을 작성해 주세요",
          );
        } else if (_menuId == -1) {
          showdialog(
            context,
            "메뉴를 선택해주세요",
          );
        } else if (isChecked == 0) {
          showdialog(
            context,
            "별점을 선택해주세요",
          );
        } else {
          setState(() {
            isLoading = true;
          });

          await postReview(myimage?.path, _content.text, _menuId, isChecked,
              widget.storeInfo.storeId);
          setState(() {
            isLoading = false;
          });
          if (writeResult == 200) {
            setState(() {
              myimage = null;
              _content.clear();
              _menuId = -1;
              isChecked = 0;
              _dropselected = -1;
              writeResult = -1;
              for (int i = 0; i < isMenuChecked.length; i++) {
                isMenuChecked[i] = false;
              }
            });
            showdialog(context, "리뷰 완료");
          } else {
            showdialog(context, "리뷰 등록에 실패했습니다");
          }
        }
      },
      backgroundColor: Colors.black,
      child: Text(
        "저장",
        style: TextStyle(fontSize: 11.0),
      ),
    );
  }

  Future<void> postReview(file, content, menuId, score, storeId) async {
    var yumReviewhttp = YumReviewhttp();
    writeResult =
        await yumReviewhttp.writeReview(file, content, menuId, score, storeId);
  }
}
