import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:deanora/Widgets/LoginDataCtrl.dart';
import 'package:deanora/Widgets/custom_circlular_bar.dart';
import 'package:deanora/Widgets/custom_loading_image.dart';
import 'package:deanora/http/crawl/crawl.dart';
import 'package:deanora/menutabbar/custom_menu_tabbar.dart';
import 'package:deanora/object/assignment.dart';
import 'package:deanora/object/lecture.dart';
import 'package:deanora/object/user.dart';
import 'package:deanora/screen/nyanScreen/nyanMainScreen/myAssignment.dart';
import 'package:deanora/screen/nyanScreen/nyanSubScreen/MyCalendar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';

class CnDPair<T1, T2> {
  int index;
  double val;
  CnDPair(this.index, this.val);
}

class MyClass extends StatefulWidget {
  var id, pw;
  MyClass(this.id, this.pw);
  @override
  _MyClassState createState() => _MyClassState();
}

class _MyClassState extends State<MyClass> with TickerProviderStateMixin {
  List names = [];
  List<dynamic> assignment = [];
  List filteredNames = [];
  List fname = [];
  DateTime _refreshTime = DateTime.now();
  Icon searchIcon = new Icon(Icons.search);
  double ddnc = 0.0;
  Widget bar = new Text("");
  late Future<double> progressCnt;
  // late AnimationController animationController;
  late AnimationController _animationControllerFadePage;
  late BehaviorSubject<int> backButtonToggle;
  List myclasses = [];
  List dncList = [];
  int willpop = 0;
  _MyClassState();

  @override
  void initState() {
    super.initState();
    myclasses = GetIt.I<List<Lecture>>(instanceName: "classesInfo");
    _animationControllerFadePage = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 200));
    // animationController = AnimationController(
    //     duration: new Duration(milliseconds: 1000), vsync: this);
    // animationController.repeat();
    backButtonToggle = BehaviorSubject.seeded(-1);
  }

  @override
  void dispose() {
    _animationControllerFadePage.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    dncList = List.generate(10, (i) => 0.0);
    var windowHeight = MediaQuery.of(context).size.height;
    var windowWidth = MediaQuery.of(context).size.width;

    var ctrl = new LoginDataCtrl();
    Future<List> requestAssignment(props) async {
      var crawl = new Crawl(id: widget.id, pw: widget.pw);
      List<Assignment> assignments = [];
      List doneCnt = [];

      for (int i = 0; i < props.length; i++) {
        try {
          assignments = GetIt.I<List<Assignment>>(
            instanceName: props[i].classId,
          );
        } catch (e) {
          try {
            await crawl.crawlAssignments(props[i].classId);
            assignments =
                GetIt.I<List<Assignment>>(instanceName: props[i].classId);
          } catch (e) {
            print(e);
          }
        }
        if (assignments.length > 0) {
          double tmp = 0.0;
          for (int i = 0; i < assignments.length; i++) {
            if (assignments[i].state == "제출완료") {
              tmp++;
            }
          }
          doneCnt.add(tmp / assignments.length);
        } else {
          doneCnt.add(0.0);
        }
      }

      return doneCnt;
    }

    return WillPopScope(
      onWillPop: () async {
        print('willpop $willpop');
        if (willpop == 1) {
          backButtonToggle.sink.add(1);
          return false;
        } else {
          backButtonToggle.sink.add(-1);
          return true;
        }
      },
      child: MaterialApp(
        home: Scaffold(
            // appBar: myAppbar(context),
            resizeToAvoidBottomInset: false,
            body: Container(
              color: Colors.white,
              child: SafeArea(
                bottom: false,
                child: Stack(children: [
                  Container(
                    color: Colors.white,
                    child: Container(
                      margin:
                          const EdgeInsets.only(top: 3, left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 20,
                            child: GestureDetector(
                                onTap: () async {
                                  ctrl.removeLoginData();
                                  Navigator.pop(context);
                                },
                                child: RotationTransition(
                                  turns: new AlwaysStoppedAnimation(180 / 360),
                                  child: Icon(
                                    Icons.logout_outlined,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: 10,
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
                                    text:
                                        "${GetIt.I<NyanUser>(instanceName: "userInfo").name}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18),
                                  ),
                                  TextSpan(text: "님")
                                ])),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // Text((myclasses[0].test).toString()),
                          Container(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("내 강의실 List",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18)),
                                  InkWell(
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyCalendar()));
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
                          CustomRefreshIndicator(
                            builder: (BuildContext refreshContext, Widget child,
                                IndicatorController controller) {
                              return AnimatedBuilder(
                                animation: controller,
                                builder: (BuildContext context, _) {
                                  if (controller.isLoading) {
                                    _animationControllerFadePage.forward();
                                  }
                                  return Stack(
                                    alignment: Alignment.topCenter,
                                    children: <Widget>[
                                      Transform.translate(
                                        offset:
                                            Offset(0, 50.0 * controller.value),
                                        child: child,
                                      ),
                                      if (controller.isLoading)
                                        FadeTransition(
                                          opacity: _animationControllerFadePage,
                                          child: Stack(
                                            children: [
                                              Container(
                                                width: windowWidth,
                                                height: windowHeight - 200,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (!controller.isIdle)
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: SizedBox(
                                            height: 130,
                                            width: 100,
                                            child: CustomLoadingImage(),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              );
                            },
                            onRefresh: _refresh,
                            // onRefresh: () =>
                            //     Future.delayed(const Duration(seconds: 3)),
                            child: FutureBuilder(
                                future: requestAssignment(myclasses),
                                builder: (futureContext, AsyncSnapshot snap) {
                                  if (snap.hasData) {
                                    dncList = snap.data;
                                    return Center(
                                      child: SizedBox(
                                        height: windowHeight - 270,
                                        child: myclasses.length != 0
                                            ? ListView.builder(
                                                itemCount: myclasses.length,
                                                itemBuilder:
                                                    (BuildContext classContext,
                                                        int index) {
                                                  return _ClassList(
                                                    context,
                                                    myclasses[index],
                                                    dncList[index],
                                                    widget.id,
                                                    widget.pw,
                                                  );
                                                })
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
                                        alignment: Alignment.center,
                                        child: CustomLoadingImage());
                                  }
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                  CustomMenuTabbar(
                    menuTabBarToggle: (int id) {
                      willpop = id;
                    },
                    backButtonToggle: backButtonToggle,
                    parentsContext: context,
                  ),
                ]),
              ),
            )),
      ),
    );
  }

  Future<void> _refresh() async {
    await Crawl(id: widget.id, pw: widget.pw).crawlClasses();
    for (int i = 0; i < myclasses.length; i++) {
      await Crawl(id: widget.id, pw: widget.pw)
          .crawlAssignments(myclasses[i].classId);
    }
    Navigator.pushReplacement(
        context,
        PageTransition(
          duration: Duration(milliseconds: 250),
          type: PageTransitionType.fade,
          child: MyClass(widget.id, widget.pw),
        ));
  }
}

class _ClassList extends StatefulWidget {
  BuildContext pageContext;
  var props;
  var dnc;
  String saved_id;
  String saved_pw;
  _ClassList(
      this.pageContext, this.props, this.dnc, this.saved_id, this.saved_pw);
  @override
  _ClassListState createState() => _ClassListState();
}

class _ClassListState extends State<_ClassList> with TickerProviderStateMixin {
  _ClassListState();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var crawl = new Crawl(id: widget.saved_id, pw: widget.saved_pw);
        var _adssi = await crawl.crawlAssignments(widget.props.classId);
        Navigator.push(
            widget.pageContext,
            MaterialPageRoute(
                builder: (context) => MyAssignment(widget.props, widget.dnc)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 2, color: Colors.grey.withOpacity(0.03)),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(3, 5),
            )
          ],
        ),
        child: Container(
          margin:
              const EdgeInsets.only(top: 20, right: 30, left: 25, bottom: 18),
          child: Stack(
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(widget.pageContext).size.width - 205,
                      child: Text(
                        widget.props.className,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff707070),
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(' ${widget.props.profName} 교수님',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff707070))),
                  ]),
              Container(
                  alignment: Alignment.centerRight,
                  child: CustomCircularBar(vsync: this, upperBound: widget.dnc))
            ],
          ),
        ),
      ),
    );
  }
}
