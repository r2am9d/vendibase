import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as d;
import 'package:provider/provider.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:vendibase/database/app_database.dart';
import 'package:dropdown_search/dropdown_search.dart' as ds;
import 'package:vendibase/provider/app_database_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

import 'package:vendibase/utils/app_notification.dart';

class ArrearUpdate extends StatefulWidget {
  final args;
  const ArrearUpdate({
    Key? key,
    this.args,
  }) : super(key: key);

  @override
  State<ArrearUpdate> createState() => _ArrearUpdateState();
}

class _ArrearUpdateState extends State<ArrearUpdate> {
  ArrearWithDetails? _arrear;
  List<Person>? _persons;

  final _formKey = GlobalKey<FormBuilderState>();

  void _setVaraibles() async {
    final _db = context.read<AppDatabaseProvider>().database;
    final _args = jsonDecode(jsonEncode(widget.args));

    _arrear = await _db.arrearsDao.getArrear(_args['id']);
    _persons = await _db.personsDao.getPersons();

    setState(() {}); // Force rebuild
  }

  @override
  void initState() {
    super.initState();
    _setVaraibles();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _db = context.watch<AppDatabaseProvider>().database;
    final _navigator = Navigator.of(context);

    if (_arrear != null) {
      final _radius = Radius.circular(4);

      return Scaffold(
        appBar: AppBar(
          title: Text('Arrear Update'),
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
                  _sizedBox(height: 32.0),
                  FormBuilderSearchableDropdown(
                    name: 'personId',
                    showClearButton: true,
                    initialValue: DropdownMenuItem(
                      value: _arrear!.personId,
                      child: Text(_arrear!.personName),
                    ),
                    mode: ds.Mode.BOTTOM_SHEET,
                    decoration: InputDecoration(
                      labelText: 'Person',
                      alignLabelWithHint: true,
                      fillColor: AppColor.white,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.all(12.0),
                    ),
                    items: _persons!.map((_person) {
                      return DropdownMenuItem(
                        value: _person.id,
                        child: Text(_person.name),
                      );
                    }).toList(),
                    itemAsString: (DropdownMenuItem<int>? menuItem) {
                      final _text = menuItem!.child as Text;
                      return _text.data.toString();
                    },
                    popupShape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey, width: .5),
                      borderRadius: BorderRadius.vertical(bottom: _radius),
                    ),
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: "Search a person..",
                        contentPadding:
                            const EdgeInsets.only(left: 8, bottom: 4),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: .5),
                          borderRadius: BorderRadius.all(_radius),
                        ),
                      ),
                    ),
                    dropdownSearchDecoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.only(left: 16, bottom: 8),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.all(_radius),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: .5),
                        borderRadius: BorderRadius.vertical(top: _radius),
                      ),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                    ]),
                  ),
                  _sizedBox(height: 32.0),
                  Text(
                    'Arrear',
                    style: _theme.textTheme.headline6?.copyWith(
                      color: AppColor.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _sizedBox(height: 32.0),
                  FormBuilderTextField(
                    name: 'amount',
                    initialValue: _arrear!.amount.toString(),
                    textInputAction: TextInputAction.done,
                    decoration: _inputDecoration('Amount', true),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                      FormBuilderValidators.numeric(context),
                      FormBuilderValidators.min(context, 1),
                    ]),
                  ),
                  _sizedBox(height: 16.0),
                  FormBuilderDateTimePicker(
                    name: 'due',
                    initialValue: _arrear!.due,
                    inputType: InputType.date,
                    initialDate: DateTime.now().add(Duration(days: 1)),
                    firstDate: DateTime.now().add(Duration(days: 1)),
                    decoration: _inputDecoration('Due'),
                    textInputAction: TextInputAction.next,
                  ),
                  _sizedBox(height: 16.0),
                  FormBuilderTextField(
                    maxLines: 4,
                    name: 'remarks',
                    initialValue: _arrear!.remarks,
                    textInputAction: TextInputAction.done,
                    decoration: _inputDecoration('Remarks'),
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
                    final _fState = _formKey.currentState!;
                    _fState.save();

                    final _personId = _fState.fields['personId']!.value.value;
                    final _status = _arrear!.status;
                    final _amount = _fState.fields['amount']!.value;
                    final _due = _fState.fields['due']!.value;
                    final _remarks = _fState.fields['remarks']!.value;
                    final _dateCreated = _arrear!.dateCreated;

                    final _eic = d.EnumIndexConverter<Status>(Status.values);

                    var _notifId = _arrear!.notificationId;
                    if (_due != null && (_due != _arrear!.due)) {
                      // Cancel previous notif
                      if (_notifId != null)
                        await AppNotification.cancelNotification(_notifId);

                      // Schedule new notif
                      final _person = await _db.personsDao.getPerson(_personId);
                      await AppNotification.scheduleNotification(
                        title: 'Arrear payment',
                        body:
                            '${_person.name} debt should be paid today! Check it out.',
                        dateTime: _due,
                        payload: '/arrear-view/${_arrear!.id}',
                      );

                      // Reassign notifId
                      _notifId = AppNotification.notificationId;
                    }

                    await _db.arrearsDao.revise(
                      ArrearsCompanion(
                        id: d.Value(_arrear!.id),
                        personId: d.Value(_personId),
                        status: d.Value(_eic.mapToDart(_status)!),
                        amount: d.Value(double.parse(_amount)),
                        due: d.Value(_due),
                        notificationId: d.Value(_notifId),
                        remarks: d.Value(_remarks),
                        dateCreated: d.Value(_dateCreated),
                      ),
                    );

                    _navigator.pop();
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

  Widget _sizedBox({double? height, double? width}) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}
