import 'package:flutter/material.dart';

// typedef IsChecked = void Function(bool);

class YumCategory extends StatelessWidget {
  final Color color;
  final String title;
  final bool isChecked;
  YumCategory(
      {required this.color,
      required this.title,
      required this.isChecked,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      margin: const EdgeInsets.only(right: 5.0),
      decoration: greyBorderNChangeColor(20.0, isChecked),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              title != "ALL"
                  ? Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: isChecked ? Color(0xffFAFAFA) : color,
                        shape: BoxShape.circle,
                      ),
                    )
                  : Container(),
              SizedBox(
                width: 5.0,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "NotoSansKR_Regular",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

BoxDecoration greyBorderNChangeColor(double _radius, bool _isChecked) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(_radius),
    color: _isChecked ? Color(0xffF3F3F5) : Colors.transparent,
    border: Border.all(color: Color(0xffd6d6d6)),
  );
}
