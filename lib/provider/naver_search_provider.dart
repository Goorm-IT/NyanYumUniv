import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/model/review_by_store.dart';
import 'package:deanora/model/yum_naver_search.dart';

import 'package:flutter/material.dart';

class NaverSearchProvider extends ChangeNotifier {
  NaverOpneApi naverOpneApi = NaverOpneApi();
  List<YumNaverSearch> _searchList = [];
  List<YumNaverSearch> get searchList => _searchList;

  getReviewByStore(String search) async {
    List<YumNaverSearch> _list = await naverOpneApi.searchNaver(search);
    print(_list);
    _searchList = _list;
    notifyListeners();
  }
}
