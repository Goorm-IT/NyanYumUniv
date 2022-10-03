import 'dart:ffi';

import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/provider/like_store_provider.dart';
import 'package:deanora/provider/menu_provider.dart';
import 'package:deanora/provider/review_provider.dart';
import 'package:deanora/provider/save_store_provider.dart';
import 'package:deanora/provider/storeInfo_provider.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/yum_store_list_item.dart';
import 'package:deanora/screen/yumScreen/yum_store_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YumSaveList extends StatefulWidget {
  const YumSaveList({Key? key}) : super(key: key);

  @override
  State<YumSaveList> createState() => _YumSaveListState();
}

class _YumSaveListState extends State<YumSaveList> {
  late MenuProvider _menuProvider;
  late ReviewProvider _reviewProvider;

  @override
  Widget build(BuildContext context) {
    _reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    _menuProvider = Provider.of<MenuProvider>(context, listen: false);
    double availableHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          bottom: false,
          left: false,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
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
                    "저장한 맛집",
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
              Consumer<SaveStoreProvider>(
                  builder: (providercontext, provider, widgets) {
                if (provider.savedlist == [] && provider.savedlist.length < 0) {
                  return CircularProgressIndicator();
                } else {
                  return Flexible(
                    child: Container(
                      height: availableHeight,
                      child: ListView.builder(
                          itemCount: provider.savedlist.length,
                          itemBuilder: (BuildContext listContext, int index) {
                            return GestureDetector(
                              onTap: () async {
                                await _menuProvider.getMenubyStore(provider
                                    .savedlist[index].storeId
                                    .toString());
                                await _reviewProvider.getReviewByStore(provider
                                    .savedlist[index].storeId
                                    .toString());
                                NaverOpneApi naverOpneApi = NaverOpneApi();
                                String str =
                                    await naverOpneApi.getNaverMapImage(
                                        x: provider.savedlist[index].mapX,
                                        y: provider.savedlist[index].mapY,
                                        title: provider
                                            .savedlist[index].storeAlias);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => YumStoreDetail(
                                      storeInfo: provider.savedlist[index],
                                      naverMapUrl: str,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: (availableHeight - 112) / 5,
                                child: StoreListItem(
                                  height: (availableHeight - 112) / 5,
                                  imagePath:
                                      provider.savedlist[index].imagePath,
                                  storeAlias:
                                      provider.savedlist[index].storeAlias,
                                  storeId: provider.savedlist[index].storeId,
                                ),
                              ),
                            );
                          }),
                    ),
                  );
                }
              }),
            ],
          )),
    );
  }
}
