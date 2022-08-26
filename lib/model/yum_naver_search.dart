import 'package:flutter/foundation.dart';

class YumNaverSearch<double> {
  final String title;
  final String link;
  final String category;
  final String description;
  final String telephone;
  final String address;
  final String roadAddress;
  final String mapx;
  final String mapy;
  YumNaverSearch({
    required this.title,
    required this.link,
    required this.category,
    required this.description,
    required this.telephone,
    required this.address,
    required this.roadAddress,
    required this.mapx,
    required this.mapy,
  });
  factory YumNaverSearch.fromJson(Map<String, dynamic> json) {
    return YumNaverSearch(
      title: json["title"] as String,
      link: json["link"] as String,
      category: json["category"] as String,
      description: json["description"] as String,
      telephone: json["telephone"] as String,
      address: json["address"] as String,
      roadAddress: json["roadAddress"] as String,
      mapx: json["mapx"] as String,
      mapy: json["mapy"] as String,
    );
  }
}
