import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:vendibase/utils/app_debug.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendibase/utils/app_notification.dart';

import 'package:vendibase/home.dart';
import 'package:vendibase/page/dashboard/dashboard_index.dart';
import 'package:vendibase/page/backup/backup_index.dart';
import 'package:vendibase/page/earning/earning_index.dart';
import 'package:vendibase/page/codelab/codelab_index.dart';
import 'package:vendibase/page/error/error_index.dart';

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

enum PageType { Index, View, Create, Update, Delete }

class AppRouter {
  // Named Routes
  static const home = '/';

  static const dashboardIndex = '/dashboard-index';
  static const backupIndex = '/backup-index';
  static const earningIndex = '/earning-index';
  static const codelabIndex = '/codelab-index';
  static const errorIndex = '/error-index';

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
    var args = settings.arguments;

    switch (settings.name) {
      // Home Route
      case home:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) =>
              kReleaseMode ? const Home() : const AppDebug(home: Home()),
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

      // Error Route
      case errorIndex:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const ErrorIndex(),
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
        final payload = AppNotification.selectedPayload;
        if (payload != null && payload.isNotEmpty) {
          final _args =
              payload.split('/').where((i) => i.length >= 1).toList().asMap();
          args = {'id': int.parse(_args[1]!)};

          // Reset
          AppNotification.resetPayload();
        }

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
        return _pageTransition(
          child: UnitIndex(),
          pageType: PageType.Index,
          settings: settings,
        );
      case unitCreate:
        return _pageTransition(
          child: UnitCreate(),
          pageType: PageType.Create,
          settings: settings,
        );
      case unitView:
        return _pageTransition(
          child: UnitView(args: args),
          pageType: PageType.View,
          settings: settings,
        );
      case unitUpdate:
        return _pageTransition(
          child: UnitUpdate(args: args),
          pageType: PageType.Update,
          settings: settings,
        );

      // Person Routes
      case personIndex:
        return _pageTransition(
          child: PersonIndex(),
          pageType: PageType.Index,
          settings: settings,
        );
      case personCreate:
        return _pageTransition(
          child: PersonCreate(),
          pageType: PageType.Create,
          settings: settings,
        );
      case personView:
        return _pageTransition(
          child: PersonView(args: args),
          pageType: PageType.View,
          settings: settings,
        );
      case personUpdate:
        return _pageTransition(
          child: PersonUpdate(args: args),
          pageType: PageType.Update,
          settings: settings,
        );

      // Category Routes
      case categoryIndex:
        return _pageTransition(
          child: CategoryIndex(),
          pageType: PageType.Index,
          settings: settings,
        );
      case categoryCreate:
        return _pageTransition(
          child: CategoryCreate(),
          pageType: PageType.Create,
          settings: settings,
        );
      case categoryView:
        return _pageTransition(
          child: CategoryView(args: args),
          pageType: PageType.View,
          settings: settings,
        );
      case categoryUpdate:
        return _pageTransition(
          child: CategoryUpdate(args: args),
          pageType: PageType.Update,
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => UndefinedView(name: settings.name ?? 'No Name'),
        );
    }
  }

  static PageTransition _pageTransition({
    required Widget child,
    required PageType pageType,
    required RouteSettings settings,
  }) {
    final _curve = Curves.easeInOut;
    final _duration = Duration(milliseconds: 100);

    var _transition;
    switch (pageType) {
      case PageType.Index:
        _transition = PageTransition(
          child: child,
          curve: _curve,
          settings: settings,
          duration: _duration,
          reverseDuration: _duration,
          type: PageTransitionType.fade,
        );
        break;
      case PageType.View:
        _transition = PageTransition(
          child: child,
          curve: _curve,
          settings: settings,
          duration: _duration,
          reverseDuration: _duration,
          type: PageTransitionType.leftToRightWithFade,
        );
        break;
      case PageType.Create:
      case PageType.Update:
        _transition = PageTransition(
          child: child,
          curve: _curve,
          settings: settings,
          duration: _duration,
          reverseDuration: _duration,
          type: PageTransitionType.bottomToTop,
        );
        break;
      case PageType.Delete:
        // TODO: Handle this case.
        break;
    }

    return _transition;
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
