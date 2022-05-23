import 'package:blur/blur.dart';
import 'package:deanora/const/color.dart';
import 'package:deanora/screen/nyanScreen/nyanSubScreen/MyCalendar.dart';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

typedef MenuTabBarToggle = void Function(int);

class CustomMenuTabbar extends StatefulWidget {
  final MenuTabBarToggle menuTabBarToggle;
  final BuildContext parentsContext;
  BehaviorSubject<int> backButtonToggle;
  CustomMenuTabbar(
      {required this.menuTabBarToggle,
      required this.backButtonToggle,
      required this.parentsContext,
      Key? key})
      : super(key: key);

  @override
  State<CustomMenuTabbar> createState() => _CustomMenuTabbarState();
}

class _CustomMenuTabbarState extends State<CustomMenuTabbar>
    with TickerProviderStateMixin {
  List<RadioCustom> radioModel = [];
  List<Widget> classList = [];
  List<Widget> foodList = [];
  late BehaviorSubject<int> _isActivated;
  late BehaviorSubject<double> _positionButton;
  late PublishSubject<double> _opacity;
  late AnimationController _animationControllerUp;
  late AnimationController _animationControllerDown;
  late AnimationController _animationControllerRotate;
  late AnimationController _animationControllerFadeText;
  late Animation<double> _animationUp;
  late Animation<double> _animationDown;
  late Animation<double> _animationRotate;
  late final void Function() _listenerDown;
  late final void Function() _listenerUp;

  @override
  initState() {
    super.initState();
    radioModel.add(new RadioCustom(true, "onNyum", "offNyum", "내 강의실", 0));
    radioModel.add(new RadioCustom(false, "onYum", "offYum", "맛집 찾기", 1));
    _animationControllerUp = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 700));
    _animationControllerDown = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 700));
    _animationControllerRotate = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 500));
    _animationControllerFadeText = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 240));
    _isActivated = BehaviorSubject.seeded(-1); // on off(-1)
    _opacity = PublishSubject<double>(); // on off 됐을때 투명도로 페이지 관리
    _positionButton =
        BehaviorSubject.seeded(0); // 버튼의 첫위치 default값 margin+ 10 이 실제 위치
    _animationRotate = Tween<double>(begin: 0, end: 2.3).animate(
        CurvedAnimation(
            parent: _animationControllerRotate,
            curve: Curves.ease)); // 버튼 눌렀을때 회전

    _listenerUp = () {
      // 처음 위아래 움직일때
      _opacity.sink.add(1.0);
      _positionButton.sink.add(_animationUp.value);
    };
    _animationControllerUp.addListener(_listenerUp);

    _listenerDown = () {
      _positionButton.sink.add(_animationDown.value);
    };
    _animationControllerDown.addListener(_listenerDown);

    classList.add(menuList(
      "학사일정",
      MyCalendar(),
    ));
    classList.add(menuList(
      "교내 공지사항",
    ));
    classList.add(menuList(
      "시간표",
    ));
    foodList.add(menuList(
      "내가 쓴 리뷰",
    ));
    foodList.add(menuList(
      "저장한 맛집",
    ));
    foodList.add(menuList(
      "마이페이지",
    ));
    foodList.add(menuList(
      "리뷰 작성",
    ));
  }

  void _calculateOpacity(double dy) {
    var opacity = (MediaQuery.of(context).size.height - dy) /
        (MediaQuery.of(context).size.height * 0.5 - 60);
    if (opacity >= 0 && opacity <= 1) _opacity.sink.add(opacity);
  }

  void _updateButtonPosition(double dy) {
    if (dy == -2222) {
      //내려갈때
      dy = radioModel[0].isSelected == true
          ? MediaQuery.of(context).size.height - classList.length * 60
          : MediaQuery.of(context).size.height - foodList.length * 60;
    } else if (dy == -3333) dy = MediaQuery.of(context).size.height - 100;
    var position = (MediaQuery.of(context).size.height - dy - 50);

    if (position > 0) {
      _positionButton.sink.add(position);

      _animationUp = Tween<double>(
              //Nyum
              begin: position,
              end: radioModel[0].isSelected == true
                  ? classList.length * 60
                  : foodList.length * 60)
          .animate(new CurvedAnimation(
              parent: _animationControllerUp, curve: Curves.ease));

      _animationDown = new Tween<double>(begin: position, end: 0.0).animate(
          new CurvedAnimation(
              parent: _animationControllerDown, curve: Curves.ease));
    }
  }

  void _moveButtonDown() {
    _animationControllerDown.forward().whenComplete(() {
      _animationControllerDown.removeListener(_listenerDown);
      _animationControllerDown.reset();
      _animationDown.addListener(_listenerDown);
    });

    _animationControllerRotate.reverse();
    _isActivated.sink.add(-1);

    widget.menuTabBarToggle(-1);
  }

  void _moveButtonUp() {
    _animationControllerUp.forward().whenComplete(() {
      _animationControllerUp.removeListener(_listenerUp);
      _animationControllerUp.reset();
      _animationUp.addListener(_listenerUp);
    });

    _animationControllerRotate.forward();
    _isActivated.sink.add(1);
    widget.menuTabBarToggle(1);
  }

  void _movementCancel(double dy) {
    if ((MediaQuery.of(context).size.height - dy) <
        MediaQuery.of(context).size.height * 0.2) {
      _moveButtonDown();
    } else {
      _moveButtonUp();
    }
  }

  void _finishedMovement(double dy) {
    if ((MediaQuery.of(context).size.height - dy).round() ==
        (MediaQuery.of(context).size.height * 0.2).round())
      _isActivated.sink.add(1);
    widget.menuTabBarToggle(1);
  }

  @override
  void dispose() {
    _isActivated.close();
    _positionButton.close();
    _opacity.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: widget.backButtonToggle.stream,
        builder: (context, snapshot) {
          print(
              '_isActivated.stream.value: ${_isActivated.stream.value},snapshot.data: ${snapshot.data}');
          if (_isActivated.stream.value == 1 && snapshot.data == 1) {
            _moveButtonDown();
          }
          return Stack(
            children: [
              Align(
                //하단 2개의 버튼
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 80,
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _Radio(
                          onOff: (bool boolean) {
                            setState(() {
                              radioModel[0].isSelected = boolean;
                              radioModel[1].isSelected = !boolean;
                            });
                          },
                          onbutton: radioModel[0],
                        ),
                        _Radio(
                          onOff: (bool boolean) {
                            setState(() {
                              radioModel[1].isSelected = boolean;
                              radioModel[0].isSelected = !boolean;
                            });
                          },
                          onbutton: radioModel[1],
                        ),
                      ]),
                ),
              ),
              StreamBuilder(
                  // 메뉴 켜졌을때 페이지
                  stream: _isActivated.stream,
                  builder: (context, AsyncSnapshot<int> snapshot) {
                    if (snapshot.data == -1) {
                      return Container(height: 0, width: 0);
                    } else {
                      return StreamBuilder(
                          initialData: 0.0,
                          stream: _opacity.stream,
                          builder: (context, AsyncSnapshot<double> snapshot) {
                            return Opacity(
                                opacity: snapshot.data ?? 0,
                                child: new StreamBuilder(
                                    initialData: 0.0,
                                    stream: _positionButton.stream,
                                    builder: (context,
                                        AsyncSnapshot<double> snapshot) {
                                      var positon = snapshot.data! >=
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.3
                                          ? (MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.3) -
                                              (snapshot.data! -
                                                  (MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.3))
                                          : snapshot.data;
                                      return Blur(
                                        blur: 10,
                                        child: Opacity(
                                          opacity: 0.6,
                                          child: ClipPath(
                                              clipper:
                                                  _ContainerClipper(positon!),
                                              child: Container(
                                                width: double.infinity,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                //color:background
                                                decoration: BoxDecoration(
                                                    color: Colors.white),
                                              )),
                                        ),
                                      );
                                    }));
                          });
                    }
                  }),
              FadeTransition(
                //페이지 켜졌을때 리스트
                opacity: _animationControllerFadeText,
                child: Padding(
                  padding: radioModel[0].isSelected == true
                      ? EdgeInsets.only(
                          top: MediaQuery.of(context).size.height -
                              classList.length * 60 -
                              50)
                      : EdgeInsets.only(
                          top: MediaQuery.of(context).size.height -
                              foodList.length * 60 -
                              50),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: new StreamBuilder(
                        stream: _isActivated.stream,
                        builder: (context, AsyncSnapshot<int> snapshot) {
                          if (snapshot.data == 1) {
                            _animationControllerFadeText.forward();
                            return Column(
                                children: (radioModel[0].isSelected == true)
                                    ? classList
                                    : foodList);
                          } else {
                            _animationControllerFadeText.reverse();
                            return Container();
                          }
                        }),
                  ),
                ),
              ),
              Container(
                //아이콘 버튼
                margin: const EdgeInsets.only(bottom: 50),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Listener(
                      onPointerDown: (_) {
                        _isActivated.sink.add(0);
                        widget.menuTabBarToggle(0);
                      },
                      onPointerUp: (e) {
                        _movementCancel(e.position.dy);
                      },
                      onPointerMove: (e) async {
                        _updateButtonPosition(e.position.dy);
                        _calculateOpacity(e.position.dy);
                        _finishedMovement(e.position.dy);
                      },
                      child: StreamBuilder(
                          stream: _positionButton.stream,
                          initialData: 0.0,
                          builder: (context, AsyncSnapshot snapshot) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: snapshot.data),
                              child: StreamBuilder(
                                stream: _isActivated.stream,
                                builder: (context, AsyncSnapshot snapshot) {
                                  return FloatingActionButton(
                                    heroTag: null,
                                    elevation: 0,
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      child: Transform.rotate(
                                        angle: _animationRotate.value,
                                        child: Icon(
                                          Icons.add,
                                          size: 30,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: <Color>[
                                              PRIMARY_COLOR_DEEP,
                                              PRIMARY_COLOR_LIGHT,
                                            ]),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_isActivated.stream.value == 1) {
                                        _updateButtonPosition(-2222);
                                        _moveButtonDown();
                                      } else {
                                        _updateButtonPosition(-3333);
                                        _moveButtonUp();
                                      }
                                    },
                                  );
                                },
                              ),
                            );
                          }),
                    )),
              ),
            ],
          );
        });
  }

  Widget menuList(String name, [nav]) {
    return GestureDetector(
      onTap: () {
        if (nav != null) {
          widget.menuTabBarToggle(-1);
          _moveButtonDown();
          Navigator.push(widget.parentsContext,
              MaterialPageRoute(builder: (context) => nav));
        }
      },
      child: new Container(
          child: new Text(name,
              style: TextStyle(color: Colors.black, fontSize: 18)),
          margin: EdgeInsets.all(15)),
    );
  }
}

typedef MenuOnOff = void Function(bool);

class _Radio extends StatefulWidget {
  final RadioCustom onbutton;
  final MenuOnOff onOff;
  const _Radio({required this.onOff, required this.onbutton, Key? key})
      : super(key: key);

  @override
  State<_Radio> createState() => _RadioState();
}

class _RadioState extends State<_Radio> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      child: GestureDetector(
        onTap: () {
          widget.onOff(true);
        },
        child: _RadioItem(widget.onbutton),
      ),
    );
  }
}

class _RadioItem extends StatelessWidget {
  final RadioCustom _item;
  _RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipPath(
        clipper: _CustomPath(_item.idx),
        child: Container(
            width: MediaQuery.of(context).size.width / 2,
            color: Color(0xfff4f4f4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _item.isSelected
                    ? Image.asset(
                        'assets/images/${_item.onIcon}.png',
                        width: 20,
                        height: 25,
                      )
                    : Image.asset(
                        'assets/images/${_item.offIcon}.png',
                        width: 20,
                        height: 25,
                      ),
                Text(
                  _item.title,
                  style: TextStyle(
                      color:
                          _item.isSelected ? Colors.black : Color(0xffcccccc)),
                ),
              ],
            )),
      ),
    );
  }
}

class _CustomPath extends CustomClipper<Path> {
  final int index;
  _CustomPath(this.index);
  var radius = 40.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    if (index == 0) {
      path.lineTo(0.0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, radius);
      path.arcToPoint(Offset(size.width - radius, 0.0),
          clockwise: true, radius: Radius.circular(radius));
    } else if (index == 1) {
      path.moveTo(radius, 0.0);
      path.arcToPoint(Offset(0.0, radius),
          clockwise: true, radius: Radius.circular(radius));
      path.lineTo(0.0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0.0);
    }

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class _ContainerClipper extends CustomClipper<Path> {
  final double dy;
  _ContainerClipper(this.dy);

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, 0.0);
    path.lineTo(0.0, size.height);
    if (dy > -20)
      path.quadraticBezierTo((size.width / 2) - 28, size.height - 20,
          size.width / 2, size.height - dy - 56);
    path.lineTo(size.width / 2, size.height - (dy == 0 ? 0 : (dy + 56)));
    if (dy > -20)
      path.quadraticBezierTo(
          (size.width / 2) + 28, size.height - 20, size.width, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0.0, 0.0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class _MenuList extends StatelessWidget {
  final String name;
  final nav;
  const _MenuList({required this.name, this.nav, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (nav != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => nav));
        }
      },
      child: new Container(
          child: new Text(name,
              style: TextStyle(color: Colors.black, fontSize: 18)),
          margin: EdgeInsets.all(15)),
    );
  }
}

class RadioCustom {
  bool isSelected;
  final String onIcon;
  final String offIcon;
  final String title;
  final int idx;

  RadioCustom(this.isSelected, this.onIcon, this.offIcon, this.title, this.idx);
}
