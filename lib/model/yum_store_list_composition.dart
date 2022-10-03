import 'package:flutter/foundation.dart';

class StoreComposition<String, double, List> {
  final String imagePath;
  final String storeAlias;
  final double score;
  final String? commentId;
  final List category;
  final String address;
  final double storeId;
  final double mapX;
  final double mapY;
  StoreComposition({
    required this.imagePath,
    required this.storeAlias,
    required this.score,
    required this.commentId,
    required this.category,
    required this.address,
    required this.storeId,
    required this.mapX,
    required this.mapY,
  });

  factory StoreComposition.fromJson(Map<String, dynamic> json) {
    return StoreComposition(
      imagePath: json["imagePath"] as String,
      storeAlias: json["storeAlias"] as String,
      score: json["score"] as double,
      commentId: json["commentId"] as String?,
      category: json["category"].split('>') as List,
      address: json["address"] as String,
      storeId: json["storeId"] as double,
      mapX: json["mapX"] as double,
      mapY: json["mapY"] as double,
    );
  }
}
