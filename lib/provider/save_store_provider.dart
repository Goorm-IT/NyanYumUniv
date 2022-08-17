import 'package:deanora/model/yum_store_list_composition.dart';
import 'package:flutter/material.dart';

import '../http/yumServer/yumHttp.dart';

class SaveStoreProvider extends ChangeNotifier {
  SaveApi saveApi = SaveApi();
  List<StoreComposition> _savedlist = [];
  List<StoreComposition> get savedlist => _savedlist;

  getSaveStore() async {
    List<StoreComposition> _list = await saveApi.getSaveList();
    _savedlist = _list;
    notifyListeners();
  }
}
