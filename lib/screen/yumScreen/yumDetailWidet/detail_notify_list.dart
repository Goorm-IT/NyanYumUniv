import 'package:deanora/model/review_by_store.dart';
import 'package:flutter/material.dart';

typedef NotifyId = void Function(int);

class NotifyList extends StatefulWidget {
  List<ReviewByStore> reviewList;
  NotifyId notifyId;
  NotifyList({required this.reviewList, required this.notifyId, Key? key})
      : super(key: key);

  @override
  State<NotifyList> createState() => _NotifyListState();
}

class _NotifyListState extends State<NotifyList> {
  @override
  int selected = -1;
  Widget build(BuildContext context) {
    Widget listItem(ReviewByStore e, int index) {
      return GestureDetector(
        onTap: () {
          widget.notifyId(int.parse(e.reviewId.toString()));
          setState(() {
            selected = index;
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 2, right: 3),
                      width: 2,
                      height: 8,
                      color:
                          (selected == index) ? Colors.red : Color(0xffD6D6D6)),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      e.content,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12,
                          color: (selected == index)
                              ? Colors.redAccent
                              : Colors.black),
                    ),
                  ),
                ],
              ),
              Text(e.userAlias,
                  style: TextStyle(
                      color:
                          (selected == index) ? Colors.red : Color(0xffD6D6D6),
                      fontSize: 12))
            ],
          ),
        ),
      );
    }

    return Container(
      height: 180,
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.reviewList.asMap().entries.map((e) {
          var val = e.value;
          int index = e.key;
          return listItem(val, index);
        }).toList(),
      )),
    );
  }
}
