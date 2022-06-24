import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/menutabbar/custom_menu_tabbar.dart';
import 'package:deanora/model/yum_category_type.dart';
import 'package:deanora/model/yum_store_list_composition.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/yum_category.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/yum_store_list_item.dart';
import 'package:deanora/screen/yumScreen/yum_store_detail.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class YumStoreList extends StatefulWidget {
  final double availableHeight;
  const YumStoreList({required this.availableHeight, Key? key})
      : super(key: key);

  @override
  State<YumStoreList> createState() => _YumStoreListState();
}

class _YumStoreListState extends State<YumStoreList> {
  late ScrollController _scrollController;
  List<StoreComposition> storeList = [];
  int initListLength = 10;
  double offset = 300.0;
  bool categoryIsChecked = false;
  String checkedCategory = "ALL";
  late BehaviorSubject<int> backButtonToggle;
  int willpop = 0;
  @override
  void initState() {
    super.initState();
    // getinitStoreList();
    for (int i = 0; i < categorytype.length; i++) {
      if (i == 0) {
        categorytype[i].isChecked = true;
      } else {
        categorytype[i].isChecked = false;
      }
    }
    backButtonToggle = BehaviorSubject.seeded(-1);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      _scrollListener(checkedCategory);
    });
  }

  _scrollListener([String category = '']) async {
    if (offset < _scrollController.offset) {
      offset += (widget.availableHeight - 112);
      List addstoreList = await getStoreList(
          initListLength + 1, 5, category == 'ALL' ? '' : category);

      if (addstoreList.isNotEmpty) {
        setState(() {
          for (int i = 0; i < addstoreList.length; i++) {
            storeList.add(StoreComposition(
              imagePath: addstoreList[i]["imagePath"],
              storeAlias: addstoreList[i]["storeAlias"],
              score: addstoreList[i]["score"],
              commentId: addstoreList[i]["commentId"],
              category: addstoreList[i]["category"],
              address: addstoreList[i]["address"],
              storeId: addstoreList[i]["storeId"],
            ));
          }

          initListLength += 5;
        });
      }
    }
  }

  changeCategory([String category = '']) async {
    print(category);
    initListLength = 10;
    offset = 300.0;
    storeList.clear();
    List addstoreList = await getStoreList(1, initListLength, category);
    if (addstoreList.isNotEmpty) {
      setState(() {
        for (int i = 0; i < addstoreList.length; i++) {
          storeList.add(StoreComposition(
            imagePath: addstoreList[i]["imagePath"],
            storeAlias: addstoreList[i]["storeAlias"],
            score: addstoreList[i]["score"],
            commentId: addstoreList[i]["commentId"],
            category: addstoreList[i]["category"],
            address: addstoreList[i]["address"],
            storeId: addstoreList[i]["storeId"],
          ));
        }
      });
    }
    print(storeList.length);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              SafeArea(
                bottom: false,
                left: false,
                right: false,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 30,
                      margin: const EdgeInsets.symmetric(horizontal: 23),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              return Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                "가게 리스트",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 26,
                    ),
                    Container(
                      height: 25,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: categorytype.map((e) {
                                return GestureDetector(
                                  onTap: () {
                                    checkedCategory = e.title;
                                    for (int i = 0;
                                        i < categorytype.length;
                                        i++) {
                                      setState(() {
                                        if (e.title == categorytype[i].title) {
                                          categorytype[i].isChecked = true;
                                        } else {
                                          categorytype[i].isChecked = false;
                                        }
                                      });
                                    }
                                    checkedCategory == 'ALL'
                                        ? changeCategory()
                                        : changeCategory(checkedCategory);
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
                    SizedBox(
                      height: 26,
                    ),
                    FutureBuilder(
                        future: storeList.isEmpty
                            ? getStoreList(1, initListLength)
                            : getStoreList2(),
                        builder: (futureContext, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            if (storeList.isEmpty && checkedCategory == 'ALL') {
                              for (int i = 0; i < snapshot.data.length; i++) {
                                storeList.add(StoreComposition(
                                  imagePath: snapshot.data[i]["imagePath"],
                                  storeAlias: snapshot.data[i]["storeAlias"],
                                  score: snapshot.data[i]["score"],
                                  commentId: snapshot.data[i]["commentId"],
                                  category: snapshot.data[i]["category"],
                                  address: snapshot.data[i]["address"],
                                  storeId: snapshot.data[i]["storeId"],
                                ));
                              }
                            }

                            return Container(
                              height: widget.availableHeight - 180,
                              child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: storeList.length,
                                  itemBuilder:
                                      (BuildContext listContext, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                YumStoreDetail(
                                              storeInfo: storeList[index],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height:
                                            (widget.availableHeight - 112) / 5,
                                        child: StoreListItem(
                                          height:
                                              (widget.availableHeight - 112) /
                                                  5,
                                          imagePath: storeList[index].imagePath,
                                          storeAlias:
                                              storeList[index].storeAlias,
                                          score: storeList[index].score,
                                          storeId: storeList[index].storeId,
                                        ),
                                      ),
                                    );
                                  }),
                            );
                          } else {
                            return Container();
                          }
                        })
                  ],
                ),
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
        ),
      ),
    );
  }

  // Future<void> getinitStoreList() async {
  //   final yumStorehttp = YumStorehttp();
  //   final addstoreList = await yumStorehttp.storeList(1, initListLength);

  //   if (addstoreList.isNotEmpty) {
  //     setState(() {
  //       for (int i = 0; i < addstoreList.length; i++) {
  //         storeList.add(StoreComposition(
  //           addstoreList[i]["imagePath"],
  //           addstoreList[i]["storeAlias"],
  //           addstoreList[i]["score"],
  //           addstoreList[i]["commentId"],
  //           addstoreList[i]["category"],
  //           addstoreList[i]["address"],
  //           addstoreList[i]["storeId"],
  //         ));
  //       }
  //     });
  //   }
  // }

  Future<List> getStoreList(int startPageNo, int endPageNo,
      [String category = '']) async {
    final yumStorehttp = YumStorehttp();
    final storeList =
        await yumStorehttp.storeList(startPageNo, endPageNo, category);
    return storeList;
  }

  Future<List> getStoreList2() async {
    return [];
  }
}
