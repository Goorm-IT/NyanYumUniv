import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/gery_border.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/star_score.dart';
import 'package:flutter/material.dart';

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
  String firstComment = " ";
  @override
  void initState() {
    super.initState();
    getStoreReview(widget.storeId.toString());
  }

  @override
  Widget build(BuildContext context) {
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
              Container(
                margin: const EdgeInsets.only(right: 20.0),
                child: Text(
                  '${firstComment}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(3.0),
                decoration: greyBorder(5.0),
                child: Text("추천메뉴 & 가격"),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        )
      ],
    ));
  }

  Future<void> getStoreReview(String storeId) async {
    final yumReviewhttp = YumReviewhttp();
    final _list = await yumReviewhttp.commentByStore(storeId);
    if (mounted) {
      setState(() {
        if (_list.isNotEmpty) {
          firstComment = _list[0]["content"] ?? "";
        }
      });
    }
  }
}
