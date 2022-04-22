import 'package:rxdart/rxdart.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vendibase/database/app_database.dart';

void main() {

  test('Check if composed of streams', () async {
    final data = db.dashboardDao.getData('2022');
    expect(data is CombineLatestStream, true);
  });

}
