import 'dart:async';
import 'package:flutter/material.dart';

class CustomLoadingImage extends StatefulWidget {
  const CustomLoadingImage({Key? key}) : super(key: key);

  @override
  State<CustomLoadingImage> createState() => _CustomLoadingImageState();
}

class _CustomLoadingImageState extends State<CustomLoadingImage> {
  Timer? timer;
  bool _visible1 = false;
  bool _visible2 = false;
  bool _visible3 = false;
  bool _visible4 = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 750), () {
      if (mounted) {
        setState(() {
          _visible1 = !_visible1;
        });
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _visible2 = !_visible2;
        });
      }
    });
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) {
        setState(() {
          _visible3 = !_visible3;
        });
      }
    });
    if (mounted) {
      setState(() {
        _visible4 = !_visible4;
      });
    }
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      Future.delayed(const Duration(milliseconds: 750), () {
        if (mounted) {
          setState(() {
            _visible1 = !_visible1;
          });
        }
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _visible2 = !_visible2;
          });
        }
      });
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted) {
          setState(() {
            _visible3 = !_visible3;
          });
        }
      });
      if (mounted) {
        setState(() {
          _visible4 = !_visible4;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 80,
        height: 130,
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 30,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _visible1 ? 1.0 : 0.0,
                child: RotationTransition(
                  turns: new AlwaysStoppedAnimation(340 / 360),
                  child: Image.asset(
                    'assets/images/logoNoBackground.png',
                    width: 10,
                    height: 10,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 25,
              left: 35,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _visible2 ? 1.0 : 0.0,
                child: RotationTransition(
                  turns: new AlwaysStoppedAnimation(20 / 360),
                  child: Image.asset(
                    'assets/images/logoNoBackground.png',
                    width: 18,
                    height: 18,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 20,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: _visible3 ? 1.0 : 0.0,
                child: RotationTransition(
                  turns: new AlwaysStoppedAnimation(340 / 360),
                  child: Image.asset(
                    'assets/images/logoNoBackground.png',
                    width: 25,
                    height: 25,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 80,
              left: 30,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _visible4 ? 1.0 : 0.0,
                child: RotationTransition(
                  turns: new AlwaysStoppedAnimation(20 / 360),
                  child: Image.asset(
                    'assets/images/logoNoBackground.png',
                    width: 35,
                    height: 35,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
