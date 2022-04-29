import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:vendibase/home.dart';
import 'package:vendibase/page/dashboard/dashboard_index.dart';
import 'package:vendibase/page/backup/backup_index.dart';
import 'package:vendibase/page/earning/earning_index.dart';
import 'package:vendibase/page/codelab/codelab_index.dart';

import 'package:vendibase/page/product/product_index.dart';
import 'package:vendibase/page/product/product_create.dart';
import 'package:vendibase/page/product/product_view.dart';
import 'package:vendibase/page/product/product_update.dart';

import 'package:vendibase/page/arrear/arrear_index.dart';
import 'package:vendibase/page/arrear/arrear_create.dart';
import 'package:vendibase/page/arrear/arrear_view.dart';
import 'package:vendibase/page/arrear/arrear_update.dart';

import 'package:vendibase/page/unit/unit_index.dart';
import 'package:vendibase/page/unit/unit_create.dart';
import 'package:vendibase/page/unit/unit_view.dart';
import 'package:vendibase/page/unit/unit_update.dart';

import 'package:vendibase/page/person/person_index.dart';
import 'package:vendibase/page/person/person_create.dart';
import 'package:vendibase/page/person/person_view.dart';
import 'package:vendibase/page/person/person_update.dart';

import 'package:vendibase/page/category/category_index.dart';
import 'package:vendibase/page/category/category_create.dart';
import 'package:vendibase/page/category/category_view.dart';
import 'package:vendibase/page/category/category_update.dart';

class AppRouter {
  // Named Routes
  static const home = '/';

  static const dashboardIndex = '/dashboard-index';
  static const backupIndex = '/backup-index';
  static const earningIndex = '/earning-index';
  static const codelabIndex = '/codelab-index';

  static const productIndex = '/product-index';
  static const productCreate = '/product-create';
  static const productView = '/product-view';
  static const productUpdate = '/product-update';

  static const arrearIndex = '/arrear-index';
  static const arrearCreate = '/arrear-create';
  static const arrearView = '/arrear-view';
  static const arrearUpdate = '/arrear-update';

  static const unitIndex = '/unit-index';
  static const unitCreate = '/unit-create';
  static const unitView = '/unit-view';
  static const unitUpdate = '/unit-update';

  static const personIndex = '/person-index';
  static const personCreate = '/person-create';
  static const personView = '/person-view';
  static const personUpdate = '/person-update';

  static const categoryIndex = '/category-index';
  static const categoryCreate = '/category-create';
  static const categoryView = '/category-view';
  static const categoryUpdate = '/category-update';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // Home Route
      case home:
        final _args = jsonDecode(jsonEncode(args));
        final _index = int.tryParse(_args['id']) ?? 0;

        return MaterialPageRoute(
          settings: settings,
          builder: (context) => Home(index: _index),
        );

      // Dashboard Route
      case dashboardIndex:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const DashboardIndex(),
        );

      // Backup Route
      case backupIndex:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const BackupIndex(),
        );

      // Earning Route
      case earningIndex:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const EarningIndex(),
        );

      // Codelab Route
      case codelabIndex:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const CodelabIndex(),
        );

      // Product Routes
      case productIndex:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const ProductIndex(),
        );
      case productCreate:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const ProductCreate(),
        );
      case productView:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => ProductView(args: args),
        );
      case productUpdate:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => ProductUpdate(args: args),
        );

      // Arrear Routes
      case arrearIndex:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const ArrearIndex(),
        );
      case arrearCreate:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const ArrearCreate(),
        );
      case arrearView:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => ArrearView(args: args),
        );
      case arrearUpdate:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => ArrearUpdate(args: args),
        );

      // Unit Routes
      case unitIndex:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const UnitIndex(),
        );
      case unitCreate:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const UnitCreate(),
        );
      case unitView:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => UnitView(args: args),
        );
      case unitUpdate:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => UnitUpdate(args: args),
        );

      // Person Routes
      case personIndex:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const PersonIndex(),
        );
      case personCreate:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const PersonCreate(),
        );
      case personView:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => PersonView(args: args),
        );
      case personUpdate:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => PersonUpdate(args: args),
        );

      // Category Routes
      case categoryIndex:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const CategoryIndex(),
        );
      case categoryCreate:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const CategoryCreate(),
        );
      case categoryView:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => CategoryView(args: args),
        );
      case categoryUpdate:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => CategoryUpdate(args: args),
        );

      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => UndefinedView(name: settings.name ?? 'No Name'),
        );
    }
  }
}

class UndefinedView extends StatelessWidget {
  final String name;
  const UndefinedView({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Route for $name is not defined'),
      ),
    );
  }
}
