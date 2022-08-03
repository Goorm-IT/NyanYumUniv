import 'dart:convert';
import 'package:deanora/http/customException.dart';
import 'package:deanora/model/comment_by_store.dart';
import 'package:deanora/model/menu_by_store.dart';
import 'package:deanora/model/review_by_store.dart';
import 'package:deanora/model/yum_store_list_composition.dart';
import 'package:deanora/model/yum_top_5.dart';
import 'package:deanora/model/yum_user.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

late String _cookie;

class YumUserHttp {
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

  Future<List<StoreComposition>> storeTop5() async {
    List<dynamic> _list = [];
    final url = Uri.http(yumURL, '/nyu/store/monthly');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      _list = jsonDecode(responseBody)['storeList'];
      return _list
          .map<StoreComposition>((item) => StoreComposition.fromJson(item))
          .toList();
    } else {
      print('Request failed with status(top5): ${response.statusCode}.');
      return [];
    }
  }

  Future<List<dynamic>> storeList(int startPageNo, int endPageNo,
      [String category = '']) async {
    List<dynamic> _list = [];
    Map<String, dynamic> httpBody = category == ''
        ? {
            "startPageNo": startPageNo,
            "endPageNo": endPageNo,
          }
        : {
            "startPageNo": startPageNo,
            "endPageNo": endPageNo,
            "category": category,
          };
    final url = Uri.http(yumURL, '/nyu/stores',
        httpBody.map((key, value) => MapEntry(key, value.toString())));
    var response = await http.get(url);
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      _list = jsonDecode(responseBody)['storeList'];

      return _list;
    } else {
      print('Request failed with status(storeList1): ${response.statusCode}.');
      return [];
    }
  }

  Future<List<StoreComposition>> storeList2(int startPageNo, int endPageNo,
      [String category = '']) async {
    List<dynamic> _list = [];
    Map<String, dynamic> httpBody = category == ''
        ? {
            "startPageNo": startPageNo,
            "endPageNo": endPageNo,
          }
        : {
            "startPageNo": startPageNo,
            "endPageNo": endPageNo,
            "category": category,
          };
    final url = Uri.http(yumURL, '/nyu/stores',
        httpBody.map((key, value) => MapEntry(key, value.toString())));
    var response = await http.get(url);
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);

      _list = json.decode(responseBody)['storeList'];

      return _list
          .map<StoreComposition>((item) => StoreComposition.fromJson(item))
          .toList();
    } else {
      print('Request failed with status(storeList2): ${response.statusCode}.');
      return [];
    }
  }
}

class YumMenuhttp {
  String yumURL = '54.180.116.149:82';
  Future<List<MenuByStore>> menuByStore(String storeId) async {
    List<dynamic> _list = [];
    final url = Uri.http(yumURL, '/nyu/menu/store', {"storeId": storeId});
    var response = await http.get(url);
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      _list = jsonDecode(responseBody)['MenuList'];

      return _list
          .map<MenuByStore>((item) => MenuByStore.fromJson(item))
          .toList();
    } else {
      print('Request failed with status(menuByStore): ${response.statusCode}.');
      return [];
    }
  }
}

class YumReviewhttp {
  String yumURL = '54.180.116.149:82';

  Future<List<ReviewByStore>> reviewByStore(String storeId) async {
    List<dynamic> _list = [];
    final url = Uri.http(yumURL, '/nyu/review/store', {"storeId": storeId});
    var response = await http.get(url);
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      _list = jsonDecode(responseBody)['reviewList'];

      return _list
          .map<ReviewByStore>((item) => ReviewByStore.fromJson(item))
          .toList();
    } else {
      print(
          'Request failed with status(reviewByStore): ${response.statusCode}.');
      return [];
    }
  }

  Future<List<CommentByStore>> commentByStore(String storeId) async {
    List<dynamic> _list = [];
    final url = Uri.http(yumURL, '/nyu/review/content', {"storeId": storeId});
    var response = await http.get(url);
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      _list = jsonDecode(responseBody)['reviewList'];
      return _list
          .map<CommentByStore>((item) => CommentByStore.fromJson(item))
          .toList();
    } else {
      print(
          'Request failed with status(commentByStore): ${response.statusCode}.');
      return [
        CommentByStore(
          content: "-1",
          reviewId: -1,
        )
      ];
    }
  }

  Future<int> writeReview(
      String file, String content, int menuId, int score, int storeId,
      [String propose = ""]) async {
    var headers = {'Cookie': _cookie};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://54.180.116.149:82/nyu/review?content=$content&menuId=$menuId&score=$score&storeId=$storeId&propose=$propose'));
    request.files.add(await http.MultipartFile.fromPath('file', file));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
    return response.statusCode;
  }
}

class LikeApi {
  String yumURL = '54.180.116.149:82';

  Future<int> likeOnOff(String storeId) async {
    final url = Uri.http(yumURL, '/nyu/like', {"storeId": storeId});
    var response = await http.put(url, headers: {'Cookie': _cookie});
    return (jsonDecode(response.body)["status"]);
  }

  Future<int> checkLike(String storeId) async {
    final url = Uri.http(yumURL, '/nyu/like', {"storeId": storeId});
    var response = await http.get(url, headers: {'Cookie': _cookie});
    return (jsonDecode(response.body)["show"]);
  }
}

class SaveApi {
  String yumURL = '54.180.116.149:82';

  Future<int> saveOnOff(String storeId) async {
    final url = Uri.http(yumURL, '/nyu/save', {"storeId": storeId});
    var response = await http.put(url, headers: {'Cookie': _cookie});
    return (jsonDecode(response.body)["status"]);
  }

  Future<int> checkSave(String storeId) async {
    final url = Uri.http(yumURL, '/nyu/save', {"storeId": storeId});
    var response = await http.get(url, headers: {'Cookie': _cookie});
    return (jsonDecode(response.body)["show"]);
  }
}

class NaverOpneApi {
  String naverUrl = "https://openapi.naver.com";
  Future<List> naverSearchLocal(String title) async {
    String _list;

    var headers = {
      'X-Naver-Client-Id': '_x_EKHpKcNechFeudcch',
      'X-Naver-Client-Secret': 'TtNtDBjrGX'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://openapi.naver.com/v1/search/local.json?query=롯데리아 안양&display=5'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      _list = await response.stream.bytesToString();

      return jsonDecode(_list)["items"];
    } else {
      print(response.reasonPhrase);
      return [];
    }
  }
}
