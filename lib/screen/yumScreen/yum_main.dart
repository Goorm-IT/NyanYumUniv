import 'package:carousel_slider/carousel_slider.dart';
import 'package:deanora/Widgets/custom_loading_image.dart';
import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/menutabbar/custom_menu_tabbar.dart';
import 'package:deanora/object/yum_category_type.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/star_score.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/yum_category.dart';
import 'package:deanora/screen/yumScreen/yum_my_profile.dart';
import 'package:deanora/screen/yumScreen/yum_store_list.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    backButtonToggle = BehaviorSubject.seeded(-1);
  }

  Widget build(BuildContext context) {
    final availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    print(availableHeight);
    final yumStorehttp = YumStorehttp();
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
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  bottom: false,
                  left: false,
                  right: false,
                  child: SizedBox(
                    height: 55,
                    child: Text("위치? 검색"),
                  ),
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
                    builder: (futerContext, AsyncSnapshot<List<dynamic>> snap) {
                      if (!snap.hasData) {
                        return CustomLoadingImage();
                      }
                      if (snap.hasData && snap.data!.isEmpty) {
                        return Center(child: Text("가게 정보가 없습니다."));
                      }
                      List top5List = snap.data as List;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CarouselSlider(
                            items: top5List.map((e) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    margin: EdgeInsets.only(right: 15.0),
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: e["path"] != null
                                            ? Image.network(
                                                e["path"],
                                                fit: BoxFit.cover,
                                              )
                                            : Container(
                                                width: 140,
                                                child: Image.asset(
                                                  'assets/images/defaultImg.png',
                                                ),
                                              )),
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
                                    print(top5Idx);
                                  });
                                }),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Text(
                              '${top5List[top5Idx]["storeAlias"]}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w800),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child:
                                Text('${top5List[top5Idx]["storeAlias"]} 의 한줄평',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Row(
                              children: [
                                Container(
                                  decoration: greyBorder(5.0),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0, vertical: 1.0),
                                    child: Text(
                                      "추천 메뉴 & 가격",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Container(
                                  decoration: greyBorder(5.0),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0, vertical: 1.0),
                                    child: StarScore(
                                      score: top5List[top5Idx]["score"],
                                    ),
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
                                      fontWeight: FontWeight.w800),
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
                          Padding(
                            padding: const EdgeInsets.only(left: 18),
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: categorytype.map((e) {
                                    return YumCategory(
                                        color: e.color, title: e.title);
                                  }).toList(),
                                )),
                          ),
                          Text("여기 리스트는 어캐 만드는거지..?"),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyProfilePage()));
                              },
                              child: Text("임시 마이페이지 버튼"))
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
          ],
        ),
      )),
    );
  }
}
