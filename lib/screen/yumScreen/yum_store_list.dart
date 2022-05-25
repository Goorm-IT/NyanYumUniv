import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/menutabbar/custom_menu_tabbar.dart';
import 'package:deanora/object/yum_category_type.dart';
import 'package:deanora/object/yum_store_list_composition.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/yum_category.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/yum_store_list_item.dart';
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
  List<Widget> asd = [];
  List<StoreComposition> storeList = [];
  int initListLength = 10;
  double offset = 300.0;
  late BehaviorSubject<int> backButtonToggle;
  int willpop = 0;
  @override
  void initState() {
    super.initState();
    backButtonToggle = BehaviorSubject.seeded(-1);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      _scrollListener();
    });
  }

  _scrollListener() async {
    if (offset < _scrollController.offset) {
      offset += (widget.availableHeight - 112);
      List tmp = await getStoreList(initListLength + 1, 5);
      if (tmp.isNotEmpty) {
        setState(() {
          for (int i = 0; i < tmp.length; i++) {
            storeList.add(StoreComposition(
              tmp[i]["imagePath"],
              tmp[i]["storeAlias"],
              tmp[i]["score"],
              tmp[i]["commentId"],
            ));
          }
          initListLength += 5;
        });
      }
    }
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
                                    print(e.title);
                                  },
                                  child: YumCategory(
                                    color: e.color,
                                    title: e.title,
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
                        future: getStoreList(1, initListLength),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            if (storeList.isEmpty) {
                              for (int i = 0; i < snapshot.data.length; i++) {
                                storeList.add(StoreComposition(
                                  snapshot.data[i]["imagePath"],
                                  snapshot.data[i]["storeAlias"],
                                  snapshot.data[i]["score"],
                                  snapshot.data[i]["commentId"],
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
                                    return Container(
                                      height:
                                          (widget.availableHeight - 112) / 5,
                                      child: StoreListItem(
                                        height:
                                            (widget.availableHeight - 112) / 5,
                                        imagePath: storeList[index].imagePath,
                                        storeAlias: storeList[index].storeAlias,
                                        score: storeList[index].score,
                                        commentId: storeList[index].comment,
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

  Future<List> getStoreList(int startPageNo, int endPageNo) async {
    final yumStorehttp = YumStorehttp();
    final storeList = await yumStorehttp.storeList(startPageNo, endPageNo);

    return storeList;
  }
}
