import 'dart:convert';
import 'package:deanora/http/customException.dart';
import 'package:deanora/model/comment_by_store.dart';
import 'package:deanora/model/menu_by_store.dart';
import 'package:deanora/model/review_by_store.dart';
import 'package:deanora/model/yum_naver_search.dart';
import 'package:deanora/model/yum_store_list_composition.dart';
import 'package:deanora/model/yum_top_5.dart';
import 'package:deanora/model/yum_user.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

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

  Future<List<StoreComposition>> getstorebyAlias(
      {required String storeAlias}) async {
    List<dynamic> _tmp;
    final url = Uri.http(
        yumURL, '/nyu/store/search', {"storeAlias": storeAlias, "order": "1"});
    var response = await http.get(url);
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      _tmp = jsonDecode(responseBody);
      return _tmp
          .map<StoreComposition>((item) => StoreComposition.fromJson(item))
          .toList();
    } else {
      print(
          'Request failed with status(getstorebyAlias): ${response.statusCode}.');
      return [];
    }
  }

  Future<void> addStore(
      {required String address,
      required String file,
      required String category,
      required String mapX,
      required String mapY,
      required String storeAlias}) async {
    var headers = {'Cookie': _cookie};
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://54.180.116.149:82/nyu/store?address=$address&category=$category&mapX=$mapX&mapY=$mapY&storeAlias=$storeAlias'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<List<StoreComposition>> storeList2(int startPageNo, int endPageNo,
      [String category = ""]) async {
    List<dynamic> _list = [];
    Map<String, dynamic> httpBody = category == ""
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

  Future<int> addMenu(
      {required int cost,
      required String menuAlias,
      required String storeId}) async {
    var headers = {'Cookie': _cookie};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://54.180.116.149:82/nyu/menu?cost=$cost&menuAlias=$menuAlias&storeId=$storeId'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print(response.statusCode);
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
    return response.statusCode;
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

  Future<List<ReviewByStore>> reviewbyUser() async {
    List<dynamic> _list = [];
    final url = Uri.http(yumURL, '/nyu/review/user');
    var response = await http.get(url, headers: {'Cookie': _cookie});
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      _list = jsonDecode(responseBody)['userReviewList'];
      return _list
          .map<ReviewByStore>((item) => ReviewByStore.fromJson(item))
          .toList();
    } else {
      return [];
    }
  }
}

class LikeApi {
  String yumURL = '54.180.116.149:82';

  Future<int> likeOnOff(String storeId) async {
    final url = Uri.http(yumURL, '/nyu/like', {"storeId": storeId});
    var response = await http.put(url, headers: {'Cookie': _cookie});
    if (response.statusCode == 200) {
      return (jsonDecode(response.body)["status"]);
    } else {
      throw new CustomException(300, 'likeOnoff');
    }
  }

  Future<int> checkLike(String storeId) async {
    final url = Uri.http(yumURL, '/nyu/like', {"storeId": storeId});
    var response = await http.get(url, headers: {'Cookie': _cookie});
    if (response.statusCode == 200) {
      return (jsonDecode(response.body)["show"]);
    } else {
      throw new CustomException(300, 'checkLike');
    }
  }

  Future<List<StoreComposition>> getLikeList() async {
    final url = Uri.http(yumURL, '/nyu/like/user');
    var response = await http.get(url, headers: {'Cookie': _cookie});
    List<dynamic> _list = [];
    String responseBody = utf8.decode(response.bodyBytes);
    _list = jsonDecode(responseBody)['userLikeList'];
    if (response.statusCode == 200) {
      return _list
          .map<StoreComposition>((item) => StoreComposition.fromJson(item))
          .toList();
    } else {
      throw new CustomException(300, 'getLikeList');
    }
  }
}

class SaveApi {
  String yumURL = '54.180.116.149:82';

  Future<int> saveOnOff(String storeId) async {
    final url = Uri.http(yumURL, '/nyu/save', {"storeId": storeId});
    var response = await http.put(url, headers: {'Cookie': _cookie});
    if (response.statusCode == 200) {
      return (jsonDecode(response.body)["status"]);
    } else {
      throw new CustomException(300, 'SaveOnOff');
    }
  }

  Future<int> checkSave(String storeId) async {
    final url = Uri.http(yumURL, '/nyu/save', {"storeId": storeId});
    var response = await http.get(url, headers: {'Cookie': _cookie});

    if (response.statusCode == 200) {
      return (jsonDecode(response.body)["show"]);
    } else {
      print(response.statusCode);
      throw new CustomException(300, 'checkSave');
    }
  }

  Future<List<StoreComposition>> getSaveList() async {
    final url = Uri.http(yumURL, '/nyu/save/user');
    var response = await http.get(url, headers: {'Cookie': _cookie});
    List<dynamic> _list = [];
    String responseBody = utf8.decode(response.bodyBytes);
    _list = jsonDecode(responseBody)['userSaveList'];
    if (response.statusCode == 200) {
      return _list
          .map<StoreComposition>((item) => StoreComposition.fromJson(item))
          .toList();
    } else {
      throw new CustomException(300, 'getSaveList');
    }
  }
}

class ReportApi {
  String yumURL = '54.180.116.149:82';

  Future<void> yumreport(String report, String reviewId) async {
    final url = Uri.http(
        yumURL, '/nyu/report', {"report": report, "reviewId": reviewId});
    var response = await http.post(url, headers: {'Cookie': _cookie});
    print(response.body);
  }
}

// class SupportApi {
//    String yumURL = '54.180.116.149:82';
//      Future<void> yumreport({required String category, required String content, required String re}) async {
//     final url = Uri.http(
//         yumURL, '/nyu/report', {"report": report, "reviewId": reviewId});
//     var response = await http.post(url, headers: {'Cookie': _cookie});
//     print(response.body);
//   }
// }

class NaverOpneApi {
  Future<String> getNaverMapImage(
      {required String x, required String y, required String title}) async {
    String convertX = x;
    String convertY = y;
    if (x == "" || y == "") {
      convertX = "304547";
      convertY = "532687";
      title = "안양대학교";
    }
    final url = Uri.parse(
        'https://naveropenapi.apigw.ntruss.com/map-static/v2/raster?crs=NHN:128&scale=2&format=png&w=310&h=170&markers=type:t|color:0xEE3A3A|pos:$convertX%20$convertY|label:$title');
    var response = await http.get(url, headers: {
      'X-NCP-APIGW-API-KEY-ID': 'n2d8s1sg7f',
      'X-NCP-APIGW-API-KEY': '9jmceo48SwKcMGqVdhnci4G4mn7YkYPPiF19xFp7'
    });
    String str;
    if (response.statusCode == 200) {
      return Base64Encoder().convert(response.bodyBytes);
    } else {
      print(response.statusCode);
      throw new CustomException(300, 'failLoadNaverMap');
    }
  }

  Future<List<YumNaverSearch>> searchNaver(String search) async {
    List<dynamic> _list = [];
    final url = Uri.parse(
        'https://openapi.naver.com/v1/search/local.json?query=안양 $search&display=5');
    var response = await http.get(url, headers: {
      'X-Naver-Client-Id': '_x_EKHpKcNechFeudcch',
      'X-Naver-Client-Secret': 'TtNtDBjrGX'
    });
    print(response.statusCode);

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      _list = jsonDecode(responseBody)['items'];
      return _list
          .map<YumNaverSearch>((item) => YumNaverSearch.fromJson(item))
          .toList();
    } else {
      print('Request failed with status(searchNaver): ${response.statusCode}.');
      return [];
    }
  }
}
