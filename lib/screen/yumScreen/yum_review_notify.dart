import 'package:flutter/material.dart';

class YumReviewNotify extends StatefulWidget {
  const YumReviewNotify({Key? key}) : super(key: key);

  @override
  State<YumReviewNotify> createState() => _YumReviewNotifyState();
}

class _YumReviewNotifyState extends State<YumReviewNotify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      " 리뷰 신고",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      splashRadius: 20.0,
                      icon: Icon(Icons.close_sharp),
                      onPressed: () {},
                    ),
                  ],
                ),
                TextField(
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintStyle:
                        TextStyle(color: Color(0xffD6D6D6), fontSize: 13.0),
                    hintText: "신고 사유를 작성해주세요",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xfff4f4f6),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xfff4f4f6),
                      ),
                    ),
                    fillColor: Color(0xfff4f4f6),
                    filled: true,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
