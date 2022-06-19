import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:vendibase/utils/app_debug.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vendibase/utils/app_notification.dart';

import 'package:vendibase/home.dart';
import 'package:vendibase/page/dashboard/dashboard_index.dart';
import 'package:vendibase/page/error/error_index.dart';
import 'package:vendibase/page/onboard/onboard_index.dart';

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

enum RouteType { Primary, Secondary }

enum PageType { Index, View, Create, Update, Delete }

class AppRouter {
  // Named Routes
  static const home = '/';
  static const dashboardIndex = '/dashboard-index';
  static const errorIndex = '/error-index';
  static const onboardIndex = '/onboard-index';

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
    var args = settings.arguments;

    switch (settings.name) {
      // Home Route
      case home:
        return _pageTransition(
          child: kReleaseMode ? const Home() : const AppDebug(home: Home()),
          pageType: PageType.Index,
          settings: settings,
          routeType: RouteType.Primary,
        );

      // Dashboard Route
      case dashboardIndex:
        return _pageTransition(
          child: const DashboardIndex(),
          pageType: PageType.Index,
          settings: settings,
          routeType: RouteType.Primary,
        );

      // Error Route
      case errorIndex:
        return _pageTransition(
          child: const ErrorIndex(),
          pageType: PageType.Index,
          settings: settings,
          routeType: RouteType.Primary,
        );

      // Onboard Route
      case onboardIndex:
        return _pageTransition(
          child: const OnboardIndex(),
          pageType: PageType.Index,
          settings: settings,
          routeType: RouteType.Primary,
        );

      // Backup Route
      case backupIndex:
        return _pageTransition(
          child: const BackupIndex(),
          pageType: PageType.Index,
          settings: settings,
          routeType: RouteType.Secondary,
        );

      // Earning Route
      case earningIndex:
        return _pageTransition(
          child: const EarningIndex(),
          pageType: PageType.Index,
          settings: settings,
          routeType: RouteType.Secondary,
        );

      // Codelab Route
      case codelabIndex:
        return _pageTransition(
          child: const CodelabIndex(),
          pageType: PageType.Index,
          settings: settings,
          routeType: RouteType.Secondary,
        );

      // Product Routes
      case productIndex:
        return _pageTransition(
          child: const ProductIndex(),
          pageType: PageType.Index,
          settings: settings,
          routeType: RouteType.Primary,
        );
      case productCreate:
        return _pageTransition(
          child: const ProductCreate(),
          pageType: PageType.Create,
          settings: settings,
          routeType: RouteType.Primary,
        );
      case productView:
        return _pageTransition(
          child: ProductView(args: args),
          pageType: PageType.View,
          settings: settings,
          routeType: RouteType.Primary,
        );
      case productUpdate:
        return _pageTransition(
          child: ProductUpdate(args: args),
          pageType: PageType.Update,
          settings: settings,
          routeType: RouteType.Primary,
        );

      // Arrear Routes
      case arrearIndex:
        return _pageTransition(
          child: const ArrearIndex(),
          pageType: PageType.Index,
          settings: settings,
          routeType: RouteType.Primary,
        );
      case arrearCreate:
        return _pageTransition(
          child: const ArrearCreate(),
          pageType: PageType.Create,
          settings: settings,
          routeType: RouteType.Primary,
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

        return _pageTransition(
          child: ArrearView(args: args),
          pageType: PageType.View,
          settings: settings,
          routeType: RouteType.Primary,
        );
      case arrearUpdate:
        return _pageTransition(
          child: ArrearUpdate(args: args),
          pageType: PageType.Update,
          settings: settings,
          routeType: RouteType.Primary,
        );

      // Unit Routes
      case unitIndex:
        return _pageTransition(
          child: const UnitIndex(),
          pageType: PageType.Index,
          settings: settings,
          routeType: RouteType.Secondary,
        );
      case unitCreate:
        return _pageTransition(
          child: const UnitCreate(),
          pageType: PageType.Create,
          settings: settings,
          routeType: RouteType.Secondary,
        );
      case unitView:
        return _pageTransition(
          child: UnitView(args: args),
          pageType: PageType.View,
          settings: settings,
          routeType: RouteType.Secondary,
        );
      case unitUpdate:
        return _pageTransition(
          child: UnitUpdate(args: args),
          pageType: PageType.Update,
          settings: settings,
          routeType: RouteType.Secondary,
        );

      // Person Routes
      case personIndex:
        return _pageTransition(
          child: const PersonIndex(),
          pageType: PageType.Index,
          settings: settings,
          routeType: RouteType.Secondary,
        );
      case personCreate:
        return _pageTransition(
          child: const PersonCreate(),
          pageType: PageType.Create,
          settings: settings,
          routeType: RouteType.Secondary,
        );
      case personView:
        return _pageTransition(
          child: PersonView(args: args),
          pageType: PageType.View,
          settings: settings,
          routeType: RouteType.Secondary,
        );
      case personUpdate:
        return _pageTransition(
          child: PersonUpdate(args: args),
          pageType: PageType.Update,
          settings: settings,
          routeType: RouteType.Secondary,
        );

      // Category Routes
      case categoryIndex:
        return _pageTransition(
          child: const CategoryIndex(),
          pageType: PageType.Index,
          settings: settings,
          routeType: RouteType.Secondary,
        );
      case categoryCreate:
        return _pageTransition(
          child: const CategoryCreate(),
          pageType: PageType.Create,
          settings: settings,
          routeType: RouteType.Secondary,
        );
      case categoryView:
        return _pageTransition(
          child: CategoryView(args: args),
          pageType: PageType.View,
          settings: settings,
          routeType: RouteType.Secondary,
        );
      case categoryUpdate:
        return _pageTransition(
          child: CategoryUpdate(args: args),
          pageType: PageType.Update,
          settings: settings,
          routeType: RouteType.Secondary,
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
    required RouteType routeType,
  }) {
    final _curve = Curves.fastLinearToSlowEaseIn;
    final _duration = Duration(milliseconds: 175);

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
          alignment: Alignment.center,
          type: routeType == RouteType.Primary
              ? PageTransitionType.scale
              : PageTransitionType.leftToRightWithFade,
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
