import 'dart:io';
import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:vendibase/router/app_router.dart';
import 'package:vendibase/database/app_database.dart';
import 'package:vendibase/provider/app_database_provider.dart';

class PersonIndex extends StatefulWidget {
  const PersonIndex({Key? key}) : super(key: key);

  @override
  State<PersonIndex> createState() => _PersonIndexState();
}

class _PersonIndexState extends State<PersonIndex> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _db = context.read<AppDatabaseProvider>().database;
    final _navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Persons'),
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
        child: StreamBuilder<List<Person>>(
          stream: _db.personsDao.all(),
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
              List<Person> _persons = snapshot.data!;

              _widget = Scrollbar(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _persons.length,
                  itemBuilder: (context, index) {
                    return _buildListTile(
                      _persons[index],
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
              tooltip: 'Add person',
              child: const Icon(Icons.add),
              onPressed: () {
                _navigator.pushNamed(AppRouter.personCreate);
              },
            )
          : null,
    );
  }

  Widget _buildListTile(
    Person person,
    AppDatabase db,
    ThemeData theme,
    BuildContext context,
    NavigatorState navigator,
  ) {
    final photo = person.photo;
    final image = photo.contains('asset')
        ? AssetImage(photo)
        : FileImage(File(photo)) as ImageProvider;

    return Card(
      child: ListTile(
        onTap: () {
          navigator.pushNamed(
            AppRouter.personView,
            arguments: {'id': person.id},
          );
        },
        leading: CircleAvatar(
          backgroundImage: image,
          backgroundColor: AppColor.red,
        ),
        title: Text(
          person.name,
          style: theme.textTheme.bodyText1,
        ),
        subtitle: Text(
          person.contactNo ?? '',
          style: theme.textTheme.bodyText2,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _iconButton(
              icon: Icons.edit,
              onPressed: () {
                navigator.pushNamed(
                  AppRouter.categoryUpdate,
                  arguments: {'id': person.id},
                );
              },
            ),
            _iconButton(
              icon: Icons.delete,
              color: AppColor.black,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: AppColor.red,
                    title: const Text('Confirm'),
                    content: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'Are you sure you want\nto delete "${person.name}"?',
                      ),
                    ),
                    actions: [
                      _outlineButton(
                        text: 'Cancel',
                        onPressed: () {
                          navigator.pop(context);
                        },
                      ),
                      _outlineButton(
                        text: 'Delete',
                        onPressed: () async {
                          // Delete photo
                          await GallerySaver.deleteImage(person.photo);

                          await db.personsDao.omit(
                            PersonsCompanion(id: d.Value(person.id)),
                          );

                          navigator.popUntil((route) {
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
      ),
    );
  }

  Widget _outlineButton({
    required String text,
    required void Function()? onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: AppColor.white)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppColor.white),
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
