import 'package:flutter/foundation.dart';

class MenuByStore<double, String> {
  final double menuId;
  final String menuAlias;
  final double storeId;
  final double cost;
  final double choiceCount;
  MenuByStore(
      this.menuId, this.menuAlias, this.storeId, this.cost, this.choiceCount);
}
