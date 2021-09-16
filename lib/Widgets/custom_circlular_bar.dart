import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// *[vsync] Input 'this'
/// *[duration] Millisecond
/// *[upperBound] 0.0 ~ 1.0
///
// ignore: must_be_immutable
class CustomCircularBar extends StatefulWidget {
  final TickerProvider vsync;
  final double upperBound;
  final int duration;
  final double fontSize;
  final double size;
  final Color startColor, endColor;
  const CustomCircularBar(
      {required this.vsync,
      this.upperBound = 0.0001,
      this.duration = 400,
      this.size = 50,
      this.fontSize = 12,
      this.startColor = Colors.red,
      this.endColor = const Color.fromRGBO(124, 77, 241, 1)});

  @override
  State<CustomCircularBar> createState() => _CustomCircularBar(
      this.vsync,
      this.upperBound == 0 ? 0.001 : this.upperBound,
      this.duration == 0 ? 1 : this.duration,
      this.size,
      this.fontSize,
      this.startColor,
      this.endColor);
}

class _CustomCircularBar extends State<CustomCircularBar> {
  late AnimationController _controller;
  late ColorTween progressColor;
  final double fontSize;
  final double size;

  _CustomCircularBar(TickerProvider vsync, double upperBound, int duration,
      this.size, this.fontSize, Color startColor, Color endColor) {
    _controller = AnimationController(
        vsync: vsync,
        duration: Duration(milliseconds: duration),
        upperBound: upperBound)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
    this.progressColor = ColorTween(begin: startColor, end: endColor);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: this.size,
          height: this.size,
          child: CircularProgressIndicator(
              value: _controller.value,
              valueColor: _controller.drive(progressColor)),
        ),
        SizedBox(
          width: this.size,
          height: this.size,
          child: Align(
              alignment: Alignment.center,
              child: Text(
                '${(_controller.value * 100).floor()}%',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: this.fontSize),
              )),
        ),
      ],
    );
  }

  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }
}
