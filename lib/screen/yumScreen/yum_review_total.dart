import 'package:cached_network_image/cached_network_image.dart';
import 'package:deanora/model/menu_by_store.dart';
import 'package:deanora/model/review_by_store.dart';
import 'package:deanora/screen/yumScreen/yum_reivew_detail.dart';
import 'package:flutter/material.dart';

class YumReviewTotal extends StatefulWidget {
  List<ReviewByStore> reviewList;
  List<MenuByStore> menuList;
  YumReviewTotal({required this.reviewList, required this.menuList, Key? key})
      : super(key: key);

  @override
  State<YumReviewTotal> createState() => _YumReviewTotalState();
}

class _YumReviewTotalState extends State<YumReviewTotal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "포토 리뷰",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          splashColor: Colors.grey,
                          icon: Icon(Icons.close_sharp),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  color: Color(0xfff3f3f5),
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                      ),
                      itemCount: widget.reviewList.length +
                          21 -
                          (widget.reviewList.length % 3),
                      itemBuilder: (buildercontext, index) {
                        if (index < widget.reviewList.length &&
                            widget.reviewList[index].imagePath != null) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => YumReviewDetail(
                                        reviewList: widget.reviewList,
                                        menuList: widget.menuList,
                                        initPage: index,
                                      )),
                                ),
                              );
                            },
                            child: Container(
                              color: Colors.white,
                              child: CachedNetworkImage(
                                fadeInDuration: const Duration(milliseconds: 1),
                                fadeOutDuration:
                                    const Duration(milliseconds: 1),
                                imageUrl:
                                    widget.reviewList[index].imagePath ?? "",
                                fit: BoxFit.fill,
                                placeholder: (context, url) =>
                                    Container(color: Colors.grey[20]),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            color: Colors.white,
                          );
                        }
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
