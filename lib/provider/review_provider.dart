import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/model/review_by_store.dart';

import 'package:flutter/material.dart';

class ReviewProvider extends ChangeNotifier {
  YumReviewhttp yumReviewhttp = YumReviewhttp();
  List<ReviewByStore> _review = [];
  List<ReviewByStore> get review => _review;

  getReviewByStore(String storeId) async {
    List<ReviewByStore> _list = await yumReviewhttp.reviewByStore(storeId);
    _review = _list;
    notifyListeners();
  }
}
