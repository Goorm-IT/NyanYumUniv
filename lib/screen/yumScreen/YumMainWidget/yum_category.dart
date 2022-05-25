import 'package:flutter/material.dart';

class YumCategory extends StatelessWidget {
  Color color;
  String title;
  YumCategory({required this.color, required this.title, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      margin: const EdgeInsets.only(right: 5.0),
      decoration: greyBorder(20.0),
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
                        color: color,
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

BoxDecoration greyBorder(double _radius) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(_radius),
    border: Border.all(color: Color(0xffd6d6d6)),
  );
}
