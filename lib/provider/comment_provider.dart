import 'package:deanora/http/yumServer/yumHttp.dart';
import 'package:deanora/model/comment_by_store.dart';
import 'package:flutter/material.dart';

class CommentProvider extends ChangeNotifier {
  YumReviewhttp yumReviewhttp = YumReviewhttp();
  List<CommentByStore> _comment = [];
  List<CommentByStore> get comment => _comment;

  getCommentByStore(String storeId) async {
    List<CommentByStore> _list = await yumReviewhttp.commentByStore(storeId);
    _comment = _list;
    notifyListeners();
  }
}
