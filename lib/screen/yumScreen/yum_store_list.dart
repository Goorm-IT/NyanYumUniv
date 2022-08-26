import 'package:deanora/Widgets/custom_loading_image.dart';
import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/menutabbar/custom_menu_tabbar.dart';
import 'package:deanora/model/yum_category_type.dart';
import 'package:deanora/model/yum_store_list_composition.dart';
import 'package:deanora/provider/category_selected_provider.dart';
import 'package:deanora/provider/menu_provider.dart';
import 'package:deanora/provider/review_provider.dart';
import 'package:deanora/provider/storeInfo_provider.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/yum_category.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/yum_store_list_item.dart';
import 'package:deanora/screen/yumScreen/yum_store_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  int initListLength = 10;
  double offset = 300.0;
  bool categoryIsChecked = false;
  bool _isLoading = false;
  late BehaviorSubject<int> backButtonToggle;
  int willpop = 0;
  @override
  void initState() {
    super.initState();

    backButtonToggle = BehaviorSubject.seeded(-1);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      _scrollListener(context.read<CategorySelectedProvider>().selected);
    });
  }

  _scrollListener([String category = '']) async {
    if (offset < _scrollController.offset) {
      offset += (widget.availableHeight - 180);
      _storeInfoProvider.loadStoreInfo(
          1 + initListLength, 5, category == 'ALL' ? '' : category);
      initListLength += 5;
    }
  }

  changeCategory([String category = '']) async {
    initListLength = 10;
    offset = 300.0;
    await _storeInfoProvider.loadStoreInfo(1, initListLength, category);

    _scrollController.jumpTo(0);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  late CategorySelectedProvider _categorySelectedProvider;
  late MenuProvider _menuProvider;
  late ReviewProvider _reviewProvider;
  late StoreInfoProvider _storeInfoProvider;
  @override
  Widget build(BuildContext context) {
    _storeInfoProvider = Provider.of<StoreInfoProvider>(context, listen: false);
    _reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    _menuProvider = Provider.of<MenuProvider>(context, listen: false);
    _categorySelectedProvider =
        Provider.of<CategorySelectedProvider>(context, listen: false);

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
                          Container(
                            width: 10,
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
                                return Consumer<CategorySelectedProvider>(
                                    builder:
                                        (providercontext, provider, widgets) {
                                  return GestureDetector(
                                    onTap: () async {
                                      _categorySelectedProvider
                                          .getSelectedCategory(e.title);

                                      for (int i = 0;
                                          i < categorytype.length;
                                          i++) {
                                        setState(() {
                                          if (e.title ==
                                              categorytype[i].title) {
                                            categorytype[i].isChecked = true;
                                          } else {
                                            categorytype[i].isChecked = false;
                                          }
                                        });
                                      }
                                      provider.selected == 'ALL'
                                          ? await changeCategory()
                                          : await changeCategory(
                                              provider.selected);
                                    },
                                    child: YumCategory(
                                      color: e.color,
                                      title: e.title,
                                      isChecked: e.isChecked,
                                    ),
                                  );
                                });
                              }).toList(),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 26,
                    ),
                    Consumer<StoreInfoProvider>(
                        builder: (providercontext, provider, widgets) {
                      print(provider.storeInfo);
                      if (provider.storeInfo == [] &&
                          provider.storeInfo.length < 0) {
                        return CircularProgressIndicator();
                      } else {
                        return Container(
                          height: widget.availableHeight - 180,
                          child: ListView.builder(
                              controller: _scrollController,
                              itemCount: provider.storeInfo.length,
                              itemBuilder:
                                  (BuildContext listContext, int index) {
                                return GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    try {
                                      await _menuProvider.getMenubyStore(
                                          provider.storeInfo[index].storeId
                                              .toString());
                                      await _reviewProvider.getReviewByStore(
                                          provider.storeInfo[index].storeId
                                              .toString());
                                    } catch (e) {
                                      print(e);
                                    }

                                    setState(() {
                                      _isLoading = false;
                                    });

                                    NaverOpneApi naverOpneApi = NaverOpneApi();
                                    String str =
                                        await naverOpneApi.getNaverMapImage(
                                            x: provider.storeInfo[index].mapX,
                                            y: provider.storeInfo[index].mapY,
                                            title: provider
                                                .storeInfo[index].storeAlias);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => YumStoreDetail(
                                          storeInfo: provider.storeInfo[index],
                                          naverMapUrl: str,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: (widget.availableHeight - 112) / 5,
                                    child: StoreListItem(
                                      height:
                                          (widget.availableHeight - 112) / 5,
                                      imagePath:
                                          provider.storeInfo[index].imagePath,
                                      storeAlias:
                                          provider.storeInfo[index].storeAlias,
                                      score: provider.storeInfo[index].score,
                                      storeId:
                                          provider.storeInfo[index].storeId,
                                    ),
                                  ),
                                );
                              }),
                        );
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
        ),
      ),
    );
  }

  Future<List> getStoreList(int startPageNo, int endPageNo,
      [String category = '']) async {
    final yumStorehttp = YumStorehttp();
    final storeList =
        await yumStorehttp.storeList(startPageNo, endPageNo, category);
    return storeList;
  }
}
