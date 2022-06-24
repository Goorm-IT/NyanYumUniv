import 'package:deanora/Widgets/Widgets.dart';
import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  bool isChecked;

  StarRating({required this.isChecked, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isChecked
          ? putimg(45.0, 45.0, 'filled_star')
          : putimg(45.0, 45.0, 'empty_star'),
    );
  }
}
