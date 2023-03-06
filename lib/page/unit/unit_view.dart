import 'dart:convert';
import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:vendibase/router/app_router.dart';
import 'package:vendibase/database/app_database.dart';
import 'package:vendibase/provider/app_database_provider.dart';

class UnitView extends StatelessWidget {
  final args;
  const UnitView({
    Key? key,
    this.args,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _db = context.watch<AppDatabaseProvider>().database;
    final _navigator = Navigator.of(context);
    final _args = jsonDecode(jsonEncode(args));

    return Scaffold(
      appBar: AppBar(
        title: Text('Unit View'),
      ),
      body: StreamBuilder<Unit>(
        stream: _db.unitsDao.one(_args['id']),
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
            Unit _unit = snapshot.data!;

            _widget = Scrollbar(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${_unit.name}',
                      style: _theme.textTheme.titleLarge,
                    ),
                    _sizedBox(height: 16),
                    Text(
                      'Amount: ${_unit.amount} pc/s',
                      style: _theme.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            );
          }

          return _widget;
        },
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _elevatedButton(
              text: 'Edit',
              icon: Icons.edit,
              onPressed: () async {
                await Navigator.pushNamed(
                  context,
                  AppRouter.unitUpdate,
                  arguments: {'id': _args['id']},
                );
              },
            ),
            _sizedBox(width: 32),
            _elevatedButton(
              text: 'Delete',
              icon: Icons.delete,
              color: Colors.black,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: AppColor.red,
                    title: const Text('Confirm'),
                    content: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Text(
                        'Are you sure you want\nto delete this?',
                      ),
                    ),
                    actions: [
                      _outlineButton(
                        text: 'Cancel',
                        color: AppColor.white,
                        onPressed: () {
                          _navigator.pop(context);
                        },
                      ),
                      _outlineButton(
                        text: 'Delete',
                        color: AppColor.white,
                        onPressed: () async {
                          await _db.unitsDao.omit(
                            UnitsCompanion(id: d.Value(_args['id'])),
                          );

                          _navigator.popUntil((route) {
                            return route.settings.name == AppRouter.unitIndex;
                          });
                        },
                      ),
                    ],
                    actionsPadding: const EdgeInsets.all(8.0),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _outlineButton({
    required String text,
    IconData? icon,
    required Color color,
    required void Function()? onPressed,
  }) {
    final _children = icon != null
        ? [
            Text(text, style: TextStyle(color: color)),
            _sizedBox(width: 8),
            Icon(icon, color: color)
          ]
        : [
            Text(text, style: TextStyle(color: color)),
          ];

    return OutlinedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _children,
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
      ),
    );
  }

  Widget _sizedBox({double? height, double? width}) {
    return SizedBox(
      height: height,
      width: width,
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
}
