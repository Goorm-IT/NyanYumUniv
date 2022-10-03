import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/Widgets/star_rating.dart';
import 'package:deanora/model/menu_by_store.dart';
import 'package:deanora/model/review_by_store.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/gery_border.dart';
import 'package:deanora/screen/yumScreen/yum_review_notify.dart';
import 'package:deanora/screen/yumScreen/yum_review_total.dart';
import 'package:flutter/material.dart';

class YumReviewDetail extends StatefulWidget {
  List<ReviewByStore> reviewList;
  List<MenuByStore> menuList;
  int initPage;
  YumReviewDetail(
      {required this.reviewList,
      required this.menuList,
      required this.initPage,
      Key? key})
      : super(key: key);

  @override
  State<YumReviewDetail> createState() => _YumReviewDetailState();
}

class _YumReviewDetailState extends State<YumReviewDetail> {
  int sliderIndex = 0;

  String title = "";

  CarouselController buttonCarouselController = CarouselController();
  @override
  void initState() {
    super.initState();
    sliderIndex = widget.initPage;
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < widget.menuList.length; i++) {
      if (widget.menuList[i].menuId == widget.reviewList[sliderIndex].menuId) {
        setState(() {
          title = widget.menuList[i].menuAlias;
        });
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "포토 리뷰",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: greyBorder(15),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Row(
                          children: [
                            Icon(
                              Icons.grid_view,
                              size: 13,
                            ),
                            Transform.translate(
                              offset: Offset(2, -1.5),
                              child: GestureDetector(
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
                                child: Text(
                                  "전체 보기",
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                ],
              ),
            ),
            Stack(
              children: [
                CarouselSlider(
                  carouselController: buttonCarouselController,
                  items: widget.reviewList.map((e) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      child: CachedNetworkImage(
                        fadeInDuration: const Duration(milliseconds: 1),
                        fadeOutDuration: const Duration(milliseconds: 1),
                        imageUrl: e.imagePath ?? "",
                        fit: BoxFit.fill,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey[20]),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                      initialPage: widget.initPage,
                      height: 360,
                      autoPlay: false,
                      viewportFraction: 1,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          sliderIndex = index;
                        });
                      }),
                ),
                Positioned(
                  top: 180,
                  left: 15,
                  child: Container(
                    width: 20,
                    height: 20,
                    child: ElevatedButton(
                      onPressed: () {
                        buttonCarouselController.previousPage(
                            duration: Duration(milliseconds: 180),
                            curve: Curves.linear);
                      },
                      child: Icon(
                        Icons.chevron_left,
                        color: Colors.black,
                        size: 20,
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.all(0.0),
                        shadowColor: Colors.black,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 15,
                  top: 180,
                  child: Container(
                    width: 20,
                    height: 20,
                    child: ElevatedButton(
                      onPressed: () {
                        buttonCarouselController.nextPage(
                            duration: Duration(milliseconds: 180),
                            curve: Curves.linear);
                      },
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                        size: 20,
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.all(0.0),
                        shadowColor: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [1, 2, 3, 4, 5].map((e) {
                              bool _isChecked;
                              _isChecked =
                                  widget.reviewList[sliderIndex].score >= e
                                      ? true
                                      : false;
                              return Container(
                                width: 12,
                                child: StarRating(
                                  isChecked: _isChecked,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Transform.translate(
                            offset: Offset(0, 4),
                            child: Text(
                                widget.reviewList[sliderIndex].registerDate
                                    .toString()
                                    .replaceAll('-', '.'),
                                style: TextStyle(
                                    color: Color(0xff707070), fontSize: 10)),
                          ),
                          SizedBox(
                            width: 25,
                            height: 25,
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => YumReviewNotify(
                                              reviewList: widget.reviewList)));
                                },
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.grey,
                                    backgroundColor: Colors.transparent,
                                    padding: const EdgeInsets.all(0),
                                    shadowColor: Colors.transparent),
                                child: putimg(15.0, 15.0, 'notifyButton')),
                          )
                        ],
                      ),
                    ],
                  ),
                  Text('메뉴: $title',
                      style: TextStyle(color: Color(0xff707070), fontSize: 10)),
                  SizedBox(
                    height: 5,
                  ),
                  Text(widget.reviewList[sliderIndex].userAlias,
                      style: TextStyle(color: Color(0xff707070), fontSize: 10)),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.reviewList[sliderIndex].content,
                    style: TextStyle(fontSize: 12.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
