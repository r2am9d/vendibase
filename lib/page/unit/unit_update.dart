import 'dart:convert';
import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:vendibase/database/app_database.dart';
import 'package:vendibase/provider/app_database_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class UnitUpdate extends StatefulWidget {
  final args;
  const UnitUpdate({
    Key? key,
    this.args,
  }) : super(key: key);

  @override
  State<UnitUpdate> createState() => _UnitUpdateState();
}

class _UnitUpdateState extends State<UnitUpdate> {
  Unit? _unit;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _setVariables();
  }

  void _setVariables() async {
    final _db = context.read<AppDatabaseProvider>().database;
    final _args = jsonDecode(jsonEncode(widget.args));

    _unit = await _db.unitsDao.getUnit(_args['id']);

    setState(() {}); // Force rebuild
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _db = context.watch<AppDatabaseProvider>().database;
    final _navigator = Navigator.of(context);

    if (_unit != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Unit Update'),
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
                    initialValue: _unit!.name,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration('Name'),
                    validator: FormBuilderValidators.required(),
                  ),
                  _sizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'amount',
                    initialValue: _unit!.amount.toString(),
                    textInputAction: TextInputAction.done,
                    decoration: _inputDecoration('Amount (pc/s)'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.integer(),
                      FormBuilderValidators.min(1),
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
                    const Text('Update'),
                    _sizedBox(width: 8),
                    const Icon(Icons.edit, size: 16),
                  ],
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final _name = _formKey.currentState!.fields['name']!.value;
                    final _amount =
                        _formKey.currentState!.fields['amount']!.value;

                    await _db.unitsDao.revise(
                      UnitsCompanion(
                        id: d.Value(_unit!.id),
                        name: d.Value(_name),
                        amount: d.Value(int.parse(_amount)),
                      ),
                    );

                    _navigator.pop(context);
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
