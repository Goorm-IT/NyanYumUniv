import 'package:deanora/http/customException.dart';
import 'package:deanora/object/assignment.dart';
import 'package:deanora/object/lecture.dart';
import 'package:deanora/object/user.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import '../customException.dart';

class Crawl with ChangeNotifier {
  String _cookie = '';
  static String id = "", pw = "";

  Future<http.StreamedResponse> _getResponse(String method, String url,
      [Map<String, String> headers = const {},
      Map<String, String> body = const {}]) {
    http.Request request = http.Request(method, Uri.parse(url));
    request.headers.addAll(headers);
    request.bodyFields = body;
    return request.send();
  }

  Future<void> _login() async {
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final body = {'userDTO.userId': id, 'userDTO.password': pw};
    final url = 'http://cyber.anyang.ac.kr/MUser.do?cmd=loginUser';
    final response = await _getResponse('POST', url, headers, body);

    String rawCookie = response.headers['set-cookie'] ?? '';
    if (response.headers['pragma'] != null)
      throw new CustomException(300, 'Login Failed');
    else {
      int index = rawCookie.indexOf(';');
      this._cookie = (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
    print('$_cookie  쿠키시바라');
  }

  Future<Map<String, String>> crawlUser() async {
    await _login();
    final url = 'http://cyber.anyang.ac.kr/MMain.do?cmd=viewIndexPage';
    final response = await _getResponse('GET', url, {'cookie': this._cookie});
    final document = parse(await response.stream.bytesToString());

    var loginBtn = document.getElementById('login_popup');
    var element = document.querySelector('.login_info > ul > li:last-child');

    if (loginBtn != null) throw new CustomException(301, 'Cookie has Expired1');

    String userData = element!.text;
    List<String> data = userData.split(' ');
    Map<String, String> user = {
      'name': data[0],
      'studentId': data[1].substring(1, data[1].length - 1)
    };
    GetIt.I.registerSingleton<NyanUser>(
        NyanUser(user["name"]!, user["studentId"]!),
        instanceName: "userInfo");
    return user;
  }

  Future<List<Map<String, String>>> crawlClasses() async {
    await _login();

    final url = 'http://cyber.anyang.ac.kr/MMain.do?cmd=viewIndexPage';
    final response = await _getResponse('GET', url, {'cookie': this._cookie});
    final document = parse(await response.stream.bytesToString());

    var loginBtn = document.getElementById('login_popup');
    var options = document.getElementsByTagName('option');
    List<Map<String, String>> classes = [];

    if (loginBtn != null) throw new CustomException(300, 'Cookie has Expired2');

    for (var i = 1; i < options.length; i++) {
      var data = options[i].attributes['value']?.split(',');
      classes.add({
        'classId': data?[0] ?? '',
        'className': options[i].text,
        'profName': data?[1] ?? ''
      });
    }
    List<Lecture> tmp = [];
    for (int i = 0; i < classes.length; i++) {
      tmp.add(Lecture(
        classes[i]["classId"]!,
        classes[i]["className"]!,
        classes[i]["profName"]!,
      ));
    }
    GetIt.I.registerSingleton<List<Lecture>>(
      tmp,
      instanceName: "classesInfo",
    );

    return classes;
  }

  Future<List<Map<String, String>>> crawlAssignments(String courseId) async {
    await _login();

    var url =
        'http://cyber.anyang.ac.kr/Learner.do?cmd=viewLearnerStatusList&courseDTO.courseId=$courseId&mainDTO.parentMenuId=menu_00101&mainDTO.menuId=menu_00100';
    var response = await _getResponse('GET', url, {'cookie': this._cookie});
    var document = parse(await response.stream.bytesToString());

    if (response.statusCode != 200)
      throw new CustomException(500, 'Homepage Error');

    var error = document.querySelector('.error_none');
    if (error != null) throw new CustomException(300, 'Cookie has Expired3');

    url =
        'https://cyber.anyang.ac.kr/MReport.do?cmd=viewReportInfoPageList&boardInfoDTO.boardInfoGubun=report&courseDTO.courseId=$courseId';
    response = await _getResponse('GET', url, {'cookie': this._cookie});
    document = parse(await response.stream.bytesToString());
    error = document.querySelector('.error_none');
    if (error != null) throw new CustomException(300, 'Cookie has Expired4');

    List<Map<String, String>> assignments = [];

    final elements = document.querySelectorAll('.board_list > ul > li');
    for (var i = 0; i < elements.length; i += 2) {
      List<String> date =
          (elements[i].querySelector('ul:nth-child(5) > li')?.text ?? '~')
              .split('~');
      assignments.add({
        'title': elements[i]
            .children
            .first
            .text
            .trim()
            .replaceAll('\t', '')
            .replaceAll('\n', ''),
        'state': elements[i + 1]
            .children
            .last
            .children
            .last
            .children[6]
            .children
            .last
            .text
            .trim(),
        'startDate': date[0].trim(),
        'endDate': date[1].trim()
      });
    }
    List<Assignment> tmp = [];
    for (int i = 0; i < assignments.length; i++) {
      tmp.add(Assignment(assignments[i]['title']!, assignments[i]['state']!,
          assignments[i]['startDate']!, assignments[i]['endDate']!));
    }
    GetIt.I.registerSingleton<List<Assignment>>(tmp, instanceName: courseId);

    return assignments;
  }

  Future<void> _logout() async {
    if (this._cookie == '')
      throw new CustomException(300, 'Already Logout');
    else
      this._cookie = '';
  }
}
