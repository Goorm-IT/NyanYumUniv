import 'package:flutter/material.dart';

class CategorySelectedProvider extends ChangeNotifier {
  String _selected = 'ALL';
  String get selected => _selected;

  getSelectedCategory(String category) {
    _selected = category;
    notifyListeners();
  }
}
