import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/provider/comment_provider.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/gery_border.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/star_score.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreListItem extends StatefulWidget {
  final double height;
  final String? imagePath;
  final String storeAlias;
  final double score;
  final int storeId;

  const StoreListItem({
    required this.height,
    required this.imagePath,
    required this.storeAlias,
    required this.score,
    required this.storeId,
    Key? key,
  }) : super(key: key);

  @override
  State<StoreListItem> createState() => _StoreListItemState();
}

class _StoreListItemState extends State<StoreListItem> {
  @override
  void initState() {
    super.initState();
  }

  late CommentProvider _commentProvider;
  @override
  Widget build(BuildContext context) {
    _commentProvider = Provider.of<CommentProvider>(context, listen: false);
    _commentProvider.getCommentByStore(widget.storeId.toString());
    return Scaffold(
        body: Row(
      children: [
        Container(
          width: widget.height - 10,
          height: widget.height - 10,
          margin: const EdgeInsets.only(
            left: 15,
            right: 15,
            bottom: 15,
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: widget.imagePath != null
                  ? CachedNetworkImage(
                      fadeInDuration: const Duration(milliseconds: 100),
                      fadeOutDuration: const Duration(milliseconds: 100),
                      imageUrl: widget.imagePath.toString(),
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(
                        'assets/images/defaultImg.png',
                        width: 110,
                        height: 110,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                  : Container(
                      color: Color(0xffF3F3F5),
                      child: Center(
                          child: Image.asset(
                              'assets/images/default_nobackground.png')))),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  Text(
                    '${widget.storeAlias}  ',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  StarScore(score: widget.score),
                ],
              ),
              FutureBuilder<Object>(
                  future: getStoreReview(widget.storeId.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        margin: const EdgeInsets.only(right: 20.0),
                        width: 150,
                        child: Text(
                          snapshot.data.toString(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
              FutureBuilder<Object>(
                  future: getStoreMenu(widget.storeId.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data == "아직 리뷰가 없습니다.") {
                        return Container();
                      }
                      return Container(
                        padding: const EdgeInsets.all(3.0),
                        decoration: greyBorder(5.0),
                        width: 75,
                        child: Row(
                          children: [
                            putimg(14.0, 12.0, "thumbs"),
                            Container(
                              width: 46,
                              child: Text(
                                ' ${snapshot.data.toString()}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
              SizedBox(
                height: 10,
              )
            ],
          ),
        )
      ],
    ));
  }

  Future<String> getStoreMenu(String storeId) async {
    final yumMenuhttp = YumMenuhttp();
    final _list = await yumMenuhttp.menuByStore(storeId);
    _list.sort((a, b) => b.choiceCount.compareTo(a.choiceCount));

    if (_list.isEmpty) {
      return "아직 리뷰가 없습니다.";
    } else {
      return _list[0].menuAlias;
    }
  }

  Future<String> getStoreReview(String storeId) async {
    final yumReviewhttp = YumReviewhttp();
    final _list = await yumReviewhttp.commentByStore(storeId);
    if (_list[0].reviewId == -1) {
      return " ";
    } else {
      return _list[0].content;
    }
  }
}
