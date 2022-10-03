import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/model/user.dart';
import 'package:deanora/model/yum_user.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class YumSupport extends StatefulWidget {
  const YumSupport({Key? key}) : super(key: key);

  @override
  State<YumSupport> createState() => _YumSupportState();
}

class _YumSupportState extends State<YumSupport>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  YumUser yumUser = GetIt.I<YumUser>();
  TextEditingController _textEditingController = TextEditingController();
  FocusNode textFocus = FocusNode();
  late AnimationController _animationController;
  String errorMessage = "";
  Color errorMessageColor = Colors.red;
  bool _visible = false;
  String userAlias = "";
  @override
  void initState() {
    super.initState();
    userAlias = yumUser.userAlias;
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 250));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  fadeMessage(newerrorMessage, newerrorMessageColor) {
    setState(() {
      errorMessage = newerrorMessage;
      errorMessageColor = newerrorMessageColor;
    });
    if (!_visible) {
      _animationController.forward();
      setState(() {
        _visible = !_visible;
      });
    } else {
      _animationController.reverse();
      Future.delayed(const Duration(milliseconds: 500), () {
        _animationController.forward();
      });
    }
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
                        " 건의 하기",
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
                  SizedBox(
                    height: 16,
                    child: FadeTransition(
                      opacity: _animationController,
                      child: Center(
                        child: Text(
                          errorMessage,
                          style: TextStyle(
                              color: errorMessageColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ),
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
                          onPressed: () async {
                            if (_textEditingController.text == "") {
                              fadeMessage("신고 내용을 작성해주세요.", Colors.red);
                            } else {
                              SupportApi _supportApi = SupportApi();
                              await _supportApi.yumreport(
                                content: _textEditingController.text,
                                userAlias: userAlias,
                              );
                              showdialog(
                                context,
                                "신고 되었습니다.",
                              );
                              _textEditingController.clear();
                              _animationController.reverse();
                              setState(() {
                                _visible = false;
                              });
                            }
                          },
                          child: Text("등록"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff7D48D9),
                          ),
                        ),
                      ),
                    ],
                  ),
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
