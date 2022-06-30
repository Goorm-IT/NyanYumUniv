import 'dart:io';
import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/Widgets/custom_loading_image.dart';
import 'package:deanora/Widgets/star_rating.dart';
import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/model/menu_by_store.dart';
import 'package:deanora/model/review_by_store.dart';
import 'package:deanora/model/yum_store_list_composition.dart';
import 'package:deanora/screen/yumScreen/yumDetailWidet/detail.naver_map.dart';
import 'package:deanora/screen/yumScreen/yumDetailWidet/detail_comment_list.dart';
import 'package:deanora/screen/yumScreen/yumDetailWidet/detail_main_image.dart';
import 'package:deanora/screen/yumScreen/yumDetailWidet/detail_photo_review.dart';
import 'package:deanora/screen/yumScreen/yumDetailWidet/detail_three_button.dart';
import 'package:deanora/screen/yumScreen/yum_reivew_detail.dart';
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
                                isBlack: true,
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
                                  PhotoReViewIndetail(
                                    imagePathList: imagePathList,
                                    reviewList: reviewList,
                                    menuList: menuList,
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
                                  NaverMapInDetail(
                                    storeInfo: widget.storeInfo,
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
