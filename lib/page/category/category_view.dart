import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as d;
import 'package:provider/provider.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:vendibase/router/app_router.dart';
import 'package:vendibase/database/app_database.dart';
import 'package:vendibase/provider/app_database_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CategoryView extends StatefulWidget {
  final args;
  const CategoryView({
    Key? key,
    this.args,
  }) : super(key: key);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _db = context.watch<AppDatabaseProvider>().database;
    final _navigator = Navigator.of(context);
    final _args = jsonDecode(jsonEncode(widget.args));

    return Scaffold(
      appBar: AppBar(
        title: Text('Category View'),
      ),
      body: StreamBuilder<CategoryWithChildren>(
        stream: _db.categoriesDao.watchCategory(_args['id']),
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
            CategoryWithChildren _category = snapshot.data!;

            _widget = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${_category.name}',
                        style: _theme.textTheme.headline6,
                      ),
                      _sizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sub category:',
                            style: _theme.textTheme.headline6,
                          ),
                          _elevatedButton(
                            text: 'Create',
                            icon: Icons.add,
                            color: Colors.green,
                            onPressed: () async {
                              await _alertDialog(
                                context: context,
                                formKey: _formKey,
                                theme: _theme,
                                db: _db,
                                args: _args,
                                navigator: _navigator,
                              );
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _category.children!.isEmpty
                      ? Center(child: Text('No available data.'))
                      : Scrollbar(
                          child: ListView.separated(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: _category.children!.length,
                            itemBuilder: (context, index) {
                              Category _child = _category.children![index];

                              return ListTile(
                                title: Text(
                                  _child.name,
                                  style: _theme.textTheme.headline6,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _iconButton(
                                      icon: Icons.edit,
                                      color: AppColor.red,
                                      onPressed: () async {
                                        await _alertDialog(
                                          context: context,
                                          formKey: _formKey,
                                          theme: _theme,
                                          actionType: ActionType.update,
                                          category: _child,
                                          db: _db,
                                          args: _args,
                                          navigator: _navigator,
                                        );
                                      },
                                    ),
                                    _iconButton(
                                      icon: Icons.delete,
                                      color: AppColor.black,
                                      onPressed: () async {
                                        await _db.categoriesDao.revise(
                                          CategoriesCompanion(
                                            id: d.Value(_child.id),
                                            name: d.Value(_child.name),
                                            parentId: const d.Value(null),
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const Divider(),
                          ),
                        ),
                )
              ],
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
                await _navigator.pushNamed(
                  AppRouter.categoryUpdate,
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
                          await _db.categoriesDao.omit(
                            CategoriesCompanion(id: d.Value(_args['id'])),
                          );

                          _navigator.popUntil((route) {
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

  Future _alertDialog({
    required BuildContext context,
    required GlobalKey<FormBuilderState> formKey,
    required ThemeData theme,
    required AppDatabase db,
    required dynamic args,
    required NavigatorState navigator,
    ActionType actionType = ActionType.create,
    Category? category,
  }) {
    final _text = actionType == ActionType.create ? 'Create' : 'Edit';
    final _icon = actionType == ActionType.create ? Icons.add : Icons.edit;

    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.white,
        title: Text('$_text sub category', style: theme.textTheme.headline6),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: FormBuilder(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormBuilderTextField(
                  name: 'name',
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.words,
                  initialValue: category?.name,
                  decoration: _inputDecoration('Name'),
                  validator: FormBuilderValidators.required(),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.only(top: 8.0),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            alignment: Alignment.center,
            child: _elevatedButton(
              text: _text,
              icon: _icon,
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();

                  final _name = formKey.currentState!.fields['name']!.value;

                  if (actionType == ActionType.create) {
                    db.categoriesDao.make(
                      CategoriesCompanion(
                        name: d.Value(_name),
                        parentId: d.Value(args['id']),
                      ),
                    );
                  } else {
                    db.categoriesDao.revise(
                      CategoriesCompanion(
                        id: d.Value(category!.id),
                        name: d.Value(_name),
                      ),
                    );
                  }

                  navigator.pop(context);
                }
              },
            ),
          )
        ],
        actionsPadding: const EdgeInsets.all(8.0),
      ),
    );
  }

  Widget _iconButton({
    required IconData icon,
    Color? color,
    required void Function()? onPressed,
  }) {
    return IconButton(
      icon: Icon(icon),
      color: color,
      onPressed: onPressed,
    );
  }

  InputDecoration _inputDecoration(String placeholder) {
    return InputDecoration(
      labelText: placeholder,
      fillColor: AppColor.white,
      border: const OutlineInputBorder(),
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
