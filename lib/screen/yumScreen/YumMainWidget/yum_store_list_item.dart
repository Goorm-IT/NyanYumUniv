import 'package:deanora/screen/yumScreen/YumMainWidget/gery_border.dart';
import 'package:deanora/screen/yumScreen/YumMainWidget/star_score.dart';
import 'package:flutter/material.dart';

class StoreListItem extends StatefulWidget {
  final double height;
  final String? imagePath;
  final String storeAlias;
  final double score;
  final String? commentId;
  const StoreListItem({
    required this.height,
    required this.imagePath,
    required this.storeAlias,
    required this.score,
    required this.commentId,
    Key? key,
  }) : super(key: key);

  @override
  State<StoreListItem> createState() => _StoreListItemState();
}

class _StoreListItemState extends State<StoreListItem> {
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
                  ? Image.network(
                      widget.imagePath.toString(),
                      fit: BoxFit.cover,
                    )
                  : Image.asset('assets/images/defaultImg.png')),
        ),
        Column(
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
            Text('${widget.storeAlias} 의 한줄평은 어캐 하는걸까..? '),
            Container(
              padding: const EdgeInsets.all(3.0),
              decoration: greyBorder(5.0),
              child: Text("추천메뉴 & 가격"),
            ),
            SizedBox(
              height: 10,
            )
          ],
        )
      ],
    ));
  }
}
