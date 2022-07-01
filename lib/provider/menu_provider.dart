import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/model/menu_by_store.dart';

import 'package:flutter/material.dart';

class MenuProvider extends ChangeNotifier {
  YumMenuhttp yumMenuhttp = YumMenuhttp();
  List<MenuByStore> _menu = [];
  List<MenuByStore> get menu => _menu;

  getMenubyStore(String storeId) async {
    List<MenuByStore> _list = await yumMenuhttp.menuByStore(storeId);
    _menu = _list;
    notifyListeners();
  }
}
