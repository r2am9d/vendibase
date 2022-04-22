import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vendibase/database/app_database.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  test('Check if composed of streams', () {
    final data = db.dashboardDao.getData('2022');
    expect(data is CombineLatestStream, true);
  });

}
