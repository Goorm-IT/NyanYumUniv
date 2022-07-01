import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/model/yum_store_list_composition.dart';
import 'package:flutter/material.dart';

class StoreInfoProvider extends ChangeNotifier {
  YumStorehttp yumStorehttp = YumStorehttp();
  List<StoreComposition> _storeInfo = [];
  List<StoreComposition> get storeInfo => _storeInfo;

  loadStoreInfo(int startPageNo, int endPageNo, [String category = ""]) async {
    List<StoreComposition> storeInfoList =
        await yumStorehttp.storeList2(startPageNo, endPageNo, category);
    if (startPageNo == 1) {
      _storeInfo = storeInfoList;
    } else {
      _storeInfo += storeInfoList;
    }
    notifyListeners();
  }
}