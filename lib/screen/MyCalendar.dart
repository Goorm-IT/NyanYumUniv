import 'package:deanora/Widgets/MakeCalendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';

class MyCalendar extends StatefulWidget {
  const MyCalendar({Key? key}) : super(key: key);

  @override
  _MyCalendarState createState() => _MyCalendarState();
}

class PairList<T1, T2, T3> {
  List date;
  String schdule;
  List<PairSnC> color;
  PairList(this.date, this.schdule, this.color);
}

class _MyCalendarState extends State<MyCalendar> {
  CalendarViews _currentView = CalendarViews.dates;
  late int midYear;

  final List<String> _weekDays = ['S', "M", 'T', 'W', 'T', 'F', 'S'];
  final List<String> _monthNames = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC'
  ];

  final List<Color> _colors = [
    Color(0xffffefe8),
    Color(0xfffffce8),
    Color(0xffeaffe8),
    Color(0xffe8f3ff),
    Color(0xffffe8e8),
    Color(0xffefefef),
    Color(0xffe9e8ff),
    Color(0xfffbe8ff),
  ];
  List<PairList> _selected = [];
  List<Calendar> _sequentialDates = [];
  late DateTime _currentDateTime, _selectDateTime;
  late DateTime date;

  @override
  void initState() {
    super.initState();
    date = DateTime.now();
    _currentDateTime = DateTime(date.year, date.month);
    _selectDateTime = DateTime(date.year, date.month, date.day);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() => _getCalendar());
    });
  }

  void _getCalendar() {
    _sequentialDates = CustomCalendar().getMonthCalendar(
        _currentDateTime.month, _currentDateTime.year,
        startWeekDay: StartWeekDay.sunday);
    _getSelectedSchdule();
  }

  void _getSelectedSchdule() {
    _selected.clear();
    _sequentialDates.forEach((e) {
      if (e.thisMonth) {
        e.checkSchedule.forEach((v) {
          if (v.schdule != "") {
            _selected.add(PairList(v.date, v.schdule, e.snc));
          }
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color(0xffF9F9F9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(1, 3),
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30)),
              ),
              child: _dateView(),
            ),
            Container(
                height: 20,
                margin: EdgeInsets.only(left: 20, top: 15, bottom: 15),
                child: Text(
                  "${_currentDateTime.year}년 ${_currentDateTime.month}월 학사일정",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                )),
            Container(
              height: MediaQuery.of(context).size.height * 0.5 - 75,
              child: ListView.builder(
                itemCount: _selected.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(1, 3),
                        )
                      ],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Container(
                            margin: EdgeInsets.all(15),
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              color: _colors[index % 8],
                              borderRadius: BorderRadius.circular(100),
                            )),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(),
                            Text(
                              "${_selected[index].schdule}",
                              style: TextStyle(
                                  color: Color(0xff707070),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800),
                            ),
                            Container(
                              child: (_selected[index].date.length > 1)
                                  ? Text(
                                      "${DateFormat('MM. dd').format(_selected[index].date[0])}~ ${DateFormat('MM. dd').format(_selected[index].date[_selected[index].date.length - 1])}",
                                      style:
                                          TextStyle(color: Color(0xff707070)))
                                  : Text(
                                      "${DateFormat('MM. dd').format(_selected[index].date[0])}",
                                      style:
                                          TextStyle(color: Color(0xff707070))),
                            ),
                            SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Row(children: [
          _toggleBtn(false),
          Expanded(
              child: InkWell(
            onTap: () {
              setState(() {
                _currentView = CalendarViews.months;
              });
            },
            child: Center(
              child: Text(
                '${_monthNames[_currentDateTime.month - 1]}  ${_currentDateTime.year}',
                style: TextStyle(
                    color: Color(0xff191919),
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
            ),
          )),
          _toggleBtn(true),
        ]),
        _calendarBody(),
      ],
    );
  }

  Widget _toggleBtn(bool next) {
    return InkWell(
      onTap: () {
        if (_currentView == CalendarViews.dates) {
          setState(() => {
                (next) ? _getNextMonth() : _getPrevMonth(),
              });
        }
      },
      child: Container(
        width: 50,
        height: 50,
        child: Icon(
          (next) ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
          color: Color(0xff707070),
        ),
      ),
    );
  }

  Widget _calendarBody() {
    if (_sequentialDates == null) return Text("Calendar Error");
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 30, right: 30),
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: _sequentialDates.length + 7, //dates+weekday
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 2.2),
          crossAxisCount: 7,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
        ),
        itemBuilder: (context, index) {
          if (index < 7) return _weekDayTitle(index);
          return _calendarDates(_sequentialDates[index - 7]);
        },
      ),
    );
  }

  Widget _weekDayTitle(int index) {
    return Container(
      padding: EdgeInsets.zero,
      child: Center(
        child: Text(
          _weekDays[index],
          style: TextStyle(color: Color(0xffBABABA), fontSize: 12),
        ),
      ),
    );
  }

  void _getNextMonth() {
    if (_currentDateTime.month == 12) {
      _currentDateTime = DateTime(_currentDateTime.year + 1, 1);
    } else {
      _currentDateTime =
          DateTime(_currentDateTime.year, _currentDateTime.month + 1);
    }
    _getCalendar();
  }

// get previous month calendar
  void _getPrevMonth() {
    if (_currentDateTime.month == 1) {
      _currentDateTime = DateTime(_currentDateTime.year - 1, 12);
    } else {
      _currentDateTime =
          DateTime(_currentDateTime.year, _currentDateTime.month - 1);
    }
    _getCalendar();
  }

  Widget _calendarDates(Calendar calendarDate) {
    List<Widget> _children = [];
    print(calendarDate.number);
    calendarDate.snc.sort((a, b) => b.order.compareTo(a.order));
    for (int i = 0; i < calendarDate.snc.length; i++) {
      if (calendarDate.thisMonth) {
        if (calendarDate.snc[i].shape == 3) {
          _children.add(Center(
            child: Container(
              height: 30,
              width: double.infinity,
              decoration: BoxDecoration(color: calendarDate.snc[i].color),
            ),
          ));
        }
        if (calendarDate.snc[i].shape == 1) {
          _children.add(Center(
            child: Container(
              height: 30,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: calendarDate.snc[i].color,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      topLeft: Radius.circular(100))),
            ),
          ));
        }
        if (calendarDate.snc[i].shape == 2) {
          _children.add(Center(
            child: Container(
              height: 30,
              width: double.infinity,
              decoration: BoxDecoration(
                color: calendarDate.snc[i].color,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(100),
                    topRight: Radius.circular(100)),
              ),
            ),
          ));
        }
      }
    }
    for (int i = 0; i < calendarDate.snc.length; i++) {
      if (calendarDate.thisMonth) {
        if (calendarDate.snc[i].shape == 4) {
          _children.add(Center(
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: calendarDate.snc[i].color,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ));
        }
      }
    }
    _children.add(
      Center(
        child: Text(
          '${calendarDate.date.day}',
          style: TextStyle(
              fontSize: 15,
              color: (calendarDate.thisMonth)
                  ? (calendarDate.single ||
                          calendarDate.left ||
                          calendarDate.right ||
                          calendarDate.middle)
                      ? Color(0xff707070)
                      : Color(0xffAAAAAA)
                  : Colors.white),
        ),
      ),
    );
    return InkWell(
      onTap: () {
        if (_selectDateTime != calendarDate.date) {
          if (calendarDate.nextMonth) {
            _getNextMonth();
          } else if (calendarDate.prevMonth) {
            _getPrevMonth();
          }
          setState(() => _selectDateTime = calendarDate.date);
        }
      },
      child: Stack(children: _children),
    );
  }
}

enum CalendarViews { dates, months, year }
