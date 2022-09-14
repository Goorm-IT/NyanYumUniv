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
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
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
    color: Color(0xfffafafa),
    border: Border.all(
      color: _isChecked ? Colors.black : Color(0xffdadada),
    ),
  );
}
