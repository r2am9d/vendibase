import 'package:flutter/material.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
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
  var _index = 0;
  final _page = [
    const DashboardIndex(),
    const ProductIndex(),
    const ArrearIndex(),
  ];

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Scaffold(
      body: _page[_index],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: _theme.dividerColor),
          ),
        ),
        child: SalomonBottomBar(
          currentIndex: _index,
          selectedItemColor: AppColor.red,
          onTap: (i) => setState(() => _index = i),
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
        ),
      ),
    );
  }
}
