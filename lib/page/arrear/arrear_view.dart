import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expandable/expandable.dart';
import 'package:vendibase/router/app_router.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:vendibase/database/app_database.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:vendibase/provider/app_database_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:vendibase/utils/app_notification.dart';

class ArrearView extends StatefulWidget {
  final args;
  const ArrearView({
    Key? key,
    this.args,
  }) : super(key: key);

  @override
  State<ArrearView> createState() => _ArrearViewState();
}

class _ArrearViewState extends State<ArrearView> {
  List<ProductWithDetails>? _products;

  final _jCtrl = JustTheController();
  final _formKey = GlobalKey<FormBuilderState>();

  void _setVaraibles() async {
    final _db = context.read<AppDatabaseProvider>().database;

    _products = await _db.productsDao.getProducts();

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
    final _args = jsonDecode(jsonEncode(widget.args));

    if (_products != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Arrear View'),
        ),
        body: StreamBuilder<ArrearWithDetails>(
          stream: _db.arrearsDao.watchArrear(_args['id']),
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
              ArrearWithDetails _arrear = snapshot.data!;
              final _photo = _arrear.personPhoto;
              final _image = _photo.contains('asset')
                  ? AssetImage(_photo)
                  : FileImage(File(_photo)) as ImageProvider;

              final _df = DateFormat("d MMM y", "en_PH");
              final _nf = NumberFormat("###,###.##", "en_PH");
              final _eic = d.EnumIndexConverter<Status>(Status.values);
              final _due = _arrear.due != null ? _df.format(_arrear.due!) : '-';

              _widget = Scrollbar(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 115.0,
                            backgroundColor: AppColor.red,
                            child: CircleAvatar(
                              radius: 105.0,
                              backgroundColor: AppColor.white,
                              child: CircleAvatar(
                                radius: 95.0,
                                backgroundColor: AppColor.red,
                                backgroundImage: _image,
                              ),
                            ),
                          ),
                        ],
                      ),
                      _sizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '₱ ${_nf.format(_arrear.activeAmount)}',
                            style: _theme.textTheme.headline5?.copyWith(
                              color: AppColor.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _sizedBox(width: 8.0),
                          Text('|'),
                          _sizedBox(width: 8.0),
                          Text(
                            _due,
                            style: _theme.textTheme.headline6?.copyWith(
                              color: AppColor.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      _sizedBox(height: 8.0),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _arrear.personName,
                            style: _theme.textTheme.headline6?.copyWith(
                              color: AppColor.black.withOpacity(.5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _sizedBox(width: 8.0),
                          _arrear.remarks != null
                              ? JustTheTooltip(
                                  controller: _jCtrl,
                                  child: Material(
                                    color: AppColor.red,
                                    shape: const CircleBorder(),
                                    child: GestureDetector(
                                      onTap: () async {
                                        await _jCtrl.showTooltip();
                                      },
                                      child:
                                          Icon(Icons.info, color: Colors.white),
                                    ),
                                  ),
                                  content: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(_arrear.remarks!),
                                  ),
                                )
                              : _sizedBox(),
                        ],
                      ),
                      _sizedBox(height: 8.0),
                      _buildToggle(
                        db: _db,
                        eic: _eic,
                        arrear: _arrear,
                      ),
                      _sizedBox(height: 16.0),
                      _buildPurchaseList(
                        db: _db,
                        theme: _theme,
                        context: context,
                        navigator: _navigator,
                        formKey: _formKey,
                        arrear: _arrear,
                        products: _products!,
                      ),
                      _sizedBox(height: 16.0),
                      _buildPaymentList(
                        db: _db,
                        theme: _theme,
                        context: context,
                        navigator: _navigator,
                        formKey: _formKey,
                        arrear: _arrear,
                      ),
                    ],
                  ),
                ),
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
                    AppRouter.arrearUpdate,
                    arguments: {'id': _args['id']},
                  );
                },
              ),
              _sizedBox(width: 32.0),
              _elevatedButton(
                text: 'Delete',
                icon: Icons.delete,
                color: Colors.black,
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Confirm'),
                      backgroundColor: AppColor.red,
                      content: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Text(
                          'Are you sure you want\nto delete this?',
                        ),
                      ),
                      actionsPadding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
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
                            await _db.arrearsDao.omit(
                              ArrearsCompanion(id: d.Value(_args['id'])),
                            );

                            _navigator.popUntil((route) {
                              return route.settings.name == AppRouter.home;
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      );
    }

    return Center(child: CircularProgressIndicator());
  }

  Widget _buildToggle({
    required AppDatabase db,
    required ArrearWithDetails arrear,
    required d.EnumIndexConverter<Status> eic,
  }) {
    return AnimatedToggleSwitch<int>.dual(
      first: 0,
      second: 1,
      height: 48.0,
      borderWidth: 2.0,
      current: arrear.status,
      onTap: () async {
        final _status = arrear.status == 1 ? 0 : 1;

        /// If paid, disable notification
        if (_status == 1) {
          if (arrear.notificationId != null)
            AppNotification.cancelNotification(arrear.notificationId!);
        }

        await db.arrearsDao.revise(
          ArrearsCompanion(
            id: d.Value(arrear.id),
            personId: d.Value(arrear.personId),
            status: d.Value(eic.mapToDart(_status)!),
            amount: d.Value(arrear.amount),
            due: d.Value(arrear.due),
            remarks: d.Value(arrear.remarks),
            dateCreated: d.Value(arrear.dateCreated),
          ),
        );
      },
      colorBuilder: (value) => value == 0 ? AppColor.red1 : AppColor.green,
      iconBuilder: (value) => value == 0
          ? Icon(
              Icons.sentiment_very_dissatisfied,
              color: AppColor.white,
            )
          : Icon(
              Icons.sentiment_very_satisfied,
              color: AppColor.white,
            ),
      textBuilder: (value) => value == 0
          ? Center(
              child: Text(
                'Unpaid',
                style: TextStyle(color: AppColor.red1),
              ),
            )
          : Center(
              child: Text(
                'Paid',
                style: TextStyle(color: AppColor.green),
              ),
            ),
      borderColorBuilder: (value) =>
          value == 0 ? AppColor.red1 : AppColor.green,
    );
  }

  Widget _buildPurchaseList({
    required AppDatabase db,
    required ThemeData theme,
    required BuildContext context,
    required NavigatorState navigator,
    required ArrearWithDetails arrear,
    required GlobalKey<FormBuilderState> formKey,
    required List<ProductWithDetails> products,
  }) {
    final _df = DateFormat("d MMM y", "en_PH");
    final _nf = NumberFormat("###,###.##", "en_PH");
    List<ArrearPurchaseWithDetails> _arrearPurchases = arrear.arrearPurchases!;

    return ExpandableNotifier(
      child: Column(
        children: [
          ScrollOnExpand(
            scrollOnExpand: true,
            scrollOnCollapse: false,
            child: ExpandablePanel(
              theme: const ExpandableThemeData(
                headerAlignment: ExpandablePanelHeaderAlignment.center,
              ),
              header: Text(
                'Purchase',
                style: theme.textTheme.bodyText1?.copyWith(
                  color: AppColor.red,
                ),
              ),
              collapsed: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.cubes,
                        color: AppColor.red,
                      ),
                    ],
                  ),
                ),
                title: Text(
                  '${_nf.format(arrear.totalPurchase)} product/s',
                  style: theme.textTheme.bodyText1,
                ),
                subtitle: Text(
                  '₱ ${_nf.format(arrear.totalPurchaseAmount)}',
                  style: theme.textTheme.bodyText2,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _iconButton(
                      icon: Icons.add_circle,
                      onPressed: () async {
                        await _showPurchaseDialog(
                          db: db,
                          theme: theme,
                          context: context,
                          formKey: formKey,
                          navigator: navigator,
                          arrear: arrear,
                          products: products,
                        );
                      },
                    ),
                  ],
                ),
              ),
              expanded: SizedBox(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: _arrearPurchases.length,
                  itemBuilder: (context, index) {
                    ArrearPurchaseWithDetails _arrearPurchase =
                        _arrearPurchases[index];

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.cube,
                              color: AppColor.red,
                            ),
                          ],
                        ),
                      ),
                      title: Text(
                        _arrearPurchase.productName,
                        style: theme.textTheme.bodyText1,
                      ),
                      subtitle: Text(
                        '₱ ${_nf.format(_arrearPurchase.productPrice)} • ${_nf.format(_arrearPurchase.quantity)} pc/s • ${_df.format(_arrearPurchase.dateCreated)}',
                        style: theme.textTheme.bodyText2,
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future _showPurchaseDialog({
    required ArrearWithDetails arrear,
    required List<ProductWithDetails> products,
    required AppDatabase db,
    required ThemeData theme,
    required BuildContext context,
    required NavigatorState navigator,
    required GlobalKey<FormBuilderState> formKey,
  }) {
    final _radius = Radius.circular(4);
    final _nf = NumberFormat("###,###.##", "en_PH");

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
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sizedBox(height: 16.0),
                    FormBuilderSearchableDropdown<DropdownMenuItem>(
                      name: 'productId',
                      showClearButton: true,
                      compareFn: (item, selectedItem) =>
                          item.value == selectedItem.value,
                      popupProps: PopupProps.modalBottomSheet(
                        showSearchBox: true,
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
                      ),
                      decoration: InputDecoration(
                        labelText: 'Product',
                        alignLabelWithHint: true,
                        fillColor: AppColor.white,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.all(12.0),
                      ),
                      items: products.map((_product) {
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
                      // itemAsString: (DropdownMenuItem? menuItem) {
                      //   final _text = menuItem!.child as Text;
                      //   return _text.data!.toString();
                      // },
                      // popupShape: RoundedRectangleBorder(
                      //   side: BorderSide(color: Colors.grey, width: .5),
                      //   borderRadius: BorderRadius.vertical(bottom: _radius),
                      // ),
                      itemAsString: (dynamic menuItem) {
                        menuItem = menuItem as DropdownMenuItem;
                        final _text = menuItem.child as Text;
                        return _text.data.toString();
                      },
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
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    _sizedBox(height: 16.0),
                    FormBuilderTextField(
                      name: 'quantity',
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration('Quantity'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.integer(),
                        FormBuilderValidators.min(1),
                        (value) {
                          final _fState = formKey.currentState!;
                          final _quantity = int.tryParse(value!);
                          final _product = _fState.fields['productId']?.value;

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
                      onSubmitted: (value) {
                        final _fState = formKey.currentState!;
                        final _product = _fState.fields['productId']?.value;

                        final _quantity = value == '' ? 0 : int.parse(value!);
                        final _price =
                            _product == null ? 0 : _product.value['price'];
                        final _amount = _price * _quantity;

                        _fState.fields['total']!
                            .didChange('${_nf.format(_amount)}');
                      },
                    ),
                    _sizedBox(height: 16.0),
                    FormBuilderTextField(
                      name: 'total',
                      enabled: false,
                      readOnly: true,
                      initialValue: '0',
                      decoration: _inputDecoration('Total', true),
                    ),
                    Divider(height: 64.0),
                    FormBuilderTextField(
                      name: 'amount',
                      textInputAction: TextInputAction.done,
                      decoration: _inputDecoration('Amount', true),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.min(1),
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
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  final _fState = formKey.currentState!;

                  // Get refs
                  final _product = _fState.fields['productId']!.value.value;
                  final _quantity = _fState.fields['quantity']!.value;
                  final _amount = _fState.fields['amount']!.value;
                  final _eic = d.EnumIndexConverter<Status>(Status.values);

                  // Add arrear_purchases
                  await db.arrearPurchasesDao.make(
                    ArrearPurchasesCompanion(
                      arrearId: d.Value(arrear.id),
                      productId: d.Value(_product['id']),
                      productPriceId: d.Value(_product['priceId']),
                      quantity: d.Value(int.parse(_quantity)),
                    ),
                  );

                  // Update arrear
                  await db.arrearsDao.revise(
                    ArrearsCompanion(
                      id: d.Value(arrear.id),
                      personId: d.Value(arrear.personId),
                      status: d.Value(_eic.mapToDart(arrear.status)!),
                      amount: d.Value(arrear.amount + double.parse(_amount)),
                      due: d.Value(arrear.due),
                      remarks: d.Value(arrear.remarks),
                      dateCreated: d.Value(arrear.dateCreated),
                    ),
                  );

                  navigator.pop();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPaymentList({
    required AppDatabase db,
    required ThemeData theme,
    required BuildContext context,
    required ArrearWithDetails arrear,
    required NavigatorState navigator,
    required GlobalKey<FormBuilderState> formKey,
  }) {
    final _df = DateFormat("d MMM y", "en_PH");
    final _nf = NumberFormat("###,###.##", "en_PH");
    List<ArrearPayment> _arrearPayments = arrear.arrearPayments!;

    return ExpandableNotifier(
      child: Column(
        children: [
          ScrollOnExpand(
            scrollOnExpand: true,
            scrollOnCollapse: false,
            child: ExpandablePanel(
              theme: const ExpandableThemeData(
                headerAlignment: ExpandablePanelHeaderAlignment.center,
              ),
              header: Text(
                'Payment',
                style: theme.textTheme.bodyText1?.copyWith(
                  color: AppColor.red,
                ),
              ),
              collapsed: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.moneyBills,
                        color: AppColor.red,
                      ),
                    ],
                  ),
                ),
                title: Text(
                  '${_nf.format(arrear.totalPayment)} payment/s',
                  style: theme.textTheme.bodyText1,
                ),
                subtitle: Text(
                  '₱ ${_nf.format(arrear.totalPaymentAmount)}',
                  style: theme.textTheme.bodyText2,
                ),
                trailing: arrear.activeAmount <= 0
                    ? _sizedBox()
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _iconButton(
                            icon: Icons.add_circle,
                            onPressed: () async {
                              await _showPaymentDialog(
                                db: db,
                                theme: theme,
                                context: context,
                                formKey: formKey,
                                arrear: arrear,
                                navigator: navigator,
                              );
                            },
                          ),
                        ],
                      ),
              ),
              expanded: SizedBox(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: _arrearPayments.length,
                  itemBuilder: (context, index) {
                    ArrearPayment _arrearPayment = _arrearPayments[index];

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.moneyBill,
                              color: AppColor.red,
                            ),
                          ],
                        ),
                      ),
                      title: Text(
                        '₱ ${_nf.format(_arrearPayment.amount)}',
                        style: theme.textTheme.bodyText1,
                      ),
                      subtitle: Text(
                        'on ${_df.format(_arrearPayment.dateCreated)}',
                        style: theme.textTheme.bodyText2,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _arrearPayments.length > 1
                              ? _iconButton(
                                  icon: Icons.delete,
                                  color: AppColor.black,
                                  onPressed: () async {
                                    await _deletePaymentDialog(
                                      db: db,
                                      theme: theme,
                                      context: context,
                                      navigator: navigator,
                                      arrear: arrear,
                                      arrearPayment: _arrearPayment,
                                    );
                                  },
                                )
                              : _sizedBox(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future _showPaymentDialog({
    ArrearPayment? arrearPayment,
    required ArrearWithDetails arrear,
    required AppDatabase db,
    required ThemeData theme,
    required BuildContext context,
    required NavigatorState navigator,
    required GlobalKey<FormBuilderState> formKey,
    ActionType? actionType = ActionType.create,
  }) {
    final _amt = arrearPayment == null ? '' : arrearPayment.amount;
    final _text = actionType == ActionType.create ? 'Create' : 'Edit';
    final _icon = actionType == ActionType.create ? Icons.add : Icons.edit;

    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.white,
        title: Text("$_text payment", style: theme.textTheme.headline6),
        content: Scrollbar(
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: FormBuilder(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sizedBox(height: 16.0),
                    FormBuilderTextField(
                      name: 'amount',
                      initialValue: _amt.toString(),
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration('Amount', true),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.min(1),
                      ]),
                    ),
                    _sizedBox(height: 16.0),
                    FormBuilderTextField(
                      maxLines: 4,
                      name: 'remarks',
                      initialValue: arrearPayment?.remarks,
                      textInputAction: TextInputAction.done,
                      decoration: _inputDecoration('Remarks'),
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
              text: _text,
              icon: _icon,
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  final _fState = formKey.currentState!;

                  // Get refs
                  final _amount = _fState.fields['amount']!.value;
                  final _remarks = _fState.fields['remarks']!.value;

                  if (actionType == ActionType.create) {
                    await db.arrearPaymentsDao.make(
                      ArrearPaymentsCompanion(
                        arrearId: d.Value(arrear.id),
                        amount: d.Value(double.parse(_amount)),
                        remarks: d.Value(_remarks),
                      ),
                    );
                  } else {
                    final _id = arrearPayment!.id;
                    final _arrearId = arrearPayment.arrearId;
                    final _dateCreated = arrearPayment.dateCreated;

                    await db.arrearPaymentsDao.revise(
                      ArrearPaymentsCompanion(
                        id: d.Value(_id),
                        arrearId: d.Value(_arrearId),
                        amount: d.Value(double.parse(_amount)),
                        remarks: d.Value(_remarks),
                        dateCreated: d.Value(_dateCreated),
                      ),
                    );
                  }

                  navigator.pop();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future _deletePaymentDialog({
    required AppDatabase db,
    required ThemeData theme,
    required BuildContext context,
    required NavigatorState navigator,
    required ArrearWithDetails arrear,
    required ArrearPayment arrearPayment,
  }) {
    final _nf = NumberFormat("###,###.##", "en_PH");

    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.red,
        title: const Text('Confirm'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Text(
            'Are you sure you want\nto delete "${_nf.format(arrearPayment.amount)}"?',
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        actions: [
          _outlineButton(
            text: 'Cancel',
            color: AppColor.white,
            onPressed: () {
              navigator.pop();
            },
          ),
          _outlineButton(
            text: 'Delete',
            color: AppColor.white,
            onPressed: () async {
              await db.arrearPaymentsDao.omit(
                ArrearPaymentsCompanion(
                  id: d.Value(arrearPayment.id),
                ),
              );

              navigator.pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _sizedBox({
    double? height,
    double? width,
  }) {
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
      splashRadius: 24.0,
      iconSize: 24.0,
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
}
