

import 'dart:convert';

import 'package:flutter/services.dart';

class TablesDatabase {
  TablesDatabase._();
  static late TablesDatabase instance = TablesDatabase._();

  Map? _themesJsonMap;
  Future<Map> get themesJson async {
    if(_themesJsonMap != null) return _themesJsonMap!;

    final grStr = await rootBundle.loadString("assets/example-data/themes.json");
    _themesJsonMap = (jsonDecode(grStr) as Map)["themes"];
    return _themesJsonMap!;
  }

}