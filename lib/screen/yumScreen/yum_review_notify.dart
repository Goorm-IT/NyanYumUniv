import 'package:deanora/model/review_by_store.dart';
import 'package:deanora/screen/yumScreen/yumDetailWidet/detail_notify_list.dart';
import 'package:flutter/material.dart';

class YumReviewNotify extends StatefulWidget {
  List<ReviewByStore> reviewList;
  YumReviewNotify({required this.reviewList, Key? key}) : super(key: key);

  @override
  State<YumReviewNotify> createState() => _YumReviewNotifyState();
}

class _YumReviewNotifyState extends State<YumReviewNotify> {
  ScrollController _scrollController = ScrollController();
  TextEditingController _textEditingController = TextEditingController();
  int _notifyId = -1;
  FocusNode textFocus = FocusNode();
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(0),
                        splashRadius: 20.0,
                        icon: Icon(Icons.close_sharp),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  NotifyList(
                      reviewList: widget.reviewList,
                      notifyId: (int id) {
                        setState(() {
                          _notifyId = id;
                        });
                      }),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    focusNode: textFocus,
                    controller: _textEditingController,
                    onTap: () {
                      _scrollController.animateTo(
                          MediaQuery.of(context).viewInsets.bottom,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease);
                    },
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
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text("등록"),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xff7D48D9),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(_notifyId.toString()),
                  Text(_textEditingController.text),
                  SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
