import 'package:cached_network_image/cached_network_image.dart';
import 'package:deanora/Widgets/custom_loading_image.dart';
import 'package:deanora/Widgets/star_rating.dart';
import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/model/menu_by_store.dart';
import 'package:deanora/model/review_by_store.dart';
import 'package:deanora/model/yum_store_list_composition.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class YumMyReview extends StatefulWidget {
  YumMyReview({Key? key}) : super(key: key);

  @override
  State<YumMyReview> createState() => _YumMyReviewState();
}

class _YumMyReviewState extends State<YumMyReview> {
  NumberFormat won = NumberFormat('###,###,###,###');
  @override
  Widget build(BuildContext context) {
    YumReviewhttp _yumReviewhttp = YumReviewhttp();
    YumStorehttp _yumStorehttp = YumStorehttp();
    YumMenuhttp _yumMenuhttp = YumMenuhttp();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    splashRadius: 15,
                    icon: Icon(Icons.chevron_left_outlined),
                    iconSize: 25,
                    color: Color(0xff727272),
                  ),
                  Text(
                    "내가 쓴 리뷰 ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    color: Colors.transparent,
                  ),
                ],
              ),
            ),
            Flexible(
              child: FutureBuilder(
                future: _yumReviewhttp.reviewbyUser(),
                builder: (BuildContext futureContext,
                    AsyncSnapshot<List<ReviewByStore>> reviewsnap) {
                  if (reviewsnap.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: reviewsnap.data!.length,
                      itemBuilder: ((context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 25),
                              SizedBox(
                                height: 10,
                                child: Text(
                                  reviewsnap.data![index].registerDate
                                      .replaceAll('-', '.'),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xff707070),
                                    letterSpacing: -1,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              FutureBuilder(
                                  future: _yumStorehttp.searchStoreId(
                                      storeId: reviewsnap.data![index].storeId
                                          .toString()),
                                  builder: (BuildContext storeIdContext,
                                      AsyncSnapshot<List<StoreComposition>>
                                          storesnapshot) {
                                    if (storesnapshot.hasData) {
                                      return Row(
                                        children: [
                                          storesnapshot.data![0].imagePath !=
                                                  null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  child: Container(
                                                    width: 50,
                                                    height: 50,
                                                    child: CachedNetworkImage(
                                                      fadeInDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  100),
                                                      fadeOutDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  100),
                                                      imageUrl: storesnapshot
                                                          .data![0].imagePath
                                                          .toString(),
                                                      fit: BoxFit.cover,
                                                      placeholder: (context,
                                                              url) =>
                                                          CustomLoadingImage(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                  ),
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  child: Container(
                                                    color: Color(0xfff3f3f5),
                                                    width: 50,
                                                    height: 50,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          height: 25,
                                                          width: 25,
                                                          child: Image.asset(
                                                            'assets/images/default_nobackground.png',
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                storesnapshot
                                                    .data![0].storeAlias,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              FutureBuilder(
                                                future:
                                                    _yumMenuhttp.searchMenuId(
                                                        menuId: reviewsnap
                                                            .data![index].menuId
                                                            .toString()),
                                                builder: (BuildContext
                                                        menuIdContext,
                                                    AsyncSnapshot<
                                                            List<MenuByStore>>
                                                        meneIdSnapshot) {
                                                  if (meneIdSnapshot.hasData) {
                                                    return Container(
                                                      child: Text(
                                                        ' ${meneIdSnapshot.data![0].menuAlias} ${won.format(meneIdSnapshot.data![0].cost)}원',
                                                        style: TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }),
                              SizedBox(height: 10),
                              Row(
                                children: [1, 2, 3, 4, 5].map((e) {
                                  bool _isChecked;
                                  _isChecked =
                                      reviewsnap.data![index].score >= e
                                          ? true
                                          : false;
                                  return Container(
                                    height: 12,
                                    width: 12,
                                    child: StarRating(
                                      isChecked: _isChecked,
                                    ),
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 10),
                              Text(
                                reviewsnap.data![index].content,
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                child: Container(
                                  width: 133,
                                  height: 133,
                                  child: CachedNetworkImage(
                                    fadeInDuration:
                                        const Duration(milliseconds: 100),
                                    fadeOutDuration:
                                        const Duration(milliseconds: 100),
                                    imageUrl: reviewsnap.data![index].imagePath,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        CustomLoadingImage(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Divider(
                                thickness: 1,
                                height: 0,
                              ),
                            ],
                          ),
                        );
                      }),
                    );
                  } else {
                    return Container(
                      child: Center(child: CustomLoadingImage()),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
