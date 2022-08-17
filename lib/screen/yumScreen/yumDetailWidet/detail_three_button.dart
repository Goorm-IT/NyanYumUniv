import 'dart:io';
import 'package:async/async.dart';
import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/Widgets/star_rating.dart';
import 'package:deanora/const/color.dart';
import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/model/menu_by_store.dart';
import 'package:deanora/model/yum_store_list_composition.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/gery_border.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/yum_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

class ThreeButton extends StatefulWidget {
  bool isNull;

  String imagePath;
  List<MenuByStore> menuList;
  bool isBlack;
  BehaviorSubject<int> isLike;
  BehaviorSubject<int> isSave;
  final StoreComposition storeInfo;
  ThreeButton(
      {required this.isNull,
      required this.menuList,
      required this.storeInfo,
      required this.isBlack,
      required this.isLike,
      required this.isSave,
      this.imagePath = "",
      Key? key})
      : super(key: key);

  @override
  State<ThreeButton> createState() => _ThreeButtonState();
}

class _ThreeButtonState extends State<ThreeButton>
    with TickerProviderStateMixin {
  final AsyncMemoizer<int> _memoizer1 = AsyncMemoizer();
  final AsyncMemoizer<int> _memoizer2 = AsyncMemoizer();

  final ScrollController _scrollController = ScrollController();
  final _content = TextEditingController();
  TextEditingController addMenuAlias = TextEditingController();
  TextEditingController addMenuCost = TextEditingController();
  File? myimage;
  int isChecked = 0;
  int _menuId = -1;
  int writeResult = -1;
  bool isLikeLoading = false;
  bool isSaveLoading = false;
  late AnimationController isLikeAnimationController;
  late AnimationController isSaveAnimationController;

  List<bool> isMenuChecked = [];
  void _scrollToTop() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _scrollController.animateTo(MediaQuery.of(context).viewInsets.bottom,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      });
    });
  }

  @override
  void dispose() {
    isLikeAnimationController.dispose();
    isSaveAnimationController.dispose();
    addMenuAlias.dispose();
    addMenuCost.dispose();
    super.dispose();
  }

  getlikeinit() {
    return this._memoizer1.runOnce(() async {
      LikeApi likeApi = LikeApi();
      int tmp = await likeApi.checkLike(widget.storeInfo.storeId.toString());
      widget.isLike.sink.add(tmp);
      return tmp;
    });
  }

  getsaveinit() {
    return this._memoizer2.runOnce(() async {
      SaveApi saveApi = SaveApi();
      int tmp = await saveApi.checkSave(widget.storeInfo.storeId.toString());
      widget.isSave.sink.add(tmp);
      return tmp;
    });
  }

  @override
  void initState() {
    super.initState();
    isLikeAnimationController =
        AnimationController(duration: new Duration(seconds: 2), vsync: this);
    isLikeAnimationController.repeat(reverse: true);
    isSaveAnimationController =
        AnimationController(duration: new Duration(seconds: 2), vsync: this);
    isSaveAnimationController.repeat(reverse: true);

    _scrollController.addListener(() {});
    for (int i = 0; i < widget.menuList.length; i++) {
      isMenuChecked.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> items = [];
    String? dropinit = "";
    if (widget.menuList.length > 3) {
      items.clear();
      for (int i = 0; i < widget.menuList.length; i++) {
        items.add(DropdownMenuItem(
          child: Container(
            width: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.menuList[i].menuAlias,
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${widget.menuList[i].cost.toString()}원',
                  style: TextStyle(fontSize: 7),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
          value: i.toString(),
        ));
      }
      dropinit = items[0].value.toString();
    }
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
              myimage = null;
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
                            showdialog(
                              context,
                              "이미지",
                            );
                          } else if (_content.text == "") {
                            showdialog(
                              context,
                              "한줄평",
                            );
                          } else if (_menuId == -1) {
                            showdialog(
                              context,
                              "메뉴",
                            );
                          } else if (isChecked == 0) {
                            showdialog(
                              context,
                              "점수",
                            );
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
                            showdialog(context, "리뷰 완료");
                          }
                        },
                        backgroundColor: Colors.black,
                        child: Text(
                          "저장",
                          style: TextStyle(fontSize: 11.0),
                        ),
                      );
                    }

                    if (!isLoading) {
                      return GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 35),
                              height: MediaQuery.of(context).size.height * 0.85,
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: SingleChildScrollView(
                                  controller: _scrollController,
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 25.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                putimg(18.0, 18.0,
                                                    "write_review_location"),
                                                Text(
                                                  "  가게 찾기",
                                                  style: TextStyle(
                                                      color: Color(0xff707070),
                                                      fontSize: 12.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                          height: 40.0,
                                          width:
                                              MediaQuery.of(context).size.width,
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
                                                  ? Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        putimg(25.0, 25.0,
                                                            "write_review_photo"),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          "사진추가",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff707070),
                                                              fontSize: 12.0),
                                                        ),
                                                      ],
                                                    )
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      child: Image.file(
                                                        File(myimage!.path),
                                                        width: MediaQuery.of(
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
                                          child: Material(
                                            child: InkWell(
                                              onTap: () {
                                                showBottomSheet(context);
                                              },
                                              child: Material(
                                                color: Colors.transparent,
                                                child: Container(
                                                  margin: const EdgeInsets.only(
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
                                                    "사진 변경",
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
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "한줄평",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        SizedBox(
                                          height: 95,
                                          width:
                                              MediaQuery.of(context).size.width,
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
                                          height: 30,
                                        ),
                                        Text(
                                          "메뉴 추천",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        if (widget.menuList.length == 0)
                                          Center(child: Text("등록된 메뉴가 없습니다"))
                                        else if (widget.menuList.length <= 3)
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: widget.menuList
                                                .asMap()
                                                .entries
                                                .map((e) {
                                              var val = e.value;
                                              int idx = e.key;

                                              return GestureDetector(
                                                onTap: () {
                                                  setModalState(() {
                                                    _menuId = val.menuId;
                                                    for (int i = 0;
                                                        i <
                                                            isMenuChecked
                                                                .length;
                                                        i++) {
                                                      setModalState(() {
                                                        if (idx == i) {
                                                          isMenuChecked[i] =
                                                              true;
                                                        } else {
                                                          isMenuChecked[i] =
                                                              false;
                                                        }
                                                      });
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  height: 35,
                                                  width: 90,
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  decoration:
                                                      greyBorderNChangeColor(
                                                          5.0,
                                                          isMenuChecked[idx]),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        val.menuAlias,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                        '${val.cost.toString()}원',
                                                        style: TextStyle(
                                                            fontSize: 7),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          )
                                        else if (widget.menuList.length > 3)
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 35,
                                                width: 90,
                                                margin: const EdgeInsets.all(5),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                decoration:
                                                    greyBorderNChangeColor(
                                                        5.0, isMenuChecked[0]),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      widget.menuList[0]
                                                          .menuAlias,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    Text(
                                                      '${widget.menuList[0].cost.toString()}원',
                                                      style: TextStyle(
                                                          fontSize: 7),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 35,
                                                width: 90,
                                                margin: const EdgeInsets.all(5),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                decoration:
                                                    greyBorderNChangeColor(
                                                        5.0, isMenuChecked[1]),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      widget.menuList[1]
                                                          .menuAlias,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    Text(
                                                      '${widget.menuList[1].cost.toString()}원',
                                                      style: TextStyle(
                                                          fontSize: 7),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 35,
                                                decoration: greyBorder(5),
                                                child: DropdownButton(
                                                  value: dropinit,
                                                  underline: SizedBox(),
                                                  items: items,
                                                  onChanged: (String? str) {
                                                    setModalState(() {
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
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          top: 0, bottom: 10),
                                                  buttonPadding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(0, 0, 0, 8),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  18))),
                                                  content: Container(
                                                    height: 130,
                                                    width: 400,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        IconButton(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            splashRadius: 15,
                                                            onPressed: () {},
                                                            icon: Icon(
                                                                Icons.close)),
                                                        Text(
                                                          "메뉴 추가",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                "NotoSansKR_Regular",
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                                width: 100,
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      addMenuAlias,
                                                                  maxLines: 1,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    hintStyle: TextStyle(
                                                                        color: Color(
                                                                            0xffD6D6D6),
                                                                        fontSize:
                                                                            13.0),
                                                                    hintText:
                                                                        "메뉴명",
                                                                    enabledBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0xfff4f4f6),
                                                                      ),
                                                                    ),
                                                                    focusedBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0xfff4f4f6),
                                                                      ),
                                                                    ),
                                                                    fillColor:
                                                                        Color(
                                                                            0xfff4f4f6),
                                                                    filled:
                                                                        true,
                                                                  ),
                                                                )),
                                                            SizedBox(
                                                              width: 20,
                                                            ),
                                                            Container(
                                                                width: 100,
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      addMenuCost,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  maxLines: 1,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    suffixText:
                                                                        "원",
                                                                    suffixStyle:
                                                                        TextStyle(
                                                                            color:
                                                                                Colors.black),
                                                                    hintStyle: TextStyle(
                                                                        color: Color(
                                                                            0xffD6D6D6),
                                                                        fontSize:
                                                                            13.0),
                                                                    hintText:
                                                                        "가격",
                                                                    enabledBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0xfff4f4f6),
                                                                      ),
                                                                    ),
                                                                    focusedBorder:
                                                                        UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0xfff4f4f6),
                                                                      ),
                                                                    ),
                                                                    fillColor:
                                                                        Color(
                                                                            0xfff4f4f6),
                                                                    filled:
                                                                        true,
                                                                  ),
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 20),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 40),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                        if (addMenuCost.text !=
                                                                                "" &&
                                                                            addMenuAlias.text !=
                                                                                "") {
                                                                          YumMenuhttp
                                                                              yumMenuhttp =
                                                                              YumMenuhttp();

                                                                          int rst = await yumMenuhttp.addMenu(
                                                                              cost: int.parse(addMenuCost.text),
                                                                              menuAlias: addMenuAlias.text.toString(),
                                                                              storeId: widget.storeInfo.storeId.toString());
                                                                          addMenuAlias
                                                                              .clear();
                                                                          addMenuCost
                                                                              .clear();
                                                                          Navigator.pop(
                                                                              context);
                                                                          if (rst ==
                                                                              200) {
                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) => AlertDialog(
                                                                                content: Text('추가 완료'),
                                                                                actions: [
                                                                                  ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: Text('확인')),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          }
                                                                        }
                                                                      },
                                                                      style: ElevatedButton.styleFrom(
                                                                          primary: Color(
                                                                              0xff7D48D9)),
                                                                      child: Text(
                                                                          '저장')),
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
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Center(
                                                child: Text(
                                                  "메뉴 추가하기",
                                                  style: TextStyle(
                                                      color: Color(0xffD6D6D6)),
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
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [1, 2, 3, 4, 5].map((e) {
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
                                        Text(
                                          "건의하기",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            Positioned(
                                right: 50,
                                bottom: 50 +
                                    MediaQuery.of(context).viewInsets.bottom,
                                child: SizedBox(
                                    width: 45,
                                    height: 45,
                                    child: renderFloatingActionButton()))
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
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
        FutureBuilder(
          future: getlikeinit(),
          builder: (futurecontext, AsyncSnapshot<int> futuresnapshot) {
            if (futuresnapshot.hasData) {
              return StreamBuilder(
                  stream: widget.isLike.stream,
                  builder: (context, snapshot) {
                    return Container(
                      width: 28,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          isLikeLoading = true;
                          LikeApi likeApi = LikeApi();
                          await likeApi
                              .likeOnOff(widget.storeInfo.storeId.toString());
                          int tmp = await likeApi
                              .checkLike(widget.storeInfo.storeId.toString());
                          widget.isLike.sink.add(tmp);

                          isLikeLoading = false;
                        },
                        child: isLikeLoading
                            ? Container(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: isLikeAnimationController.drive(
                                      ColorTween(
                                          begin: PRIMARY_COLOR_DEEP,
                                          end: Colors.red)),
                                ),
                              )
                            : putimg(
                                20.0,
                                20.0,
                                widget.isLike.value == 1
                                    ? 'detail_like_color'
                                    : widget.isBlack
                                        ? 'detail_like_black'
                                        : 'detail_like'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          padding: const EdgeInsets.all(0.0),
                          shadowColor: Colors.transparent,
                        ),
                      ),
                    );
                  });
            } else {
              return Container();
            }
          },
        ),
        FutureBuilder(
          future: getsaveinit(),
          builder: (futurecontext, AsyncSnapshot<int> futuresnapshot) {
            if (futuresnapshot.hasData) {
              return StreamBuilder(
                  stream: widget.isSave.stream,
                  builder: (context, snapshot) {
                    return Container(
                      width: 28,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          isSaveLoading = true;
                          SaveApi saveApi = SaveApi();
                          await saveApi
                              .saveOnOff(widget.storeInfo.storeId.toString());
                          int tmp = await saveApi
                              .checkSave(widget.storeInfo.storeId.toString());
                          widget.isSave.sink.add(tmp);

                          isSaveLoading = false;
                        },
                        child: isSaveLoading
                            ? Container(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: isSaveAnimationController.drive(
                                      ColorTween(
                                          begin: PRIMARY_COLOR_DEEP,
                                          end: Colors.red)),
                                ),
                              )
                            : putimg(
                                20.0,
                                20.0,
                                widget.isSave.value == 1
                                    ? 'detail_save_color'
                                    : widget.isBlack
                                        ? 'detail_save_black'
                                        : 'detail_save'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          padding: const EdgeInsets.all(0.0),
                          shadowColor: Colors.transparent,
                        ),
                      ),
                    );
                  });
            } else {
              return Container();
            }
          },
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
