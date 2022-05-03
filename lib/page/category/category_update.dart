import 'dart:convert';
import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:vendibase/router/app_router.dart';
import 'package:vendibase/database/app_database.dart';
import 'package:vendibase/provider/app_database_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CategoryUpdate extends StatefulWidget {
  final dynamic args;
  const CategoryUpdate({
    Key? key,
    this.args,
  }) : super(key: key);

  @override
  State<CategoryUpdate> createState() => _CategoryUpdateState();
}

class _CategoryUpdateState extends State<CategoryUpdate> {
  Category? _category;
  List<Category>? _categories;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _setVariables();
  }

  void _setVariables() async {
    final _db = context.read<AppDatabaseProvider>().database;
    final _args = jsonDecode(jsonEncode(widget.args));

    _category = await _db.categoriesDao.getCategory(_args['id']);
    _categories = await _db.categoriesDao.getCategories(_args['id']);

    setState(() {}); // Force rebuild
  }

  @override
  Widget build(BuildContext context) {
    final _db = context.watch<AppDatabaseProvider>().database;
    final _navigator = Navigator.of(context);

    if (_categories != null && _category != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Category Edit'),
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'name',
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration('Name'),
                    initialValue: _category!.name,
                    validator: FormBuilderValidators.required(context),
                  ),
                  _sizedBox(height: 16),
                  FormBuilderDropdown(
                    name: 'parentId',
                    allowClear: true,
                    initialValue: _category!.parentId,
                    items: _categories!.map((_category) {
                      return DropdownMenuItem(
                        value: _category.id,
                        child: Text(_category.name),
                      );
                    }).toList(),
                    decoration: _inputDecoration('Parent category'),
                  ),
                ],
              ),
            ),
          ),
        ),
        persistentFooterButtons: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Row(
                  children: [
                    const Text('Edit'),
                    _sizedBox(width: 8),
                    const Icon(Icons.edit, size: 16),
                  ],
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final _name = _formKey.currentState!.fields['name']!.value;
                    final _parentId =
                        _formKey.currentState!.fields['parentId']!.value;

                    await _db.categoriesDao.revise(
                      CategoriesCompanion(
                        id: d.Value(_category!.id),
                        name: d.Value(_name),
                        parentId: d.Value(_parentId),
                      ),
                    );

                    if (_parentId != null) {
                      _navigator.popUntil((route) {
                        return route.settings.name == AppRouter.categoryIndex;
                      });
                    } else {
                      _navigator.pop(context);
                    }
                  }
                },
              ),
            ],
          )
        ],
      );
    }

    return const Center(child: CircularProgressIndicator());
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
}
