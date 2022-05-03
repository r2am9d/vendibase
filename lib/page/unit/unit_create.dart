import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:vendibase/router/app_router.dart';
import 'package:vendibase/database/app_database.dart';
import 'package:vendibase/provider/app_database_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class UnitCreate extends StatefulWidget {
  const UnitCreate({Key? key}) : super(key: key);

  @override
  State<UnitCreate> createState() => _UnitCreateState();
}

class _UnitCreateState extends State<UnitCreate> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _db = context.watch<AppDatabaseProvider>().database;
    final _navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Unit Create'),
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
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: _inputDecoration('Name'),
                  validator: FormBuilderValidators.required(context),
                ),
                _sizedBox(height: 16),
                FormBuilderTextField(
                  name: 'amount',
                  textInputAction: TextInputAction.done,
                  decoration: _inputDecoration('Amount (pc/s)'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                    FormBuilderValidators.integer(context),
                    FormBuilderValidators.min(context, 1),
                  ]),
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
                  final _amount =
                      _formKey.currentState!.fields['amount']!.value;

                  final _id = await _db.unitsDao.make(
                    UnitsCompanion(
                      name: d.Value(_name),
                      amount: d.Value(int.parse(_amount)),
                    ),
                  );

                  _navigator.pushReplacementNamed(
                    AppRouter.unitView,
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

  InputDecoration _inputDecoration(String placeholder) {
    return InputDecoration(
      alignLabelWithHint: true,
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
