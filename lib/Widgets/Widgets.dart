import 'package:flutter/material.dart';

Container cover_Background() {
  return Container(
    decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xff8C65EC), Color(0xff6D6CEB)])),
  );
}

Future<dynamic> showdialog(
  BuildContext context,
  String message,
) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      content: Text('$message '),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('확인'),
        ),
      ],
    ),
  );
}

/// [w] img width
/// [h] img height
/// [name] img just name not address
Container putimg(w, h, name) {
  return Container(
      child: (Image.asset(
    'assets/images/$name.png',
    width: w,
    height: h,
  )));
}

/// [_controller] id or pw controller
/// [hinttext] Input Text
/// [icon] Input Icon
/// [obscure] true or false //bool



// /// [props] crawl.crawlClasses(id.text, pw.text) //classPrpps
// List classes(props) {
//   List classes = [];
//   props
//       .map((x) =>
//           {classes.add(Lecture(x["className"], x["profName"], x["classId"]))})
//       .toList();
//   return classes;
// }

// /// [props] crawl.crawlUser(id.text, pw.text) //userPrpps
// List user(props) {
//   List user = [];
//   user.add(NyanUser(props["name"], props["studentId"]));
//   //print(user[0].name);
//   return user;
// }

/// [props] await crawl.crawlAssignments(id, pw, cId); //assignmentProps
// List assignments(props) {
//   List assignment = [];
//   props
//       .map((x) => {
//             assignment.add(Assignment(
//                 x["title"], x["state"], x["startDate"], x["endDate"]))
//           })
//       .toList();
//   return assignment;
// }

// Future<List> requestAssignment(id, pw, props) async {
//   try {
//     var crawl = new Crawl();
//     List<dynamic> assignment = [];
//     List doneCnt = [];

//     if (props != null) {
//       // var assignmentProps = await crawl.crawlAssignments(props.classId);

//       for (int i = 0; i < props.length; i++) {
//         var assignmentProps = await crawl.crawlAssignments(props[i].classId);
//         if (assignmentProps.length > 0) {
//           assignment = assignments(assignmentProps);
//           double tmp = 0.0;
//           for (int i = 0; i < assignment.length; i++) {
//             if (assignment[i].state == "제출완료") {
//               tmp++;
//             }
//           }
//           doneCnt.add(tmp / assignment.length);
//         } else {
//           doneCnt.add(0.0);
//         }
//       }
//       return doneCnt;
//     }
//     return [];
//   } catch (e) {
//     return Future.error(e);
//   }
// }

// requestDnc(id, pw, props) async {
//   var crawl = new Crawl();
//   List<dynamic> _assignment = [];
//   try {
//     var _assp = await crawl.crawlAssignments(props.classId);
//     if (_assp.length > 0) {
//       _assignment = assignments(_assp);
//       double tmp = 0.0;
//       for (int i = 0; i < _assignment.length; i++) {
//         if (_assignment[i].state == "제출완료") {
//           tmp++;
//         }
//       }

//       return (tmp / _assignment.length);
//     } else {
//       return 0.0;
//     }
//   } catch (e) {
//     return Future.error(e);
//   }
// }
