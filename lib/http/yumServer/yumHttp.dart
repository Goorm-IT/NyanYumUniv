import 'dart:convert';
import 'package:deanora/http/customException.dart';
import 'package:deanora/object/yum_user.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class YumUserHttp {
  late String _cookie;
  String _uid;
  YumUserHttp(this._uid);
  String yumURL = '54.180.116.149:82';
  Future<int> yumRegister(_email) async {
    // final url = Uri.parse("http://52.79.251.162:80/auth/register");
    // var response = await http
    //     .put(url, body: <String, String?>{"uid": _uid, "nickName": _nickName});
    // // print(response.body);

    final url = Uri.http(yumURL, '/nyu/user');
    var response = await http
        .post(url, body: <String, String>{"uid": _uid, "userAlias": _email});
    print(response.body);
    return response.statusCode;
  }

  yumDelete() async {
    final url = Uri.http(yumURL, '/nyu/user');
    var response = await http.delete(
      url,
      headers: {'Cookie': _cookie},
    );
    // print(response.body);
  }

  Future<int> yumUpdateNickName(userAlias) async {
    final url = Uri.http(yumURL, '/nyu/user/alias', {"userAlias": userAlias});
    var response = await http.put(url, headers: {'Cookie': _cookie});
    return response.statusCode;
  }

  Future<int> yumLogin() async {
    final url = Uri.http(yumURL, '/nyu/user/session', {"uid": _uid});
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

    return response.statusCode;
  }

  Future<int> yumProfileImg(imgPath) async {
    var headers = {'Cookie': _cookie};
    var request = http.MultipartRequest(
        'PUT', Uri.parse('http://54.180.116.149:82/nyu/user/image'));
    request.files.add(await http.MultipartFile.fromPath('file', imgPath));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response.statusCode;
  }

  Future<List<dynamic>> yumInfo() async {
    // print(_cookie);
    final url = Uri.http(yumURL, '/nyu/user');
    late List<dynamic> _list;
    var response = await http.get(url, headers: {'Cookie': _cookie});
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      _list = jsonDecode(responseBody);

      GetIt.I.registerSingleton<YumUser>(YumUser(
        uid: _list[0]["uid"],
        userAlias: _list[0]["userAlias"],
        userLevel: _list[0]["userLevel"],
        imagePath: _list[0]["imagePath"],
        registerDate: _list[0]["registerDate"],
      ));
      return _list;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw new CustomException(300, 'Cookie has Expired2');
    }
  }
}

class YumStorehttp {
  String yumURL = '54.180.116.149:82';

  Future<List<dynamic>> storeTop5() async {
    List<dynamic> _list = [];
    final url = Uri.http(yumURL, '/nyu/store/monthly');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      _list = jsonDecode(responseBody)['storeList'];
      return _list;
    } else {
      print('Request failed with status(top5): ${response.statusCode}.');
      return [];
    }
  }

  Future<List<dynamic>> storeList(int startPageNo, int endPageNo) async {
    List<dynamic> _list = [];
    final url = Uri.http(
        yumURL,
        '/nyu/stores',
        {"startPageNo": startPageNo, "endPageNo": endPageNo}
            .map((key, value) => MapEntry(key, value.toString())));
    var response = await http.get(url);
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      _list = jsonDecode(responseBody)['storeList'];
      return _list;
    } else {
      print('Request failed with status(top5): ${response.statusCode}.');
      return [];
    }
  }
}
