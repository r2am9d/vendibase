import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:vendibase/router/app_router.dart';
import 'package:vendibase/database/app_database.dart';
import 'package:vendibase/provider/app_database_provider.dart';

class CategoryIndex extends StatefulWidget {
  const CategoryIndex({Key? key}) : super(key: key);

  @override
  _CategoryIndexState createState() => _CategoryIndexState();
}

class _CategoryIndexState extends State<CategoryIndex> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _db = context.watch<AppDatabaseProvider>().database;
    final _navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
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
        child: StreamBuilder<List<Category>>(
          stream: _db.categoriesDao.watchCategories(),
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
              List<Category> _categories = snapshot.data!;

              _widget = Scrollbar(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    return _buildListTile(
                      _categories[index],
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
              tooltip: 'Add category',
              heroTag: 'category-index-fab',
              child: const Icon(Icons.add),
              onPressed: () {
                _navigator.pushNamed(AppRouter.categoryCreate);
              },
            )
          : null,
    );
  }

  Widget _buildListTile(
    Category category,
    AppDatabase db,
    ThemeData theme,
    BuildContext context,
    NavigatorState navigator,
  ) {
    return Card(
      child: ListTile(
        onTap: () {
          navigator.pushNamed(
            AppRouter.categoryView,
            arguments: {'id': category.id},
          );
        },
        title: Text(category.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _iconButton(
              icon: Icons.edit,
              onPressed: () {
                navigator.pushNamed(
                  AppRouter.categoryUpdate,
                  arguments: {'id': category.id},
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
                        'Are you sure you want\nto delete "${category.name}"?',
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
                          await db.categoriesDao.omit(
                            CategoriesCompanion(id: d.Value(category.id)),
                          );

                          navigator.popUntil((route) {
                            return route.settings.name ==
                                AppRouter.categoryIndex;
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
