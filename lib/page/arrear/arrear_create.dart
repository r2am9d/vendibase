import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as d;
import 'package:provider/provider.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:vendibase/router/app_router.dart';
import 'package:vendibase/database/app_database.dart';
import 'package:dropdown_search/dropdown_search.dart' as ds;
import 'package:vendibase/provider/app_database_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:vendibase/utils/app_notification.dart';

class ArrearCreate extends StatefulWidget {
  const ArrearCreate({Key? key}) : super(key: key);

  @override
  State<ArrearCreate> createState() => _ArrearCreateState();
}

class _ArrearCreateState extends State<ArrearCreate> {
  List<Person>? _persons;
  List<ProductWithDetails>? _products;

  final _formKey = GlobalKey<FormBuilderState>();
  final _dialogKey = GlobalKey<FormBuilderState>();
  final _nf = NumberFormat("###,###.##", "en_US");

  List<Map<String, dynamic>> _purchases = [];
  void _addPurchase(Map<String, dynamic> purchase) {
    setState(() {
      _purchases.add(purchase);
    });

    _countTotal();
  }

  void _countTotal() {
    final _total = _getTotalAmount(_purchases);
    _formKey.currentState!.fields['total']!.didChange("${_nf.format(_total)}");
  }

  num _getTotalAmount(List<Map<String, dynamic>> rows) {
    return rows.fold<num>(0, (acc, cur) {
      num total = (cur['price'] * cur['quantity']);
      return acc + total;
    });
  }

  void _setVaraibles() async {
    final _db = context.read<AppDatabaseProvider>().database;

    _products = await _db.productsDao.getProducts();
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
    final _db = context.read<AppDatabaseProvider>().database;
    final _navigator = Navigator.of(context);

    if (_persons != null && _products != null) {
      final _radius = Radius.circular(4);

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
                  _sizedBox(height: 32.0),
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
                            products: filterProducts(
                              puchases: _purchases,
                              products: _products!,
                            ),
                            dialogKey: _dialogKey,
                            navigator: _navigator,
                          );
                        },
                      )
                    ],
                  ),
                  _sizedBox(height: 32.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(color: Colors.grey.shade500),
                    ),
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width,
                    child: Scrollbar(
                      child: ListView.separated(
                        itemCount: _purchases.length,
                        itemBuilder: (context, index) {
                          // Get refs
                          final _purchase = _purchases[index];

                          return Card(
                            child: ListTile(
                              title: Text(
                                _purchase['name'],
                                style: _theme.textTheme.bodyText1,
                              ),
                              subtitle: Text(
                                '₱ ${_nf.format(_purchase['price'])} • ${_nf.format(_purchase['quantity'])} pc/s',
                                style: _theme.textTheme.bodyText2,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _iconButton(
                                    icon: Icons.edit,
                                    onPressed: () async {
                                      await _editPurchaseDialog(
                                        purchase: _purchase,
                                        context: context,
                                        dialogKey: _dialogKey,
                                        navigator: _navigator,
                                        theme: _theme,
                                      );
                                    },
                                  ),
                                  _iconButton(
                                    icon: Icons.delete,
                                    color: AppColor.black,
                                    onPressed: () {
                                      setState(() {
                                        _purchases.removeWhere(
                                          (p) => p['uid'] == _purchase['uid'],
                                        );
                                      });

                                      _countTotal();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            _sizedBox(height: 16.0),
                      ),
                    ),
                  ),
                  _sizedBox(height: 16.0),
                  FormBuilderTextField(
                    name: 'total',
                    enabled: false,
                    readOnly: true,
                    initialValue: '0',
                    decoration: _inputDecoration('Total', true),
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
                      // {'id': 1, 'name': 'Paid'},
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
                    decoration: _inputDecoration('Amount', true),
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
                    initialDate: DateTime.now().add(Duration(days: 1)),
                    firstDate: DateTime.now().add(Duration(days: 1)),
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

                    if (_due != null) {
                      final _person = await _db.personsDao.getPerson(_personId);

                      // Schedule notif
                      await AppNotification.scheduleNotification(
                        title: 'Arrear payment',
                        body:
                            '${_person.name} debt should be paid today! Check it out.',
                        dateTime: _due,
                        payload: '/arrear-view/${_id}',
                      );

                      // Update notifId
                      final _notifId = AppNotification.notifId;
                      await _db.arrearsDao.revise(
                        ArrearsCompanion(
                          id: d.Value(_id),
                          notificationId: d.Value(_notifId),
                        ),
                      );
                    }

                    _purchases.forEach((purchase) async {
                      await _db.arrearPurchasesDao.make(
                        ArrearPurchasesCompanion(
                          arrearId: d.Value(_id),
                          productId: d.Value(purchase['id']),
                          productPriceId: d.Value(purchase['priceId']),
                          quantity: d.Value(purchase['quantity']),
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

  List<ProductWithDetails> filterProducts({
    required List<Map<String, dynamic>> puchases,
    required List<ProductWithDetails> products,
  }) {
    if (puchases.isEmpty || products.isEmpty) return products;
    final _purchasesId = _purchases.map((e) => e['id']).toList();
    return products
        .where((product) => !_purchasesId.contains(product.id))
        .toList();
  }

  Future _editPurchaseDialog({
    required Map<String, dynamic> purchase,
    required ThemeData theme,
    required BuildContext context,
    required NavigatorState navigator,
    required GlobalKey<FormBuilderState> dialogKey,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.white,
        title: Text("Edit purchase", style: theme.textTheme.headline6),
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
                    FormBuilderTextField(
                      name: 'quantity',
                      initialValue: purchase['quantity'].toString(),
                      textInputAction: TextInputAction.done,
                      decoration: _inputDecoration('Quantity'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.integer(context),
                        FormBuilderValidators.min(context, 1),
                        (value) {
                          final _quantity = int.tryParse(value!);
                          final _activeQuantity = purchase['activeQuantity'];

                          if (_quantity == null) return null;
                          if (_quantity > _activeQuantity)
                            return 'Quantity value cannot be higher than product\'s quantity';
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
              text: 'Edit',
              icon: Icons.edit,
              onPressed: () async {
                if (_dialogKey.currentState!.validate()) {
                  _dialogKey.currentState!.save();
                  final _dState = _dialogKey.currentState!;

                  // Get refs
                  final _quantity = _dState.fields['quantity']!.value;

                  // Edit value
                  purchase['quantity'] = int.parse(_quantity);
                  setState(() {
                    _purchases[_purchases.indexWhere(
                            (element) => element['uid'] == purchase['uid'])] =
                        purchase;
                  });

                  _countTotal();

                  navigator.pop();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future _showPurchaseDialog({
    List<ProductWithDetails>? products,
    required AppDatabase db,
    required ThemeData theme,
    required BuildContext context,
    required NavigatorState navigator,
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
                          'activeQuantity': _product.activeQuantity
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
                          final _quantity = int.tryParse(value!);
                          final _product = _dState.fields['productId']?.value;

                          if (_quantity == null) return null;
                          if (_product != null) {
                            final _activeQuantity =
                                _product.value['activeQuantity'];
                            if (_quantity > _activeQuantity)
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
                  final _uid = Uuid().v4().split('-')[0];
                  final _product = _dState.fields['productId']!.value.value;
                  final _quantity = _dState.fields['quantity']!.value;

                  // Inject value & add to purchase list
                  _product['uid'] = _uid;
                  _product['quantity'] = int.parse(_quantity);
                  _addPurchase(_product);

                  navigator.pop();
                }
              },
            ),
          )
        ],
      ),
    );
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
