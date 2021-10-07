import 'dart:async';
import 'package:deanora/main.dart';
import 'package:deanora/screen/MyLogin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tutorial extends StatefulWidget {
  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  final List<String> images = <String>[
    'tutorial1.jpg',
    'tutorial2.jpg',
    'tutorial3.jpg',
    'tutorial4.jpg'
  ];
  int doneCnt = 0;
  PageController _pController = PageController();
  StreamController _sController = StreamController<int>()..add(0);
  Widget doneOrnot = new TextButton(
    onPressed: () {},
    child: Text(""),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      PageView.builder(
          onPageChanged: (value) {
            setState(() {
              if (value == 3) {
                doneOrnot = new TextButton(
                  onPressed: () {
                    _controlTutorial();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyLogin()));
                  },
                  child: Text(
                    "Done",
                    style: TextStyle(
                        color: Color(0xff191919), fontWeight: FontWeight.w900),
                  ),
                );
              } else {
                doneOrnot = new TextButton(
                  onPressed: () {},
                  child: Text(""),
                );
              }
            });
            _sController.add(value);
          },
          controller: PageController(initialPage: 0),
          itemCount: images.length,
          itemBuilder: (BuildContext context, int index) {
            return Center(child: Image.asset('assets/images/${images[index]}'));
          }),
      Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                _controlTutorial();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => MyLogin()));
              },
              child: Text(
                "Skip",
                style: TextStyle(
                    color: Color(0xff191919), fontWeight: FontWeight.w900),
              ),
            ),
            SizedBox(
                height: 50,
                child: StreamBuilder<dynamic>(
                    stream: _sController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                width: 9,
                                height: 9,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (snapshot.data == index)
                                        ? Color(0xff745BD1)
                                        : Color(0xffD9B4FF)),
                              );
                            });
                      }
                      return Container();
                    })),
            doneOrnot
          ],
        ),
      ),
    ]));
  }

  _controlTutorial() async {
    int isViewed = 0;
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt('Tutorial', isViewed);
    print(pref.getInt('Tutorial'));
  }
}
