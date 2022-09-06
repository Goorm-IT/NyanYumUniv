import 'dart:ffi';

import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/provider/like_store_provider.dart';
import 'package:deanora/provider/menu_provider.dart';
import 'package:deanora/provider/review_provider.dart';
import 'package:deanora/provider/storeInfo_provider.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/yum_store_list_item.dart';
import 'package:deanora/screen/yumScreen/yum_store_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YumLikeList extends StatefulWidget {
  const YumLikeList({Key? key}) : super(key: key);

  @override
  State<YumLikeList> createState() => _YumLikeListState();
}

class _YumLikeListState extends State<YumLikeList> {
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
                    "좋아요한 맛집",
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
              Consumer<LikeStoreProvider>(
                  builder: (providercontext, provider, widgets) {
                if (provider.likedlist == [] && provider.likedlist.length < 0) {
                  return CircularProgressIndicator();
                } else {
                  return Container(
                    height: availableHeight - 180,
                    child: ListView.builder(
                        itemCount: provider.likedlist.length,
                        itemBuilder: (BuildContext listContext, int index) {
                          return GestureDetector(
                            onTap: () async {
                              await _menuProvider.getMenubyStore(
                                  provider.likedlist[index].storeId.toString());
                              await _reviewProvider.getReviewByStore(
                                  provider.likedlist[index].storeId.toString());
                              NaverOpneApi naverOpneApi = NaverOpneApi();
                              String str = await naverOpneApi.getNaverMapImage(
                                  x: provider.likedlist[index].mapX,
                                  y: provider.likedlist[index].mapY,
                                  title: provider.likedlist[index].storeAlias);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => YumStoreDetail(
                                    storeInfo: provider.likedlist[index],
                                    naverMapUrl: str,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: (availableHeight - 112) / 5,
                              child: StoreListItem(
                                height: (availableHeight - 112) / 5,
                                imagePath: provider.likedlist[index].imagePath,
                                storeAlias:
                                    provider.likedlist[index].storeAlias,
                                storeId: provider.likedlist[index].storeId,
                              ),
                            ),
                          );
                        }),
                  );
                }
              }),
            ],
          )),
    );
  }
}
