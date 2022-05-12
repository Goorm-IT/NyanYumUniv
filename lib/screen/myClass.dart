import 'package:deanora/Widgets/LoginDataCtrl.dart';
import 'package:deanora/Widgets/Widgets.dart';
import 'package:deanora/Widgets/custom_circlular_bar.dart';
import 'package:deanora/crawl/crawl.dart';
import 'package:deanora/screen/MyCalendar.dart';
import 'package:deanora/screen/MyLogin.dart';
import 'package:deanora/screen/MyAssignment.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import 'package:page_transition/page_transition.dart';
import '../Widgets/googleBanner.dart';

class CnDPair<T1, T2> {
  int index;
  double val;
  CnDPair(this.index, this.val);
}

class MyClass extends StatefulWidget {
  var id, pw, classProps, userProps;

  MyClass(this.id, this.pw, this.classProps, this.userProps);
  @override
  _MyClassState createState() =>
      _MyClassState(this.id, this.pw, this.classProps, this.userProps);
}

class _MyClassState extends State<MyClass> with TickerProviderStateMixin {
  var id, pw, classProps, userProps;
  List names = [];
  List<dynamic> assignment = [];
  String _searchText = "";
  List filteredNames = [];
  List fname = [];
  DateTime _refreshTime = DateTime.now();
  Icon searchIcon = new Icon(Icons.search);
  double ddnc = 0.0;
  Widget bar = new Text("");
  late Future<double> progressCnt;
  late AnimationController animationController;
  _MyClassState(this.id, this.pw, this.classProps, this.userProps);
  late FirebaseMessaging messaging;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);
    animationController.repeat();
    _getNames(classProps);

    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print(value);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
              buttonPadding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18))),
              title: Center(
                  child: Text(
                event.notification!.title!,
                style: TextStyle(fontWeight: FontWeight.w900),
              )),
              content: Container(
                  child: Text(
                event.notification!.body!,
                textAlign: TextAlign.center,
              )),
              actions: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: Color(0xffd2d2d5), width: 1.0))),
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        child: Text(
                          "확인",
                          style: TextStyle(color: Color(0xff755FE7)),
                        ),
                      )),
                )
              ],
            );
          });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    List dncList = List.generate(20, (i) => 0.0);
    var windowHeight = MediaQuery.of(context).size.height;
    var windowWidth = MediaQuery.of(context).size.width;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.black,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  color: Color(0xffFAFAFA),
                  child: SafeArea(
                    child:
                        GoogleBanner('ca-app-pub-3889684121903706/4549664650'),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 30,
                  margin: const EdgeInsets.only(left: 10, bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_circle,
                        color: Colors.blueGrey,
                        size: 35,
                      ),
                      Text.rich(TextSpan(children: <TextSpan>[
                        TextSpan(text: "  안녕하세요, "),
                        TextSpan(
                          text: "${user(userProps)[0].name}",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 18),
                        ),
                        TextSpan(text: "님")
                      ])),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("내 강의실 List",
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 18)),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyCalendar()));
                          },
                          child: Ink(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.event_available,
                                  size: 20,
                                ),
                                Text("학사일정"),
                              ],
                            ),
                          ),
                        )
                      ],
                    )),
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Builder(builder: (BuildContext refreshContext) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        _refresh(refreshContext);
                      },
                      child: FutureBuilder(
                          future: requestAssignment(id, pw, filteredNames),
                          builder: (futureContext, AsyncSnapshot snap) {
                            if (snap.hasData) {
                              dncList = snap.data;
                              return Center(
                                child: SizedBox(
                                  height: windowHeight - 180,
                                  child: filteredNames.length != 0
                                      ? ListView(
                                          children: filteredNames
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            var e = entry.value;
                                            var index = entry.key;
                                            return InkWell(
                                              onTap: () async {
                                                var crawl = new Crawl(id, pw);
                                                var _adssi = await crawl
                                                    .crawlAssignments(
                                                        e.classId);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MyAssignment(
                                                                e ?? "",
                                                                _adssi,
                                                                dncList[
                                                                    index])));
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 7,
                                                        horizontal: 7),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Colors.grey
                                                          .withOpacity(0.03)),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 4,
                                                      offset: Offset(3, 5),
                                                    )
                                                  ],
                                                ),
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 20,
                                                      right: 30,
                                                      left: 25,
                                                      bottom: 18),
                                                  child: Stack(
                                                    children: [
                                                      Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Container(
                                                              width:
                                                                  windowWidth -
                                                                      205,
                                                              child: Text(
                                                                e.className,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                softWrap: false,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Color(
                                                                        0xff707070),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                                ' ${e.profName} 교수님',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Color(
                                                                        0xff707070))),
                                                          ]),
                                                      Container(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child:
                                                              CustomCircularBar(
                                                                  vsync: this,
                                                                  upperBound:
                                                                      dncList[
                                                                          index]))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        )
                                      : ListView(children: [
                                          Center(child: Text("강의가 없습니다"))
                                        ]),
                                ),
                              );
                            } else if (snap.hasError) {
                              return Container(
                                height: windowHeight - 270,
                                child: ListView(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text(snap.error.toString()),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Container(
                                  alignment: Alignment.topCenter,
                                  child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator(
                                        valueColor: animationController.drive(
                                            ColorTween(
                                                begin: Color(0xff8E53E9),
                                                end: Colors.red)),
                                      )));
                            }
                          }),
                    );
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refresh(BuildContext context) async {
    int leftTime = 5 - DateTime.now().difference(_refreshTime).inSeconds;
    if (leftTime > 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '$leftTime초 후에 다시 시도해주세요',
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.blue,
      ));
      return;
    }
    _refreshTime = DateTime.now();
    Navigator.pushReplacement(
        context,
        PageTransition(
          duration: Duration(milliseconds: 250),
          type: PageTransitionType.fade,
          child: MyClass(this.id, this.pw, this.classProps, this.userProps),
        ));
  }

  PreferredSizeWidget myAppbar(BuildContext context) {
    var ctrl = new LoginDataCtrl();
    var windowWidth = MediaQuery.of(context).size.width;
    return PreferredSize(
      preferredSize: Size.fromHeight(40),
      child: new AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: bar,
        leading: new IconButton(
          onPressed: () {
            ctrl.removeLoginData();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyLogin()));
          },
          icon: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: Icon(
                Icons.logout,
                size: 22,
              )),
          color: Colors.grey,
        ),
        actions: <Widget>[
          new IconButton(
            onPressed: () {
              setState(() {
                if (this.searchIcon.icon == Icons.search) {
                  searchIcon = new Icon(Icons.close);
                  bar = Container(
                      width: windowWidth - 70,
                      height: 30,
                      child: Stack(
                        children: [
                          TextField(
                            autofocus: true,
                            onChanged: (text) {
                              _searchText = text;
                              print(_searchText);
                              if (!(_searchText == "")) {
                                List tmp = [];

                                for (int i = 0; i < fname.length; i++) {
                                  if (fname[i]
                                          .className
                                          .contains(_searchText) ||
                                      fname[i].profName.contains(_searchText)) {
                                    tmp.add(fname[i]);
                                  }
                                }
                                setState(() {
                                  filteredNames = tmp;
                                });
                              } else {
                                setState(() {
                                  filteredNames = fname;
                                });
                              }
                            },
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              height: 1,
                              width: 300,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: <Color>[
                                  Color(0xff8C65EC),
                                  Color(0xff6D6CEB)
                                ]),
                              ),
                            ),
                          )
                        ],
                      ));
                } else {
                  setState(() {
                    bar = new Text("");
                    searchIcon = new Icon(Icons.search);
                    filteredNames = fname;
                  });
                }
              });
            },
            icon: searchIcon,
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  _getNames(classProps) async {
    for (int i = 0; i < classes(classProps).length; i++) {
      names.add(classes(classProps)[i]);
    }
    setState(() {
      filteredNames = names;

      fname = names;
    });
  }
}
