import 'dart:ffi';

import 'package:flutter/material.dart';

class CategoryPair<Color, String> {
  final Color color;
  final String title;
  bool isChecked;
  CategoryPair(this.color, this.title, this.isChecked);
}

List<CategoryPair> categorytype = [
  CategoryPair(Color(0xffF3F3F5), "ALL", true),
  CategoryPair(Color(0xffF3F3F5), "한식", false),
  CategoryPair(Color(0xffF3F3F5), "패스트 푸드", false),
  CategoryPair(Color(0xffF3F3F5), "일식", false),
  CategoryPair(Color(0xffF3F3F5), "중식", false),
  CategoryPair(Color(0xffF3F3F5), "분식", false),
];
