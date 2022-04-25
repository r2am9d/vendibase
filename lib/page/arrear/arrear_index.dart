import 'dart:io';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:vendibase/router/app_router.dart';
import 'package:vendibase/database/app_database.dart';
import 'package:vendibase/provider/app_database_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ArrearIndex extends StatefulWidget {
  const ArrearIndex({Key? key}) : super(key: key);

  @override
  State<ArrearIndex> createState() => _ArrearIndexState();
}

class _ArrearIndexState extends State<ArrearIndex> {
  String _searchTerm = '';
  bool _isSearching = false;

  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _db = context.read<AppDatabaseProvider>().database;
    final _navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                autofocus: true,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Search arrears',
                ),
                onSubmitted: (term) {
                  setState(() {
                    _searchTerm = term;
                  });

                  debugPrint(term);
                },
              )
            : const Text('Arrears'),
        actions: [
          _iconButton(
            icon: _isSearching ? Icons.clear : Icons.search,
            color: AppColor.black,
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchTerm = '';
                }
              });
            },
          ),
        ],
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          setState(() {
            if (notification.direction == ScrollDirection.forward) {
              if (!_isVisible) _isVisible = true;
            } else if (notification.direction == ScrollDirection.reverse) {
              if (_isVisible) _isVisible = false;
            }
          });

          return true;
        },
        child: StreamBuilder<List<ArrearWithDetails>>(
          stream: _db.arrearsDao.watchArrears(_searchTerm),
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
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              _widget = Center(child: Text('No available data.'));
            } else {
              List<ArrearWithDetails> _arrears = snapshot.data!;

              _widget = Scrollbar(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _arrears.length,
                  itemBuilder: (context, index) {
                    return _buildListTile(
                      _arrears[index],
                      _db,
                      _theme,
                      context,
                      _navigator,
                    );
                  },
                  separatorBuilder: (context, index) => _sizedBox(height: 16.0),
                ),
              );
            }

            return _widget;
          },
        ),
      ),
      floatingActionButton: _isVisible
          ? FloatingActionButton(
              tooltip: 'Add arrear',
              heroTag: 'arrear-index-fab',
              child: const FaIcon(FontAwesomeIcons.moneyBill),
              onPressed: () {
                _navigator.pushNamed(AppRouter.arrearCreate);
              },
            )
          : null,
    );
  }

  Widget _buildListTile(
    ArrearWithDetails arrear,
    AppDatabase db,
    ThemeData theme,
    BuildContext context,
    NavigatorState navigator,
  ) {
    final photo = arrear.personPhoto;
    final image = photo.contains('asset')
        ? AssetImage(photo)
        : FileImage(File(photo)) as ImageProvider;

    final _df = DateFormat("d MMM y", "en_PH");
    final _nf = NumberFormat("###,###.##", "en_US");
    final _eic = d.EnumIndexConverter<Status>(Status.values);
    final _due = arrear.due != null ? _df.format(arrear.due!) : '-';

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        onTap: () {
          navigator.pushNamed(
            AppRouter.arrearView,
            arguments: {'id': arrear.id},
          );
        },
        leading: CircleAvatar(
          radius: 30.0,
          backgroundImage: image,
          backgroundColor: AppColor.red,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '₱ ${_nf.format(arrear.activeAmount)}',
              style: theme.textTheme.bodyText1?.copyWith(
                color: AppColor.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            _sizedBox(width: 4.0),
            Text('|'),
            _sizedBox(width: 4.0),
            Expanded(
              child: Text(
                _due,
                style: theme.textTheme.bodyText2?.copyWith(
                  color: AppColor.black,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              arrear.personName,
              style: theme.textTheme.bodyText1?.copyWith(
                color: AppColor.black.withOpacity(.5),
                fontWeight: FontWeight.bold,
              ),
            ),
            _sizedBox(height: 8.0),
            _buildChip(theme, _eic.mapToDart(arrear.status)!)
          ],
        ),
        trailing: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(right: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.cubes,
                color: AppColor.red,
              ),
              _sizedBox(width: 16.0),
              Text(
                _nf.format(arrear.totalPurchase),
                style: theme.textTheme.headline5?.copyWith(
                  color: AppColor.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
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
        style: theme.textTheme.bodyText2?.copyWith(
          color: _textColor,
        ),
      ),
    );
  }

  Widget _sizedBox({double? height, double? width}) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  Widget _iconButton({
    required IconData icon,
    Color? color = const Color(0xFF930E4D),
    required void Function()? onPressed,
  }) {
    return IconButton(
      icon: Icon(icon),
      color: color,
      onPressed: onPressed,
    );
  }
}
