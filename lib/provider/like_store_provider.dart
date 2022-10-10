import 'package:deanora/model/yum_store_list_composition.dart';
import 'package:flutter/material.dart';

import '../http/yumServer/yumHttp.dart';

class LikeStoreProvider extends ChangeNotifier {
  LikeApi likeApi = LikeApi();
  List<StoreComposition> _likedlist = [];
  List<StoreComposition> get likedlist => _likedlist;

  getLikeStore() async {
    try {
      List<StoreComposition> _list = await likeApi.getLikeList();
      _likedlist = _list;
      notifyListeners();
    } catch (e) {
      _likedlist = [];
      notifyListeners();
    }
  }
}
