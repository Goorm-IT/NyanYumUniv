import 'package:flutter/foundation.dart';

class StoreComposition<String, double> {
  final String imagePath;
  final String storeAlias;
  final double score;
  final String? comment;
  final String category;
  final String address;
  final double storeId;
  StoreComposition(this.imagePath, this.storeAlias, this.score, this.comment,
      this.category, this.address, this.storeId);
}
