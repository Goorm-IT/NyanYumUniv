import 'package:async/async.dart';
import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/Widgets/star_rating.dart';
import 'package:deanora/Widgets/star_rating_demical.dart';
import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/model/menu_by_store.dart';
import 'package:deanora/model/review_by_store.dart';
import 'package:deanora/model/yum_store_list_composition.dart';
import 'package:deanora/provider/menu_provider.dart';
import 'package:deanora/provider/review_provider.dart';
import 'package:deanora/screen/yumScreen/yumDetailWidet/detail.naver_map.dart';
import 'package:deanora/screen/yumScreen/yumDetailWidet/detail_comment_list.dart';
import 'package:deanora/screen/yumScreen/yumDetailWidet/detail_main_image.dart';
import 'package:deanora/screen/yumScreen/yumDetailWidet/detail_photo_review.dart';
import 'package:deanora/screen/yumScreen/yumDetailWidet/detail_three_button.dart';
import 'package:deanora/screen/yumScreen/yum_review_notify.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'YumMainWidget/gery_border.dart';

class YumStoreDetail extends StatefulWidget {
  final StoreComposition storeInfo;
  final String naverMapUrl;

  const YumStoreDetail(
      {required this.storeInfo, required this.naverMapUrl, Key? key})
      : super(key: key);

  @override
  State<YumStoreDetail> createState() => _YumStoreDetailState();
}

class _YumStoreDetailState extends State<YumStoreDetail> {
  late BehaviorSubject<int> _isLike;
  late BehaviorSubject<int> _isSave;
  late String str;
  List<ReviewByStore> reviewList = [];
  List<MenuByStore> menuList = [];
  List<MenuByStore> recommendList = [];
  List<String> imagePathList = [];
  bool crossChange = true;
  bool _isLoading = false;
  double totalScrore = 0;
  var priceFormat = NumberFormat('###,###,###,###');
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {});
    _isLike = BehaviorSubject.seeded(0);
    _isSave = BehaviorSubject.seeded(0);
    for (int i = 0; i < context.read<ReviewProvider>().review.length; i++) {
      totalScrore += context.read<ReviewProvider>().review[i].score;
    }
    totalScrore /= context.read<ReviewProvider>().review.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer<MenuProvider>(
        builder: (menuProvidercontext, menuProvider, widgets) {
          return SafeArea(
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
                child: Column(
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
                              menuList: menuProvider.menu,
                              storeInfo: widget.storeInfo,
                              isLike: _isLike,
                              isSave: _isSave,
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
                                  menuList: menuProvider.menu,
                                  storeInfo: widget.storeInfo,
                                  isLike: _isLike,
                                  isSave: _isSave,
                                )
                              : MainImage(
                                  isNull: false,
                                  menuList: menuProvider.menu,
                                  storeInfo: widget.storeInfo,
                                  imagePath: widget.storeInfo.imagePath,
                                  isLike: _isLike,
                                  isSave: _isSave,
                                ),
                          SizedBox(
                            height: 30,
                          ),
                          Consumer<ReviewProvider>(
                            builder: (reviewProvidercontext, reviewprovider,
                                widgets) {
                              recommendList = menuProvider.menu
                                ..sort((a, b) =>
                                    b.choiceCount.compareTo(a.choiceCount));
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
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
                                      reviewList: reviewprovider.review,
                                      menuList: menuProvider.menu,
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        subTitle("한줄평"),
                                        SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            YumReviewNotify(
                                                              reviewList:
                                                                  reviewprovider
                                                                      .review,
                                                            )));
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  shadowColor:
                                                      Colors.transparent,
                                                  onPrimary: Colors.grey,
                                                  primary: Colors.transparent),
                                              child: putimg(
                                                  15.0, 15.0, 'notifyButton')),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    CommentList(
                                      reviewList: reviewprovider.review,
                                    ),
                                    Divider(
                                      height: 0,
                                      color: Color(0xffD6D6D6),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    subTitle(" 위치"),

                                    SizedBox(
                                      height: 12,
                                    ),
                                    // NaverMapInDetail(
                                    //   storeInfo: widget.storeInfo,
                                    // ),
                                    Container(
                                      width: 310,
                                      height: 170,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        child: Image.memory(Uri.parse(
                                                'data:image/jpeg;base64,${widget.naverMapUrl}')
                                            .data!
                                            .contentAsBytes()),
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
                                    SizedBox(height: 10.0),
                                    Divider(
                                      height: 0,
                                      color: Color(0xffD6D6D6),
                                    ),
                                    SizedBox(height: 20.0),
                                    subTitle("추천 메뉴"),
                                    SizedBox(height: 13.0),
                                    Row(
                                      children:
                                          recommendList.asMap().entries.map(
                                        (e) {
                                          MenuByStore<dynamic, dynamic> val =
                                              e.value;
                                          int idx = e.key;
                                          if (idx < 2) {
                                            return Expanded(
                                              child: Container(
                                                decoration: greyBorder(20.0),
                                                margin: (idx % 2) == 0
                                                    ? const EdgeInsets.only(
                                                        right: 5)
                                                    : const EdgeInsets.only(
                                                        left: 5),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Center(
                                                  child: Text(
                                                    '${val.menuAlias.toString()}    ${priceFormat.format(val.cost).toString()}원',
                                                    style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12.0),
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ).toList(),
                                    ),
                                    SizedBox(height: 10.0),
                                    recommendList.length > 3
                                        ? Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration: greyBorder(20.0),
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: Center(
                                                    child: Text(
                                                      '${recommendList[2].menuAlias.toString()}    ${priceFormat.format(recommendList[2].cost).toString()}원',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                    SizedBox(height: 8.0),
                                    Divider(
                                      height: 0,
                                      color: Color(0xffD6D6D6),
                                    ),
                                    SizedBox(height: 24.0),
                                    subTitle(
                                        '별점  ${totalScrore.toStringAsFixed(1)}'),
                                    SizedBox(height: 10.0),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [1, 2, 3, 4, 5].map((e) {
                                          bool _isChecked;
                                          bool _isDemical;
                                          double _demical = 0.0;
                                          if (totalScrore - e >= 0) {
                                            _isChecked = true;
                                            _isDemical = false;
                                          } else if (-1 < totalScrore - e &&
                                              totalScrore - e < 0) {
                                            _isDemical = true;
                                            _isChecked = true;
                                            _demical = -1 * (totalScrore - e);
                                          } else {
                                            _isChecked = false;
                                            _isDemical = false;
                                          }
                                          return Container(
                                            width: 50,
                                            child: StarRatingDemical(
                                              isChecked: _isChecked,
                                              isDemical: _isDemical,
                                              demical: _demical,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    SizedBox(height: 13.0),
                                    Divider(
                                      height: 0,
                                      color: Color(0xffD6D6D6),
                                    ),
                                    SizedBox(height: 24.0),
                                    subTitle("건의하기"),
                                    Container(
                                      width: 200,
                                      height: 400,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }

  Widget subTitle(title) {
    return Text(
      title,
      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
    );
  }
}
