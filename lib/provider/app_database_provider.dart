import 'package:flutter/material.dart';
import 'package:vendibase/database/app_database.dart';

class AppDatabaseProvider with ChangeNotifier {
  AppDatabase database;

  AppDatabaseProvider() : database = AppDatabase();

  void reOpen() {
    database = AppDatabase();
    notifyListeners();
  }

  void close() async {
    await database.close();
    notifyListeners();
  }
}
