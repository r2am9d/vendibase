import 'dart:io';
import 'dart:convert';
import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:vendibase/router/app_router.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:vendibase/database/app_database.dart';
import 'package:vendibase/provider/app_database_provider.dart';

class PersonView extends StatelessWidget {
  final args;
  const PersonView({
    Key? key,
    this.args,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _db = context.read<AppDatabaseProvider>().database;
    final _navigator = Navigator.of(context);
    final _args = jsonDecode(jsonEncode(args));

    return Scaffold(
      appBar: AppBar(
        title: Text('Person View'),
      ),
      body: StreamBuilder<Person>(
        stream: _db.personsDao.one(_args['id']),
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
            Person _person = snapshot.data!;
            final _photo = _person.photo;
            final _image = _photo.contains('asset')
                ? AssetImage(_photo)
                : FileImage(File(_photo)) as ImageProvider;

            _widget = Scrollbar(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 115.0,
                          backgroundColor: AppColor.red,
                          child: CircleAvatar(
                            radius: 105.0,
                            backgroundColor: AppColor.white,
                            child: CircleAvatar(
                              radius: 95.0,
                              backgroundColor: AppColor.red,
                              backgroundImage: _image,
                            ),
                          ),
                        ),
                      ],
                    ),
                    _sizedBox(height: 16),
                    Text(
                      'Name: ${_person.name}',
                      style: _theme.textTheme.headline6,
                    ),
                    _sizedBox(height: 16),
                    Text(
                      'Contact No: ${_person.contactNo ?? ''}',
                      style: _theme.textTheme.headline6,
                    ),
                    _sizedBox(height: 16),
                    Text(
                      'Remarks: ${_person.remarks ?? ''}',
                      style: _theme.textTheme.headline6,
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
              onPressed: () {
                _navigator.pushNamed(
                  AppRouter.personUpdate,
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
                    title: const Text('Confirm'),
                    backgroundColor: AppColor.red,
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
                          _navigator.pop();
                        },
                      ),
                      _outlineButton(
                        text: 'Delete',
                        color: AppColor.white,
                        onPressed: () async {
                          // Delete photo
                          final _person =
                              await _db.personsDao.getPerson(_args['id']);
                          await GallerySaver.deleteImage(_person.photo);

                          await _db.personsDao
                              .omit(PersonsCompanion(id: d.Value(_args['id'])));

                          _navigator.popUntil((route) {
                            return route.settings.name == AppRouter.personIndex;
                          });
                        },
                      ),
                    ],
                    actionsPadding: const EdgeInsets.all(8),
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
      style: ElevatedButton.styleFrom(primary: color),
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
