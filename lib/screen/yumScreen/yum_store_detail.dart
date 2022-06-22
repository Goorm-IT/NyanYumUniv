import 'dart:io';

import 'package:async/async.dart';
import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/Widgets/custom_loading_image.dart';
import 'package:deanora/Widgets/star_rating.dart';
import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/object/menu_by_store.dart';
import 'package:deanora/object/review_by_store.dart';
import 'package:deanora/object/yum_store_list_composition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'dart:async';

import 'YumMainWidget/gery_border.dart';

class YumStoreDetail extends StatefulWidget {
  final StoreComposition storeInfo;
  const YumStoreDetail({required this.storeInfo, Key? key}) : super(key: key);

  @override
  State<YumStoreDetail> createState() => _YumStoreDetailState();
}

class _YumStoreDetailState extends State<YumStoreDetail> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  List<ReviewByStore> reviewList = [];
  List<MenuByStore> menuList = [];
  List<String> imagePathList = [];
  bool crossChange = true;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<NaverMapController> _controller = Completer();
  final ScrollController _scrollController = ScrollController();
  void _scrollToTop() {
    setState(() {
      _scrollController.animateTo(0,
          duration: Duration(milliseconds: 200), curve: Curves.ease);
    });
  }

  void _scrollToDown() {
    setState(() {
      _scrollController.animateTo(335,
          duration: Duration(milliseconds: 200), curve: Curves.ease);
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: Listener(
          onPointerUp: (e) {
            if (_scrollController.offset < 140) {
              _scrollToTop();
              crossChange = true;
            } else if (_scrollController.offset > 140) {
              if (_scrollController.offset < 335) {
                _scrollToDown();
              }
              setState(() {
                crossChange = false;
              });
            }
          },
          child: FutureBuilder(
              future: getReviewNMenu(widget.storeInfo.storeId.toString()),
              builder: (futureContext, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      AnimatedCrossFade(
                        firstChild: Container(),
                        secondChild: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 55.0),
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.storeInfo.storeAlias,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                              ThreeButton(
                                isNull: false,
                                menuList: menuList,
                                storeInfo: widget.storeInfo,
                              ),
                            ],
                          ),
                        ),
                        crossFadeState: crossChange
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: Duration(milliseconds: 350),
                      ),
                      Expanded(
                        child: ListView(
                          controller: _scrollController,
                          children: [
                            widget.storeInfo.imagePath == null
                                ? MainImage(
                                    isNull: true,
                                    menuList: menuList,
                                    storeInfo: widget.storeInfo,
                                  )
                                : MainImage(
                                    isNull: false,
                                    menuList: menuList,
                                    storeInfo: widget.storeInfo,
                                    imagePath: widget.storeInfo.imagePath,
                                  ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 55.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.storeInfo.storeAlias,
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Divider(
                                    height: 0,
                                    color: Color(0xffD6D6D6),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  subTitle("포토리뷰"),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: imagePathList.length > 5
                                          ? [0, 1, 2, 3, 4].map((e) {
                                              if (e != 4) {
                                                return Container(
                                                  width: 50,
                                                  height: 50,
                                                  child: Image.network(
                                                    imagePathList[e],
                                                    fit: BoxFit.fill,
                                                  ),
                                                );
                                              } else {
                                                return Stack(
                                                  children: [
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      child: Image.network(
                                                        imagePathList[e],
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                    Opacity(
                                                      opacity: 0.8,
                                                      child: Container(
                                                        width: 50,
                                                        height: 50,
                                                        color:
                                                            Color(0xff53535380),
                                                        child: Center(
                                                            child: Text(
                                                          "더보기",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                      ),
                                                    )
                                                  ],
                                                );
                                              }
                                            }).toList()
                                          : imagePathList.length == 5
                                              ? imagePathList.map((e) {
                                                  return Container(
                                                    width: 50,
                                                    height: 50,
                                                    child: Image.network(
                                                      e,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  );
                                                }).toList()
                                              : [0, 1, 2, 3, 4].map((e) {
                                                  print(
                                                      '${imagePathList.length} 이미지 길이');
                                                  if (imagePathList.length >
                                                      e) {
                                                    return Container(
                                                      width: 50,
                                                      height: 50,
                                                      child: Image.network(
                                                        imagePathList[e],
                                                        fit: BoxFit.fill,
                                                      ),
                                                    );
                                                  } else {
                                                    return Container(
                                                        width: 50,
                                                        height: 50,
                                                        color:
                                                            Color(0xffD6D6D6));
                                                  }
                                                }).toList()),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Divider(
                                    height: 0,
                                    color: Color(0xffD6D6D6),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  subTitle("한줄평"),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  CommentList(
                                    reviewList: reviewList,
                                  ),
                                  Divider(
                                    height: 0,
                                    color: Color(0xffD6D6D6),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  subTitle("위치"),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    child: Container(
                                      height: 150,
                                      width: MediaQuery.of(context).size.width,
                                      child: NaverMap(
                                        onMapCreated: _onMapCreated,
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(37.394614, 126.923451),
                                          zoom: 17,
                                        ),
                                        markers: [
                                          Marker(
                                              captionText:
                                                  widget.storeInfo.storeAlias,
                                              captionOffset: -45,
                                              width: 23,
                                              height: 30,
                                              markerId:
                                                  widget.storeInfo.storeAlias,
                                              position:
                                                  LatLng(37.394614, 126.923451))
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      putimg(10.0, 15.0, 'maker_icon'),
                                      Text(
                                        widget.storeInfo.address ?? " ",
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 200,
                                    height: 400,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container(
                    child: Center(
                      child: CustomLoadingImage(),
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }

  void _onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }

  Widget subTitle(title) {
    return Text(
      title,
      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
    );
  }

  Future<void> getReviewNMenu(String storeId) async {
    return this._memoizer.runOnce(() async {
      var yumReviewhttp = YumReviewhttp();
      List _reviewList = await yumReviewhttp.reviewByStore(storeId);

      var yumMenuhttp = YumMenuhttp();
      List _menuList = await yumMenuhttp.menuByStore(storeId);

      if (_reviewList.isNotEmpty) {
        setState(() {
          for (int i = 0; i < _reviewList.length; i++) {
            reviewList.add(ReviewByStore(
              _reviewList[i]['reviewId'],
              _reviewList[i]['userAlias'],
              _reviewList[i]['storeId'],
              _reviewList[i]['menuId'],
              _reviewList[i]['score'],
              _reviewList[i]['content'],
              _reviewList[i]['imagePath'],
              _reviewList[i]['propose'],
              _reviewList[i]['delete'],
              _reviewList[i]['registerDate'],
            ));
            if (_reviewList[i]['imagePath'] != null) {
              imagePathList.add(_reviewList[i]['imagePath']);
            }
          }
        });
      }

      if (_menuList.isNotEmpty) {
        setState(() {
          for (int i = 0; i < _menuList.length; i++) {
            menuList.add(MenuByStore(
                _menuList[i]['menuId'],
                _menuList[i]['menuAlias'],
                _menuList[i]['storeId'],
                _menuList[i]['cost'],
                _menuList[i]['choiceCount']));
          }
        });
      }
      return 1;
    });
  }
}

class CommentList extends StatelessWidget {
  List<ReviewByStore> reviewList;
  CommentList({required this.reviewList, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: reviewList.map((e) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 2, right: 3),
                        width: 1,
                        height: 8,
                        color: Color(0xffD6D6D6)),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        e.content,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                Text(e.userAlias,
                    style: TextStyle(color: Color(0xffD6D6D6), fontSize: 12))
              ],
            ),
          );
        }).toList(),
      )),
    );
  }
}

class MainImage extends StatefulWidget {
  bool isNull;
  String imagePath;
  List<MenuByStore> menuList;
  final StoreComposition storeInfo;
  MainImage(
      {required this.isNull,
      required this.menuList,
      required this.storeInfo,
      this.imagePath = "",
      Key? key})
      : super(key: key);

  @override
  State<MainImage> createState() => _MainImageState();
}

class _MainImageState extends State<MainImage> {
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
    return Stack(
      children: [
        Container(
          height: 225,
          width: MediaQuery.of(context).size.width,
          child: widget.isNull
              ? Container(
                  color: Color(0xffF3F3F5),
                  child: Center(
                    child: Image.asset(
                      'assets/images/default_nobackground.png',
                      fit: BoxFit.fill,
                      width: 88,
                    ),
                  ),
                )
              : Image.network(
                  widget.imagePath,
                  fit: BoxFit.fill,
                ),
        ),
        Opacity(
          opacity: 0.7,
          child: Container(
            height: 35,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.black, Colors.transparent]),
            ),
          ),
        ),
        ThreeButton(
          isNull: false,
          menuList: widget.menuList,
          storeInfo: widget.storeInfo,
        ),
      ],
    );
  }
}

class ThreeButton extends StatefulWidget {
  bool isNull;
  String imagePath;
  List<MenuByStore> menuList;
  final StoreComposition storeInfo;
  ThreeButton(
      {required this.isNull,
      required this.menuList,
      required this.storeInfo,
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
            child: putimg(20.0, 20.0, 'detail_review'),
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
            child: putimg(20.0, 20.0, 'detail_like'),
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
            child: putimg(20.0, 20.0, 'detail_store'),
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
