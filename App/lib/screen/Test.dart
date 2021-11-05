import 'package:deanora/Widgets/MenuTabBar.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  @override
  _Test createState() => _Test();
}

class _Test extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new SafeArea(
            child: new Stack(children: <Widget>[
      new Center(
          child: new Text("Test",
              style:
                  TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
      new MenuTabBar(
        background: Color(0xff8C65EC),
        iconButtons: [
          new IconButton(
              color: Colors.blueGrey,
              icon: new Icon(Icons.home, size: 30),
              onPressed: () {}),
          new IconButton(
              color: Colors.blueGrey,
              icon: new Icon(Icons.search, size: 30),
              onPressed: () {}),
          new IconButton(
              color: Colors.blueGrey,
              icon: new Icon(Icons.map, size: 30),
              onPressed: () {}),
          new IconButton(
              color: Colors.blueGrey,
              icon: new Icon(Icons.favorite, size: 30),
              onPressed: () {}),
        ],
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                  child: new Text("Calendar",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  margin: EdgeInsets.all(10)),
              new Container(
                  child: new Text("Note",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  margin: EdgeInsets.all(10)),
              new Container(
                  child: new Text("기타",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  margin: EdgeInsets.all(10)),
              new Container(
                  child: new Text("등등...",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  margin: EdgeInsets.all(10))
            ]),
      )
    ])));
  }
}
