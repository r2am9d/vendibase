import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as d;
import 'package:provider/provider.dart';
import 'package:editable/editable.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:vendibase/router/app_router.dart';
import 'package:vendibase/database/app_database.dart';
import 'package:dropdown_search/dropdown_search.dart' as ds;
import 'package:vendibase/provider/app_database_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

class ArrearCreate extends StatefulWidget {
  const ArrearCreate({Key? key}) : super(key: key);

  @override
  State<ArrearCreate> createState() => _ArrearCreateState();
}

class _ArrearCreateState extends State<ArrearCreate> {
  List<Person>? _persons;
  List<ProductWithDetails>? _products;

  final _formKey = GlobalKey<FormBuilderState>();
  final _editableKey = GlobalKey<EditableState>();
  final _dialogKey = GlobalKey<FormBuilderState>();

  List _rows = [];
  List _cols = [
    {'title': 'Name', 'widthFactor': 0.36, 'key': 'name', 'editable': false},
    {'title': 'Price', 'widthFactor': 0.2, 'key': 'price', 'editable': false},
    {'title': 'Qty', 'widthFactor': 0.2, 'key': 'quantity', 'type': 'numeric'},
  ];

  void _addNewRow(Map<String, dynamic> row) {
    setState(() {
      _editableKey.currentState!.createRow(row);
    });
  }

  void _setVaraibles() async {
    final _db = context.read<AppDatabaseProvider>().database;

    _products = await _db.productsDao.getProducts();
    _persons = await _db.personsDao.getPersons();

    setState(() {}); // Force rebuild
  }

  num getTotalAmount(List<dynamic> rows) {
    return rows.fold<num>(0, (acc, cur) {
      num total = (cur['price'] * cur['quantity']);
      return acc + total;
    });
  }

  @override
  void initState() {
    super.initState();
    _setVaraibles();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _db = context.read<AppDatabaseProvider>().database;
    final _navigator = Navigator.of(context);

    if (_persons != null && _products != null) {
      final _radius = Radius.circular(4);
      final _nf = NumberFormat("###,###.##", "en_US");

      return Scaffold(
        appBar: AppBar(
          title: Text('Arrear Create'),
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
                  _sizedBox(height: 16.0),
                  FormBuilderSearchableDropdown(
                    name: 'personId',
                    showClearButton: true,
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
                  Row(
                    children: [
                      Text(
                        'Purchase',
                        style: _theme.textTheme.headline6?.copyWith(
                          color: AppColor.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _sizedBox(width: 8.0),
                      _elevatedButton(
                        text: 'Create',
                        icon: Icons.add,
                        color: AppColor.green,
                        onPressed: () async {
                          await _showPurchaseDialog(
                            db: _db,
                            theme: _theme,
                            context: context,
                            products: _products,
                            dialogKey: _dialogKey,
                            navigator: _navigator,
                            editableKey: _editableKey,
                          );
                        },
                      )
                    ],
                  ),
                  _sizedBox(height: 32.0),
                  // TODO: Change to ListView
                  SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(color: Colors.grey.shade500),
                      ),
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width,
                      child: Editable(
                        rows: _rows,
                        columns: _cols,
                        key: _editableKey,
                        onRowAdded: (value) {
                          final _rows = _editableKey.currentState!.rows!;
                          final _total = _nf.format(getTotalAmount(_rows));

                          _formKey.currentState!.fields['total']!
                              .didChange("${_total}");

                          debugPrint(_rows.toString());
                        },
                        onRowRemoved: (value) {
                          num _val = 0;
                          if (_editableKey.currentState!.rowCount! >= 1) {
                            final _rows = _editableKey.currentState!.rows!;
                            _val = getTotalAmount(_rows);
                          }

                          final _total = _nf.format(_val);
                          _formKey.currentState!.fields['total']!
                              .didChange("${_total}");
                        },
                        onSubmitted: (value) {
                          final _rows = _editableKey.currentState!.rows!;
                          final _total = _nf.format(getTotalAmount(_rows));

                          _formKey.currentState!.fields['total']!
                              .didChange("${_total}");
                        },
                        showRemoveIcon: true,
                        removeIconColor: AppColor.red,
                        borderColor: Colors.blueGrey,
                        tdStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        trHeight: 80,
                        thStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        thAlignment: TextAlign.left,
                        thVertAlignment: CrossAxisAlignment.center,
                        thPaddingBottom: 3,
                        tdAlignment: TextAlign.left,
                        tdEditableMaxLines: 100,
                        tdPaddingTop: 0,
                        tdPaddingBottom: 14,
                        tdPaddingLeft: 10,
                        tdPaddingRight: 8,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                      ),
                    ),
                  ),
                  _sizedBox(height: 16.0),
                  FormBuilderTextField(
                    name: 'total',
                    enabled: false,
                    readOnly: true,
                    initialValue: '0',
                    decoration: _inputDecoration('Total'),
                    onChanged: (value) {
                      // Set validation on the fly ??
                      // _formKey.currentState!.fields['amount']!;
                      // FormBuilderValidators.max(context, value);
                    },
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
                  FormBuilderDropdown(
                    name: 'status',
                    allowClear: true,
                    items: [
                      {'id': 0, 'name': 'Unpaid'},
                      {'id': 1, 'name': 'Paid'},
                    ].map((Map<String, dynamic> _status) {
                      return DropdownMenuItem(
                        value: _status['id'],
                        child: Text(_status['name']),
                      );
                    }).toList(),
                    initialValue: 0,
                    decoration: _inputDecoration('Status'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                    ]),
                  ),
                  _sizedBox(height: 16.0),
                  FormBuilderTextField(
                    name: 'amount',
                    textInputAction: TextInputAction.done,
                    decoration: _inputDecoration('Amount'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                      FormBuilderValidators.numeric(context),
                      FormBuilderValidators.min(context, 1),
                      (value) {
                        final _fState = _formKey.currentState!;
                        final _amount = double.tryParse(value!);
                        final _total = _fState.fields['total']?.value;

                        if (_amount == null) return null;
                        if (_total != null) {
                          final _mTotal =
                              double.tryParse(_total.replaceAll(',', ''))!;
                          if (_amount > _mTotal)
                            return 'Amount value cannot be higher than total\'s value';
                        }
                        return null; // Fallback
                      }
                    ]),
                  ),
                  _sizedBox(height: 16.0),
                  FormBuilderDateTimePicker(
                    name: 'due',
                    inputType: InputType.date,
                    firstDate: DateTime.now(),
                    decoration: _inputDecoration('Due'),
                    textInputAction: TextInputAction.next,
                  ),
                  _sizedBox(height: 16.0),
                  FormBuilderTextField(
                    maxLines: 4,
                    name: 'remarks',
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
                    const Text('Create'),
                    _sizedBox(width: 8.0),
                    const FaIcon(FontAwesomeIcons.moneyBill, size: 16.0)
                  ],
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final _fState = _formKey.currentState!;

                    final _personId = _fState.fields['personId']!.value.value;
                    final _rows = _editableKey.currentState!.rows!;
                    final _status = _fState.fields['status']!.value;
                    final _amount = _fState.fields['amount']!.value;
                    final _due = _fState.fields['due']!.value;
                    final _remarks = _fState.fields['remarks']!.value;

                    final _eic = d.EnumIndexConverter<Status>(Status.values);

                    final _id = await _db.arrearsDao.make(
                      ArrearsCompanion(
                        personId: d.Value(_personId),
                        status: d.Value(_eic.mapToDart(_status)!),
                        amount: d.Value(double.parse(_amount)),
                        due: d.Value(_due),
                        remarks: d.Value(_remarks),
                      ),
                    );

                    _rows.forEach((row) async {
                      await _db.arrearPurchasesDao.make(
                        ArrearPurchasesCompanion(
                          arrearId: d.Value(_id),
                          productId: d.Value(row['id']),
                          productPriceId: d.Value(row['priceId']),
                          quantity: d.Value(row['quantity']),
                        ),
                      );
                    });

                    _navigator.pushReplacementNamed(
                      AppRouter.arrearView,
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

  Future _showPurchaseDialog({
    List<ProductWithDetails>? products,
    required AppDatabase db,
    required ThemeData theme,
    required BuildContext context,
    required NavigatorState navigator,
    required GlobalKey<EditableState> editableKey,
    required GlobalKey<FormBuilderState> dialogKey,
  }) {
    final _radius = Radius.circular(4);

    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.white,
        title: Text("Create purchase", style: theme.textTheme.headline6),
        content: Scrollbar(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: FormBuilder(
                key: dialogKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sizedBox(height: 16.0),
                    FormBuilderSearchableDropdown(
                      name: 'productId',
                      showClearButton: true,
                      mode: ds.Mode.BOTTOM_SHEET,
                      decoration: InputDecoration(
                        labelText: 'Product',
                        alignLabelWithHint: true,
                        fillColor: AppColor.white,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.all(12.0),
                      ),
                      items: products!.map((_product) {
                        final _value = {
                          'id': _product.id,
                          'priceId': _product.activePriceId,
                          'name': _product.name,
                          'price': _product.activePrice,
                          'quantity': _product.activeQuantity
                        };
                        // final _price = _nf.format(_product.activePrice);
                        return DropdownMenuItem(
                          value: _value,
                          child: Text("${_product.name}"),
                        );
                      }).toList(),
                      itemAsString: (DropdownMenuItem? menuItem) {
                        final _text = menuItem!.child as Text;
                        return _text.data!.toString();
                      },
                      popupShape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: .5),
                        borderRadius: BorderRadius.vertical(bottom: _radius),
                      ),
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          hintText: "Search a product..",
                          contentPadding:
                              const EdgeInsets.only(left: 8, bottom: 4),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: .5),
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
                    _sizedBox(height: 16.0),
                    FormBuilderTextField(
                      name: 'quantity',
                      textInputAction: TextInputAction.done,
                      decoration: _inputDecoration('Quantity'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.integer(context),
                        FormBuilderValidators.min(context, 1),
                        (value) {
                          final _dState = _dialogKey.currentState!;
                          final _qty = int.tryParse(value!);
                          final _product = _dState.fields['productId']?.value;

                          if (_qty == null) return null;
                          if (_product != null) {
                            final _quantity = _product.value['quantity'];
                            if (_qty > _quantity)
                              return 'Quantity value cannot be higher than product\'s quantity';
                          }
                          return null; // Fallback
                        }
                      ]),
                    ),
                    _sizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            alignment: Alignment.center,
            child: _elevatedButton(
              text: 'Create',
              icon: Icons.add,
              onPressed: () async {
                if (_dialogKey.currentState!.validate()) {
                  _dialogKey.currentState!.save();
                  final _dState = _dialogKey.currentState!;

                  // Get refs
                  final _product = _dState.fields['productId']!.value.value;
                  final _quantity = _dState.fields['quantity']!.value;

                  // Inject value & to table list
                  _product['quantity'] = int.parse(_quantity);
                  _addNewRow(_product);

                  navigator.pop();
                }
              },
            ),
          )
        ],
      ),
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
