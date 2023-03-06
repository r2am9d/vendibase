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
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ArrearIndex extends StatefulWidget {
  const ArrearIndex({Key? key}) : super(key: key);

  @override
  State<ArrearIndex> createState() => _ArrearIndexState();
}

class _ArrearIndexState extends State<ArrearIndex> {
  String _searchTerm = '';
  Map<String, dynamic> _filters = {};

  bool _isSearching = false;
  bool _isVisible = true;

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _db = context.watch<AppDatabaseProvider>().database;
    final _navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          _iconButton(
            icon: Icons.filter_alt,
            color: AppColor.black,
            onPressed: () async {
              await _showFilterDialog(
                db: _db,
                theme: _theme,
                context: context,
                formKey: _formKey,
              );
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
          stream: _db.arrearsDao.watchArrears(_searchTerm, _filters),
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

              _widget = ListView.separated(
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
              );
            }

            return _widget;
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_filters.length >= 1)
            FloatingActionButton(
              tooltip: 'Remove filter',
              heroTag: 'product-index-filter-fab',
              child: const Icon(Icons.filter_alt_off),
              backgroundColor: AppColor.red,
              onPressed: () {
                setState(() {
                  _filters = {};
                });
              },
            ),
          if (_isVisible) ...[
            _sizedBox(height: 8.0),
            FloatingActionButton(
              tooltip: 'Add arrear',
              heroTag: 'arrear-index-fab',
              child: const FaIcon(FontAwesomeIcons.moneyBill),
              onPressed: () async {
                await _navigator.pushNamed(AppRouter.arrearCreate);
              },
            )
          ]
        ],
      ),
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
        onTap: () async {
          await navigator.pushNamed(
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
              style: theme.textTheme.bodyLarge?.copyWith(
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
                style: theme.textTheme.bodyMedium?.copyWith(
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
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColor.black.withOpacity(.5),
                fontWeight: FontWeight.bold,
              ),
            ),
            _sizedBox(height: 8.0),
            _buildChip(theme, _eic.fromSql(arrear.status))
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
                style: theme.textTheme.headlineSmall?.copyWith(
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

  Future _showFilterDialog({
    required AppDatabase db,
    required ThemeData theme,
    required BuildContext context,
    required GlobalKey<FormBuilderState> formKey,
  }) async {
    final _mQ = MediaQuery.of(context);
    final _navigator = Navigator.of(context);

    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.white,
        title: Text(
          'Filters',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColor.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Scrollbar(
          child: SingleChildScrollView(
            child: SizedBox(
              width: _mQ.size.width,
              child: FormBuilder(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: StreamBuilder<double>(
                  stream: db.arrearsDao.watchMaxActiveAmount(),
                  builder: (context, snapshot) {
                    var _maxActiveAmount = snapshot.data;

                    if (_maxActiveAmount != null) {
                      _maxActiveAmount =
                          (_maxActiveAmount == 0.0) ? 1.0 : _maxActiveAmount;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sizedBox(height: 16.0),
                          FormBuilderRangeSlider(
                            min: 1,
                            enabled: (_maxActiveAmount == 0.0) ? false : true,
                            max: _maxActiveAmount,
                            name: 'priceRange',
                            labels: RangeLabels('1', '${_maxActiveAmount}'),
                            initialValue: RangeValues(1, _maxActiveAmount),
                            decoration: _inputDecoration('Price Range (PHP)'),
                            numberFormat: NumberFormat("###,###.##", "en_US"),
                            textStyle: TextStyle(
                              fontSize: 12.0,
                              color: Colors.black45,
                            ),
                          ),
                          _sizedBox(height: 16.0),
                          FormBuilderDropdown(
                            name: 'status',
                            // allowClear: true,
                            items: [
                              {'id': 0, 'name': 'Unpaid'},
                              {'id': 1, 'name': 'Paid'},
                            ].map((Map<String, dynamic> _status) {
                              return DropdownMenuItem(
                                value: _status['id'],
                                child: Text(_status['name']),
                              );
                            }).toList(),
                            decoration: _inputDecoration('Status'),
                          ),
                          _sizedBox(height: 16.0),
                          FormBuilderDateTimePicker(
                            name: 'due',
                            inputType: InputType.date,
                            decoration: _inputDecoration('Due'),
                          ),
                        ],
                      );
                    }

                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            alignment: Alignment.center,
            child: _elevatedButton(
              text: 'Filter',
              icon: Icons.filter_alt,
              onPressed: () async {
                final _fState = formKey.currentState!;
                if (_fState.validate()) {
                  final _priceRange =
                      _fState.fields['priceRange']!.value as RangeValues;
                  final _status = _fState.fields['status']?.value ?? null;
                  final _due = _fState.fields['due']?.value ?? null;

                  setState(() {
                    _filters = {
                      'priceRange': _priceRange,
                      'status': _status,
                      'due': _due,
                    };
                  });

                  _navigator.pop();
                }
              },
            ),
          )
        ],
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
        style: theme.textTheme.bodyMedium?.copyWith(
          color: _textColor,
        ),
      ),
    );
  }

  Widget _elevatedButton({
    required String text,
    required IconData icon,
    Color? color,
    void Function()? onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          _sizedBox(width: 8),
          Icon(icon, size: 16),
        ],
      ),
      onPressed: onPressed,
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

  InputDecoration _inputDecoration(
    String placeholder, [
    bool withPrefix = false,
  ]) {
    final _prefix = withPrefix ? '₱ ' : null;

    return InputDecoration(
      prefixText: _prefix,
      labelText: placeholder,
      alignLabelWithHint: true,
      fillColor: AppColor.white,
      border: const OutlineInputBorder(),
    );
  }
}
