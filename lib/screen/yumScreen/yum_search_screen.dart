import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/model/yum_naver_search.dart';
import 'package:deanora/model/yum_store_list_composition.dart';
import 'package:deanora/provider/menu_provider.dart';
import 'package:deanora/provider/review_provider.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/yum_store_list_item.dart';
import 'package:deanora/screen/yumScreen/yum_store_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YumSearchScreen extends StatefulWidget {
  final List<YumNaverSearch> searchInfo;
  final double availableHeight;
  YumSearchScreen(
      {required this.searchInfo, required this.availableHeight, Key? key})
      : super(key: key);

  @override
  State<YumSearchScreen> createState() => _YumSearchScreenState();
}

class _YumSearchScreenState extends State<YumSearchScreen> {
  late MenuProvider _menuProvider;
  late ReviewProvider _reviewProvider;
  @override
  Widget build(BuildContext context) {
    _reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    _menuProvider = Provider.of<MenuProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  splashRadius: 15,
                  icon: Icon(Icons.chevron_left_outlined),
                  iconSize: 30,
                ),
                Text(
                  "검색 결과",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Container(
                  height: 40,
                  width: 40,
                  color: Colors.transparent,
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Flexible(
              child: Container(
                height: 700.0,
                child: ListView.builder(
                  itemCount: widget.searchInfo.length,
                  itemBuilder: ((listContext, index) {
                    YumStorehttp yumStorehttp = YumStorehttp();
                    return FutureBuilder(
                        future: yumStorehttp.getstorebyAlias(
                          storeAlias: widget.searchInfo[index].title
                              .replaceAll("</b>", " ")
                              .replaceAll("<b>", " "),
                        ),
                        builder: (builderContext,
                            AsyncSnapshot<List<StoreComposition>> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.isNotEmpty) {
                              print(snapshot.data![0].storeAlias);
                              return GestureDetector(
                                onTap: () async {
                                  try {
                                    await _menuProvider.getMenubyStore(
                                        snapshot.data![0].storeId.toString());
                                    await _reviewProvider.getReviewByStore(
                                        snapshot.data![0].storeId.toString());
                                  } catch (e) {
                                    print(e);
                                  }

                                  NaverOpneApi naverOpneApi = NaverOpneApi();
                                  String str =
                                      await naverOpneApi.getNaverMapImage(
                                          x: snapshot.data![0].mapX,
                                          y: snapshot.data![0].mapY,
                                          title: snapshot.data![0].storeAlias);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => YumStoreDetail(
                                        storeInfo: snapshot.data![0],
                                        naverMapUrl: str,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: (widget.availableHeight - 112) / 5,
                                  child: StoreListItem(
                                    height: (widget.availableHeight - 112) / 5,
                                    storeAlias: widget.searchInfo[index].title,
                                    storeId: snapshot.data![0].storeId,
                                    imagePath: snapshot.data![0].imagePath,
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        });
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
