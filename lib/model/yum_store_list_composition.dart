import 'package:flutter/foundation.dart';

class StoreComposition<String, double> {
  final String imagePath;
  final String storeAlias;
  final double score;
  final String? commentId;
  final String category;
  final String address;
  final double storeId;
  StoreComposition(
      {required this.imagePath,
      required this.storeAlias,
      required this.score,
      required this.commentId,
      required this.category,
      required this.address,
      required this.storeId});

  factory StoreComposition.fromJson(Map<String, dynamic> json) {
    return StoreComposition(
      imagePath: json["imagePath"] as String,
      storeAlias: json["storeAlias"] as String,
      score: json["score"] as double,
      commentId: json["commentId"] as String?,
      category: json["category"] as String,
      address: json["address"] as String,
      storeId: json["storeId"] as double,
    );
  }
}
