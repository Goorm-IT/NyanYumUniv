import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/Widgets/custom_loading_image.dart';
import 'package:deanora/const/color.dart';
import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/menutabbar/custom_menu_tabbar.dart';
import 'package:deanora/model/yum_category_type.dart';
import 'package:deanora/model/yum_store_list_composition.dart';
import 'package:deanora/model/yum_top_5.dart';
import 'package:deanora/provider/menu_provider.dart';
import 'package:deanora/provider/review_provider.dart';
import 'package:deanora/provider/storeInfo_provider.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/gery_border.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/star_score.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/yum_category.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/yum_store_list_item.dart';
import 'package:deanora/screen/yumScreen/yum_my_profile.dart';
import 'package:deanora/screen/yumScreen/yum_store_detail.dart';
import 'package:deanora/screen/yumScreen/yum_store_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class YumMain extends StatefulWidget {
  const YumMain({Key? key}) : super(key: key);

  @override
  State<YumMain> createState() => _YumMainState();
}

class _YumMainState extends State<YumMain> {
  var top5Idx = 0;
  late BehaviorSubject<int> backButtonToggle;
  int willpop = 0;
  bool _isLoading = false;
  String checkedCategory = "";
  @override
  void initState() {
    super.initState();
    checkedCategory = "ALL";
    for (int i = 0; i < categorytype.length; i++) {
      if (i == 0) {
        categorytype[i].isChecked = true;
      } else {
        categorytype[i].isChecked = false;
      }
    }
    backButtonToggle = BehaviorSubject.seeded(-1);
  }

  changeCategory([String category = '']) async {
    _storeInfoProvider.loadStoreInfo(1, 1, category);
  }

  late ReviewProvider _reviewProvider;
  late MenuProvider _menuProvider;
  late StoreInfoProvider _storeInfoProvider;
  Widget build(BuildContext context) {
    _reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    _storeInfoProvider = Provider.of<StoreInfoProvider>(context, listen: false);
    _menuProvider = Provider.of<MenuProvider>(context, listen: false);
    final searchController = TextEditingController();
    final availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final yumStorehttp = YumStorehttp();
    if (checkedCategory == "ALL") {
      _storeInfoProvider.loadStoreInfo(1, 10);
    }
    return WillPopScope(
      onWillPop: () async {
        print('willpop $willpop');
        if (willpop == 1) {
          backButtonToggle.sink.add(1);
          return false;
        } else {
          backButtonToggle.sink.add(-1);
          return true;
        }
      },
      child: MaterialApp(
          home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                SafeArea(
                  bottom: false,
                  left: false,
                  right: false,
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 30,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () async {}, icon: Icon(Icons.place)),
                          Container(
                              width: MediaQuery.of(context).size.width - 140,
                              child: TextField(
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: PRIMARY_COLOR_DEEP),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: PRIMARY_COLOR_DEEP),
                                  ),
                                ),
                                controller: searchController,
                              )),
                          IconButton(
                              onPressed: () async {
                                var naverOpneApi = NaverOpneApi();
                                List tmp = await naverOpneApi
                                    .naverSearchLocal(searchController.text);
                                print(tmp);
                              },
                              icon: Icon(Icons.search))
                        ],
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "이달의 Top5",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                    future: yumStorehttp.storeTop5(),
                    builder: (futerContext,
                        AsyncSnapshot<List<StoreComposition>> snap) {
                      if (!snap.hasData) {
                        return CustomLoadingImage();
                      }
                      if (snap.hasData && snap.data!.isEmpty) {
                        return Center(child: Text("가게 정보가 없습니다."));
                      }
                      List<StoreComposition>? top5List = snap.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CarouselSlider(
                            items: top5List!.map((e) {
                              return Builder(
                                builder: (BuildContext carouselSlidercontext) {
                                  return Container(
                                    margin: EdgeInsets.only(right: 15.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        await _menuProvider.getMenubyStore(
                                            e.storeId.toString());
                                        await _reviewProvider.getReviewByStore(
                                            e.storeId.toString());

                                        setState(() {
                                          _isLoading = false;
                                        });
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                YumStoreDetail(
                                              storeInfo: e,
                                            ),
                                          ),
                                        );
                                      },
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: e.imagePath != null
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: CachedNetworkImage(
                                                    fadeInDuration:
                                                        const Duration(
                                                            milliseconds: 100),
                                                    fadeOutDuration:
                                                        const Duration(
                                                            milliseconds: 100),
                                                    imageUrl: e.imagePath,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context,
                                                            url) =>
                                                        CustomLoadingImage(),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                )
                                              : Container(
                                                  color: Color(0xffd6d6d6),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Image.asset(
                                                    'assets/images/defaultImg.png',
                                                  ),
                                                )),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                            options: CarouselOptions(
                                height: 180,
                                autoPlay: false,
                                viewportFraction: 0.9,
                                enableInfiniteScroll: false,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    top5Idx = index;
                                  });
                                }),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 25,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: Text(
                                '${top5List[top5Idx].storeAlias}',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: FutureBuilder<Object>(
                                future: getStoreReview(
                                    top5List[top5Idx].storeId.toString()),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Container(
                                      margin:
                                          const EdgeInsets.only(right: 20.0),
                                      child: Text(
                                        snapshot.data.toString(),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Row(
                              children: [
                                FutureBuilder<Object>(
                                    future: getStoreMenu(
                                        top5List[top5Idx].storeId.toString()),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Container(
                                          padding: const EdgeInsets.all(3.0),
                                          decoration: greyBorder(5.0),
                                          child: Row(
                                            children: [
                                              snapshot.data == "아직 리뷰가 없습니다."
                                                  ? Container()
                                                  : putimg(
                                                      14.0, 12.0, "thumbs"),
                                              Text(
                                                ' ${snapshot.data.toString()}',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }),
                                SizedBox(
                                  width: 5.0,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(4.0),
                                  decoration: greyBorder(5.0),
                                  child: StarScore(
                                    score: top5List[top5Idx].score,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 80),
                          Padding(
                            padding: const EdgeInsets.only(left: 18),
                            child: Row(
                              children: [
                                Text(
                                  "맛집 List",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(width: 20),
                                Container(
                                  width: 18,
                                  height: 18,
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  YumStoreList(
                                                      availableHeight:
                                                          availableHeight)));
                                    },
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        boxShadow: [
                                          BoxShadow(
                                            spreadRadius: 0.0,
                                            blurRadius: 0.0,
                                          )
                                        ],
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: Icon(
                                        Icons.chevron_right,
                                        color: Colors.black,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            height: 25,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: categorytype.map((e) {
                                      return GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            checkedCategory = e.title;
                                          });
                                          for (int i = 0;
                                              i < categorytype.length;
                                              i++) {
                                            setState(() {
                                              if (e.title ==
                                                  categorytype[i].title) {
                                                categorytype[i].isChecked =
                                                    true;
                                              } else {
                                                categorytype[i].isChecked =
                                                    false;
                                              }
                                            });
                                          }
                                          checkedCategory == 'ALL'
                                              ? await changeCategory()
                                              : await changeCategory(
                                                  checkedCategory);
                                        },
                                        child: YumCategory(
                                          color: e.color,
                                          title: e.title,
                                          isChecked: e.isChecked,
                                        ),
                                      );
                                    }).toList(),
                                  )),
                            ),
                          ),
                          SizedBox(height: 20),
                          Consumer<StoreInfoProvider>(
                            builder: (providercontext, provider, widgets) {
                              if (provider.storeInfo != [] &&
                                  provider.storeInfo.length > 0) {
                                return GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await _menuProvider.getMenubyStore(provider
                                        .storeInfo[0].storeId
                                        .toString());
                                    await _reviewProvider.getReviewByStore(
                                        provider.storeInfo[0].storeId
                                            .toString());

                                    setState(() {
                                      _isLoading = false;
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => YumStoreDetail(
                                          storeInfo: provider.storeInfo[0],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: (availableHeight - 112) / 5,
                                    child: StoreListItem(
                                      height: (availableHeight - 112) / 5,
                                      imagePath:
                                          provider.storeInfo[0].imagePath,
                                      storeAlias:
                                          provider.storeInfo[0].storeAlias,
                                      score: provider.storeInfo[0].score,
                                      storeId: provider.storeInfo[0].storeId,
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ],
                      );
                    })
              ],
            ),
            CustomMenuTabbar(
              menuTabBarToggle: (int id) {
                willpop = id;
              },
              backButtonToggle: backButtonToggle,
              parentsContext: context,
            ),
            _isLoading
                ? Stack(
                    children: [
                      Opacity(
                        opacity: 0.5,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          color: Colors.grey,
                        ),
                      ),
                      Center(
                        child: CustomLoadingImage(),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      )),
    );
  }

  Future<String> getStoreReview(String storeId) async {
    final yumReviewhttp = YumReviewhttp();
    final _list = await yumReviewhttp.commentByStore(storeId);
    if (_list[0].reviewId == -1) {
      return "아직 리뷰가 없습니다.";
    } else {
      return _list[0].content;
    }
  }

  Future<String> getStoreMenu(String storeId) async {
    final yumMenuhttp = YumMenuhttp();
    final _list = await yumMenuhttp.menuByStore(storeId);
    _list.sort((a, b) => b.choiceCount.compareTo(a.choiceCount));

    if (_list.isEmpty) {
      return "아직 리뷰가 없습니다.";
    } else {
      return _list[0].menuAlias;
    }
  }
}
