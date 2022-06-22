import 'package:flutter/foundation.dart';

class ReviewByStore<String, double, bool> {
  final String reviewId;
  final String userAlias;
  final double storeId;
  final double menuId;
  final double score;
  final String content;
  final String imagePath;
  final String? propose;
  final bool delete;
  final String registerDate;

  ReviewByStore(
      this.reviewId,
      this.userAlias,
      this.storeId,
      this.menuId,
      this.score,
      this.content,
      this.imagePath,
      this.propose,
      this.delete,
      this.registerDate);
}
