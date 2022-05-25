import 'package:flutter/material.dart';

class CategoryPair<Color, String> {
  final Color color;
  final String title;
  CategoryPair(this.color, this.title);
}

List<CategoryPair> categorytype = [
  CategoryPair(Color(0xffF3F3F5), "ALL"),
  CategoryPair(Color(0xffF3F3F5), "한식"),
  CategoryPair(Color(0xffF3F3F5), "패스트 푸드"),
  CategoryPair(Color(0xffF3F3F5), "일식"),
  CategoryPair(Color(0xffF3F3F5), "중식"),
  CategoryPair(Color(0xffF3F3F5), "분식"),
];
