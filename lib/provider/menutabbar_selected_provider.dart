import 'package:flutter/material.dart';

class MenuTabBarSelectedProvider extends ChangeNotifier {
  int _selected = 1;
  int get selected => _selected;

  getSelectedCategory(int selected) {
    _selected = selected;
    notifyListeners();
  }
}
