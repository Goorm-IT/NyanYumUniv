import 'package:flutter/material.dart';

class StarScore extends StatelessWidget {
  final double score;
  StarScore({required this.score, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Icon(
                Icons.star,
                size: 16,
                color: Color(0xffFFCB64),
              ),
            ),
            TextSpan(
              text: score.toString(),
              style: TextStyle(fontSize: 12),
            ),
          ],
          style: TextStyle(
            color: Colors.black,
          )),
    );
  }
}
