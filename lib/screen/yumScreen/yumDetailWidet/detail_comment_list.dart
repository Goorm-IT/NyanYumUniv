import 'package:deanora/model/review_by_store.dart';
import 'package:flutter/material.dart';

class CommentList extends StatelessWidget {
  List<ReviewByStore> reviewList;
  CommentList({required this.reviewList, Key? key}) : super(key: key);

  List<double> heightList = [];
  @override
  Widget build(BuildContext context) {
    heightList.clear();
    for (int i = 0; i < reviewList.length; i++) {
      heightList.add(_textSize(reviewList[i].content, TextStyle(fontSize: 12)));
    }
    print(heightList);
    return Container(
      height: 130,
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: reviewList.asMap().entries.map((e) {
          var val = e.value;
          int index = e.key;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 2, right: 3),
                        width: 1,
                        height: heightList[index],
                        color: Color(0xffD6D6D6)),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        val.content,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                Text(val.userAlias,
                    style: TextStyle(color: Color(0xffD6D6D6), fontSize: 12))
              ],
            ),
          );
        }).toList(),
      )),
    );
  }

  double _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.height;
  }
}
