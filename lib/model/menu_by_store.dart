import 'package:flutter/foundation.dart';

class MenuByStore<double, String> {
  final double menuId;
  final String menuAlias;
  final double storeId;
  final double cost;
  final double choiceCount;
  MenuByStore({
    required this.menuId,
    required this.menuAlias,
    required this.storeId,
    required this.cost,
    required this.choiceCount,
  });

  factory MenuByStore.fromJson(Map<String, dynamic> json) {
    return MenuByStore(
      menuId: json["menuId"] as double,
      menuAlias: json["menuAlias"] as String,
      storeId: json["storeId"] as double,
      cost: json["cost"] as double,
      choiceCount: json["choiceCount"] as double,
    );
  }
}
