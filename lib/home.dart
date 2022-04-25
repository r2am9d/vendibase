import 'package:faker/faker.dart';
import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:vendibase/database/app_database.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:vendibase/provider/app_database_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:vendibase/page/dashboard/dashboard_index.dart';
import 'package:vendibase/page/product/product_index.dart';
import 'package:vendibase/page/arrear/arrear_index.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int _index;
  late List<Widget> _pages;

  void _setupDb() async {
    final _db = context.read<AppDatabaseProvider>().database;

    // Product
    final _productId = await _db.productsDao.make(
      ProductsCompanion(
        photo: d.Value('assets/images/basket.png'),
        name: d.Value('Mantle of Intelligence'),
        remarks: d.Value(
          'A beautiful sapphire mantle worn by generations of queens',
        ),
      ),
    );

    await _db.productPurchasesDao.make(
      ProductPurchasesCompanion(
        productId: d.Value(_productId),
        cost: d.Value(100),
        quantity: d.Value(50),
      ),
    );

    await _db.productPricesDao.make(
      ProductPricesCompanion(
        productId: d.Value(_productId),
        retail: d.Value(140),
        isActive: d.Value(true),
      ),
    );

    // Person
    for (var i = 1; i <= 10; i++) {
      await _db.personsDao.make(PersonsCompanion(
        photo: d.Value('assets/images/man.png'),
        name: d.Value(faker.person.name()),
        contactNo: d.Value(faker.phoneNumber.us()),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    if (!kReleaseMode) _setupDb();

    _index = 0;
    _pages = [
      DashboardIndex(key: NavKeys.getKeys().elementAt(_index)),
      const SizedBox(),
      const SizedBox(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: _theme.dividerColor),
          ),
        ),
        child: SalomonBottomBar(
          currentIndex: _index,
          selectedItemColor: AppColor.red,
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.shopping_cart),
              title: const Text('Products'),
            ),
            SalomonBottomBarItem(
              icon: const FaIcon(FontAwesomeIcons.moneyBills),
              title: const Text('Arrears'),
            ),
          ],
          onTap: (index) {
            setState(() {
              if (_pages[index] is SizedBox) {
                debugPrint('Sized Box');
                if (index == 1) {
                  _pages[index] =
                      ProductIndex(key: NavKeys.getKeys().elementAt(index));
                } else {
                  _pages[index] =
                      ArrearIndex(key: NavKeys.getKeys().elementAt(index));
                }
              }

              _index = index;
            });
          },
        ),
      ),
    );
  }
}

class NavKeys {
  static final dashboard = GlobalKey(debugLabel: 'dashboard');
  static final product = GlobalKey(debugLabel: 'product');
  static final arrear = GlobalKey(debugLabel: 'arrear');

  static List<GlobalKey> getKeys() => [dashboard, product, arrear];
}
