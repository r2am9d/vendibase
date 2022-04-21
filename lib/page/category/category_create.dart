import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:vendibase/router/app_router.dart';
import 'package:vendibase/database/app_database.dart';
import 'package:vendibase/provider/app_database_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CategoryCreate extends StatefulWidget {
  const CategoryCreate({Key? key}) : super(key: key);

  @override
  State<CategoryCreate> createState() => _CategoryCreateState();
}

class _CategoryCreateState extends State<CategoryCreate> {
  List<Category>? _categories;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _setVaraibles();
  }

  void _setVaraibles() async {
    final _db = context.read<AppDatabaseProvider>().database;

    _categories = await _db.categoriesDao.getCategories();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _db = context.read<AppDatabaseProvider>().database;
    final _navigator = Navigator.of(context);

    if (_categories != null) {
      debugPrint(_categories!.length.toString());

      return Scaffold(
        appBar: AppBar(
          title: Text('Category Create'),
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Details',
                    style: _theme.textTheme.headline6?.copyWith(
                      color: AppColor.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _sizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'name',
                    textInputAction: _categories!.length == 0
                        ? TextInputAction.done
                        : TextInputAction.next,
                    decoration: _inputDecoration('Name'),
                    validator: FormBuilderValidators.required(context),
                  ),
                  _sizedBox(height: 16),
                  FormBuilderDropdown(
                    name: 'parentId',
                    allowClear: true,
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
                    const Text('Create'),
                    _sizedBox(width: 8),
                    const Icon(Icons.add, size: 16),
                  ],
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final _name = _formKey.currentState!.fields['name']!.value;
                    final _parentId =
                        _formKey.currentState!.fields['parentId']!.value;

                    final _id = await _db.categoriesDao.make(
                      CategoriesCompanion(
                        name: d.Value(_name),
                        parentId: d.Value(_parentId),
                      ),
                    );

                    _navigator.popAndPushNamed(
                      AppRouter.categoryView,
                      arguments: {'id': _id},
                    );
                  }
                },
              ),
            ],
          )
        ],
      );
    }

    return Center(child: CircularProgressIndicator());
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
