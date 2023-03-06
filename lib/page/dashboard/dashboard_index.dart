import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:vendibase/database/app_database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vendibase/provider/app_database_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardIndex extends StatefulWidget {
  const DashboardIndex({Key? key}) : super(key: key);

  @override
  State<DashboardIndex> createState() => _DashboardIndexState();
}

class _DashboardIndexState extends State<DashboardIndex> {
  final _year = DateTime.now().year.toString();

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _db = context.watch<AppDatabaseProvider>().database;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _popupMenu(context, Icons.more_vert),
          )
        ],
      ),
      body: StreamBuilder<DashboardData>(
        stream: _db.dashboardDao.getData('$_year'),
        builder: (context, snapshot) {
          Widget _widget = Center(child: CircularProgressIndicator());

          if (snapshot.hasError) {
            _widget = Scrollbar(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(snapshot.error.toString()),
                    _sizedBox(height: 16.0),
                    Text(snapshot.stackTrace.toString()),
                  ],
                ),
              ),
            );
          } else if (snapshot.data == null) {
            _widget = Center(child: Text('No available data.'));
          } else {
            DashboardData _dashboardData = snapshot.data!;
            final _nf = NumberFormat("###,###.##", "en_PH");

            _widget = SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SfCartesianChart(
                    title: ChartTitle(
                      text: 'Earnings [$_year]',
                      alignment: ChartAlignment.near,
                      textStyle: _theme.textTheme.titleLarge?.copyWith(
                        color: AppColor.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    primaryXAxis: CategoryAxis(),
                    legend: Legend(isVisible: true),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <ChartSeries<EarningWithDetails, String>>[
                      LineSeries<EarningWithDetails, String>(
                        name:
                            '₱ ${_nf.format(_dashboardData.totalEarnings)}\nTotal Earnings',
                        dataSource: _dashboardData.earnings,
                        xValueMapper: (EarningWithDetails earning, _) =>
                            earning.month,
                        yValueMapper: (EarningWithDetails earning, _) =>
                            earning.amount,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                      ),
                    ],
                  ),
                  _sizedBox(height: 32.0),
                  Text(
                    'Total Products',
                    style: _theme.textTheme.titleLarge?.copyWith(
                      color: AppColor.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.boxesStacked,
                          color: AppColor.red,
                          size: 42,
                        ),
                        _sizedBox(width: 16.0),
                        Text(
                          _nf.format(_dashboardData.totalProducts),
                          style: _theme.textTheme.displaySmall?.copyWith(
                            color: AppColor.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _sizedBox(height: 32.0),
                  Text(
                    'Total Arrears',
                    style: _theme.textTheme.titleLarge?.copyWith(
                      color: AppColor.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.moneyBill,
                                  color: AppColor.green,
                                  size: 42,
                                ),
                                _sizedBox(width: 16.0),
                                Text(
                                  _nf.format(_dashboardData.totalPaidArrears),
                                  style:
                                      _theme.textTheme.displaySmall?.copyWith(
                                    color: AppColor.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            _sizedBox(height: 16.0),
                            _buildChip(_theme, Status.paid),
                          ],
                        ),
                        _sizedBox(width: 32.0),
                        Text(
                          'VS',
                          style: _theme.textTheme.headlineSmall?.copyWith(
                            color: AppColor.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _sizedBox(width: 32.0),
                        Column(
                          children: [
                            Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.moneyBill,
                                  color: AppColor.red1,
                                  size: 42,
                                ),
                                _sizedBox(width: 16.0),
                                Text(
                                  _nf.format(_dashboardData.totalUnpaidArrears),
                                  style:
                                      _theme.textTheme.displaySmall?.copyWith(
                                    color: AppColor.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            _sizedBox(height: 16.0),
                            _buildChip(_theme, Status.unpaid),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return _widget;
        },
      ),
    );
  }

  Widget _popupMenu(BuildContext context, IconData icon) {
    final _navigator = Navigator.of(context);

    return PopupMenuButton<dynamic>(
      child: Icon(icon),
      itemBuilder: (_) => [
        _popupMenuItem(
          icon: Icons.emergency,
          text: 'Unit',
          onTap: () => Future(() => _navigator.pushNamed('/unit-index')),
        ),
        _popupMenuItem(
          icon: Icons.person,
          text: 'Person',
          onTap: () => Future(() => _navigator.pushNamed('/person-index')),
        ),
        _popupMenuItem(
          icon: Icons.category,
          text: 'Category',
          onTap: () => Future(() => _navigator.pushNamed('/category-index')),
        ),
        _popupMenuItem(
          icon: Icons.attach_money,
          text: 'Earning',
          onTap: () => Future(() => _navigator.pushNamed('/earning-index')),
        ),
        _popupMenuItem(
          icon: Icons.storage,
          text: 'Backup',
          onTap: () => Future(() => _navigator.pushNamed('/backup-index')),
        ),
        if (!kReleaseMode) ...[
          _popupMenuItem(
            icon: Icons.science,
            text: 'Codelab',
            onTap: () => Future(() => _navigator.pushNamed('/codelab-index')),
          ),
          _popupMenuItem(
            icon: Icons.emergency,
            text: 'Onboard',
            onTap: () => Future(() => _navigator.pushNamed('/onboard-index')),
          ),
        ],
      ],
    );
  }

  PopupMenuItem<dynamic> _popupMenuItem({
    required IconData icon,
    required String text,
    void Function()? onTap,
    bool isFaIcon = false,
  }) {
    final _icon = isFaIcon
        ? FaIcon(icon, color: Colors.black, size: 24.0)
        : Icon(icon, color: Colors.black);

    return PopupMenuItem(
      child: Row(
        children: [
          _icon,
          _sizedBox(width: 8.0),
          Text(text),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _sizedBox({double? height, double? width}) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  Widget _buildChip(ThemeData theme, Status status) {
    var _text, _chipColor, _textColor;
    switch (status) {
      case Status.unpaid:
        _text = 'Unpaid';
        _chipColor = AppColor.red1;
        _textColor = AppColor.white;
        break;
      case Status.paid:
        _text = 'Paid';
        _chipColor = AppColor.green;
        _textColor = AppColor.white;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: _chipColor,
        borderRadius: BorderRadius.circular(40.0),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 24.0,
      ),
      child: Text(
        _text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: _textColor,
        ),
      ),
    );
  }
}
