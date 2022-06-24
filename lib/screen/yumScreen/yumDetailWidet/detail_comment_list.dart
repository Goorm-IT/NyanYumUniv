import 'package:deanora/model/review_by_store.dart';
import 'package:flutter/material.dart';

class CommentList extends StatelessWidget {
  List<ReviewByStore> reviewList;
  CommentList({required this.reviewList, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: reviewList.map((e) {
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
                        height: 8,
                        color: Color(0xffD6D6D6)),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        e.content,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                Text(e.userAlias,
                    style: TextStyle(color: Color(0xffD6D6D6), fontSize: 12))
              ],
            ),
          );
        }).toList(),
      )),
    );
  }
}
