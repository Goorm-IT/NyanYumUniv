import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class YumUserHttp {
  late String _cookie;
  String _uid;
  YumUserHttp(this._uid);

  Future<int> yumRegister(_nickName) async {
    final url = Uri.parse("http://52.79.251.162:80/auth/register");
    var response = await http
        .put(url, body: <String, String>{"uid": _uid, "nickName": _nickName});
    // print(response.body);
    return response.statusCode;
  }

  yumDelete() async {
    final url = Uri.http('52.79.251.162:80', '/auth/secession');
    var response = await http.delete(url, headers: {'Cookie': _cookie});
    // print(response.body);
  }

  Future<int> yumUpdateNickName(_nickName) async {
    final url = Uri.http(
        '52.79.251.162:80', '/auth/updateNickName', {"nickName": _nickName});
    var response = await http.post(url, headers: {'Cookie': _cookie});
    return response.statusCode;
  }

  Future<int> yumLogin() async {
    var url = Uri.http('52.79.251.162:80', '/auth/login', {"uid": _uid});
    var response = await http.get(url);
    String _tmpCookie = response.headers['set-cookie'] ?? '';
    var idx = _tmpCookie.indexOf(';');
    _cookie = (idx == -1) ? _tmpCookie : _tmpCookie.substring(0, idx);
    // if (response.statusCode == 200) {
    //   print(response.body);
    //   print(_cookie);
    // } else {
    //   print('Request failed with status: ${response.statusCode}.');
    // }
    print(_cookie);
    return response.statusCode;
  }

  Future<List<dynamic>> yumInfo() async {
    // print(_cookie);
    final url = Uri.http('52.79.251.162:80', '/auth/info');
    late List<dynamic> _list;
    var response = await http.get(url, headers: {'Cookie': _cookie});
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      _list = jsonDecode(responseBody);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return _list;
  }
}
