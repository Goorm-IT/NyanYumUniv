import 'package:cached_network_image/cached_network_image.dart';
import 'package:deanora/model/menu_by_store.dart';
import 'package:deanora/model/review_by_store.dart';
import 'package:deanora/screen/yumScreen/yum_reivew_detail.dart';
import 'package:deanora/screen/yumScreen/yum_review_total.dart';
import 'package:flutter/material.dart';

class PhotoReViewIndetail extends StatefulWidget {
  List<String> imagePathList;
  List<ReviewByStore> reviewList;
  List<MenuByStore> menuList;
  PhotoReViewIndetail(
      {required this.imagePathList,
      required this.menuList,
      required this.reviewList,
      Key? key})
      : super(key: key);

  @override
  State<PhotoReViewIndetail> createState() => _PhotoReViewIndetailState();
}

class _PhotoReViewIndetailState extends State<PhotoReViewIndetail> {
  List<String> imagePathLists = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      for (int i = 0; i < widget.reviewList.length; i++) {
        if (widget.reviewList[i].imagePath != null) {
          imagePathLists.add(widget.reviewList[i].imagePath);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: imagePathLists.length > 5
            ? [0, 1, 2, 3, 4].map((e) {
                if (e != 4) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => YumReviewDetail(
                                reviewList: widget.reviewList,
                                menuList: widget.menuList,
                                initPage: e,
                              )),
                        ),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      child: CachedNetworkImage(
                        fadeInDuration: const Duration(milliseconds: 100),
                        fadeOutDuration: const Duration(milliseconds: 100),
                        imageUrl: imagePathLists[e],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Image.asset(
                          'assets/images/defaultImg.png',
                          width: 110,
                          height: 110,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  );
                } else {
                  return Stack(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        child: CachedNetworkImage(
                          fadeInDuration: const Duration(milliseconds: 100),
                          fadeOutDuration: const Duration(milliseconds: 100),
                          imageUrl: imagePathLists[e],
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image.asset(
                            'assets/images/defaultImg.png',
                            width: 110,
                            height: 110,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => YumReviewTotal(
                                reviewList: widget.reviewList,
                                menuList: widget.menuList,
                              ),
                            ),
                          );
                        },
                        child: Opacity(
                          opacity: 0.8,
                          child: Container(
                            width: 50,
                            height: 50,
                            color: Color(0xff53535380),
                            child: Center(
                                child: Text(
                              "더보기",
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                        ),
                      )
                    ],
                  );
                }
              }).toList()
            : imagePathLists.length == 5
                ? imagePathLists.asMap().entries.map((e) {
                    int idx = e.key;
                    String val = e.value;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => YumReviewDetail(
                                  reviewList: widget.reviewList,
                                  menuList: widget.menuList,
                                  initPage: idx,
                                )),
                          ),
                        );
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        child: CachedNetworkImage(
                          fadeInDuration: const Duration(milliseconds: 100),
                          fadeOutDuration: const Duration(milliseconds: 100),
                          imageUrl: val,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image.asset(
                            'assets/images/defaultImg.png',
                            width: 110,
                            height: 110,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    );
                  }).toList()
                : [0, 1, 2, 3, 4].map((e) {
                    if (imagePathLists.length > e) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => YumReviewDetail(
                                    reviewList: widget.reviewList,
                                    menuList: widget.menuList,
                                    initPage: e,
                                  )),
                            ),
                          );
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          child: CachedNetworkImage(
                            fadeInDuration: const Duration(milliseconds: 100),
                            fadeOutDuration: const Duration(milliseconds: 100),
                            imageUrl: imagePathLists[e],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image.asset(
                              'assets/images/defaultImg.png',
                              width: 110,
                              height: 110,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      );
                    } else {
                      return Container(
                          width: 50, height: 50, color: Color(0xffD6D6D6));
                    }
                  }).toList());
  }
}
