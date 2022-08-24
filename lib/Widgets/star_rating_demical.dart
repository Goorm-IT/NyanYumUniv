import 'package:deanora/Widgets/Widgets.dart';
import 'package:flutter/material.dart';

class StarRatingDemical extends StatelessWidget {
  bool isChecked;
  bool isDemical;
  double demical;

  StarRatingDemical(
      {required this.isChecked,
      required this.isDemical,
      required this.demical,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _demicalRating = double.parse(demical.toStringAsFixed(1));
    return Container(
      child: isDemical
          ? Container(
              width: 45,
              height: 45,
              child: Stack(
                children: [
                  putimg(45.0, 45.0, 'filled_star'),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 45,
                      width: 45 * (_demicalRating + 0.1),
                      color: Color(0xfffafafa),
                    ),
                  ),
                  putimg(45.0, 45.0, 'empty_star')
                ],
              ),
            )
          : isChecked
              ? putimg(45.0, 45.0, 'filled_star')
              : putimg(45.0, 45.0, 'empty_star'),
    );
  }
}
