import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expandable/expandable.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:vendibase/router/app_router.dart';
import 'package:vendibase/database/app_database.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:vendibase/provider/app_database_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ProductView extends StatefulWidget {
  final args;
  const ProductView({
    Key? key,
    this.args,
  }) : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final _jCtrl = JustTheController();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _db = context.read<AppDatabaseProvider>().database;
    final _navigator = Navigator.of(context);
    final _mediaQuery = MediaQuery.of(context);
    final _args = jsonDecode(jsonEncode(widget.args));

    return Scaffold(
      appBar: AppBar(
        title: Text('Product View'),
      ),
      body: StreamBuilder<ProductWithDetails>(
        stream: _db.productsDao.watchProduct(_args['id']),
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
            ProductWithDetails _product = snapshot.data!;
            final _height = _mediaQuery.size.height;
            final _width = _mediaQuery.size.width;

            final _kHeight = 72.5;
            final _borderRadius = BorderRadius.only(
              topRight: Radius.circular(40),
              topLeft: Radius.circular(40),
            );
            final _kMinHeight = _height / 2;

            final _photo = _product.photo;
            final _image = _photo.contains('asset')
                ? Image.asset(_photo, fit: BoxFit.none)
                : Image.file(File(_photo), fit: BoxFit.fill);

            _widget = Stack(
              fit: StackFit.expand,
              children: [
                // Image
                Positioned(
                  top: 0,
                  child: Container(
                    width: _width,
                    child: _image,
                    height: _kMinHeight,
                    color: AppColor.white,
                  ),
                ),
                // Card
                Positioned(
                  top: _kMinHeight - _kHeight,
                  child: Container(
                    width: _width,
                    height: _kMinHeight - _kHeight,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: _borderRadius,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 14,
                          spreadRadius: -3.5,
                          offset: Offset(0, -7),
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ],
                    ),
                    child: Material(
                      borderRadius: _borderRadius,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(32.0),
                        physics: BouncingScrollPhysics(),
                        child: _buildCardContent(
                          db: _db,
                          theme: _theme,
                          context: context,
                          product: _product,
                          formKey: _formKey,
                          controller: _jCtrl,
                        ),
                      ),
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
              onPressed: () {
                _navigator.pushNamed(
                  AppRouter.productUpdate,
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
                          // Delete photo
                          final _product =
                              await _db.productsDao.getProduct(_args['id']);
                          await GallerySaver.deleteImage(_product.photo);

                          await _db.productsDao.omit(
                            ProductsCompanion(id: d.Value(_args['id'])),
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

  Widget _buildCardContent({
    required AppDatabase db,
    required ThemeData theme,
    required BuildContext context,
    required ProductWithDetails product,
    required JustTheController controller,
    required GlobalKey<FormBuilderState> formKey,
  }) {
    final _f = NumberFormat("###,###.##", "en_US");

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.name,
                        style: theme.textTheme.headline6?.copyWith(
                          color: AppColor.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _sizedBox(width: 8.0),
                      product.remarks!.isNotEmpty
                          ? JustTheTooltip(
                              controller: controller,
                              child: Material(
                                color: AppColor.red,
                                shape: const CircleBorder(),
                                child: GestureDetector(
                                  onTap: () async {
                                    await controller.showTooltip();
                                  },
                                  child: Icon(Icons.info, color: Colors.white),
                                ),
                              ),
                              content: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(product.remarks!),
                              ),
                            )
                          : _sizedBox(),
                    ],
                  ),
                  _sizedBox(height: 16.0),
                  Text(
                    "₱ ${_f.format(product.activePrice)} • ${_f.format(product.activeQuantity)} pc/s",
                    style: theme.textTheme.bodyText1?.copyWith(
                      color: AppColor.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                iconSize: 36.0,
                splashRadius: 36.0,
                color: AppColor.red,
                icon: product.isFavorite
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                onPressed: () async {
                  await db.productsDao.revise(
                    ProductsCompanion(
                      id: d.Value(product.id),
                      photo: d.Value(product.photo),
                      name: d.Value(product.name),
                      isFavorite: d.Value(!product.isFavorite),
                    ),
                  );
                },
              ),
            ],
          ),
          _sizedBox(height: 16.0),
          _buildPurchaseList(db, theme, context, product, formKey),
          _sizedBox(height: 16.0),
          _buildPriceList(db, theme, context, product, formKey),
        ],
      ),
    );
  }

  Widget _buildPurchaseList(
    AppDatabase db,
    ThemeData theme,
    BuildContext context,
    ProductWithDetails product,
    GlobalKey<FormBuilderState> formKey,
  ) {
    final _d = DateFormat("d MMM y", "en_PH");
    final _f = NumberFormat("###,###.##", "en_US");
    List<ProductPurchase> _productPurchases = product.productPurchases!;

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
                  '₱ ${_f.format(product.latestCost)} • ${_f.format(product.latestQuantity)} pc/s',
                  style: theme.textTheme.bodyText1,
                ),
                subtitle: Text(
                  'on ${_d.format(product.latestCostDate!)}',
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
                          product: product,
                        );
                      },
                    ),
                  ],
                ),
              ),
              expanded: SizedBox(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: Scrollbar(
                  child: ListView.builder(
                    itemCount: _productPurchases.length,
                    itemBuilder: (context, index) {
                      ProductPurchase _productPurchase =
                          _productPurchases[index];

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
                          "₱ ${_f.format(_productPurchase.cost)} • ${_f.format(_productPurchase.quantity)} pc/s",
                          style: theme.textTheme.bodyText1,
                        ),
                        subtitle: Text(
                          _d.format(_productPurchase.dateCreated),
                          style: theme.textTheme.bodyText2,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _iconButton(
                              icon: Icons.edit,
                              onPressed: () async {
                                await _showPurchaseDialog(
                                  db: db,
                                  theme: theme,
                                  context: context,
                                  formKey: formKey,
                                  product: product,
                                  productPurchase: _productPurchase,
                                  actionType: ActionType.update,
                                );
                              },
                            ),
                            _productPurchases.length > 1
                                ? _iconButton(
                                    icon: Icons.delete,
                                    color: AppColor.black,
                                    onPressed: () async {
                                      await _deletePurchaseDialog(
                                        db: db,
                                        theme: theme,
                                        context: context,
                                        productPurchase: _productPurchase,
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
            ),
          )
        ],
      ),
    );
  }

  Future _showPurchaseDialog({
    ProductWithDetails? product,
    ProductPurchase? productPurchase,
    ActionType actionType = ActionType.create,
    required AppDatabase db,
    required ThemeData theme,
    required BuildContext context,
    required GlobalKey<FormBuilderState> formKey,
  }) {
    final _navigator = Navigator.of(context);
    final _text = actionType == ActionType.create ? 'Create' : 'Edit';
    final _icon = actionType == ActionType.create ? Icons.add : Icons.edit;

    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.white,
        title: Text("$_text purchase", style: theme.textTheme.headline6),
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
                      name: 'cost',
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration('Cost'),
                      initialValue: productPurchase?.cost.toString(),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.numeric(context),
                        FormBuilderValidators.min(context, 1),
                      ]),
                    ),
                    _sizedBox(height: 16.0),
                    FormBuilderTextField(
                      name: 'quantity',
                      textInputAction: TextInputAction.done,
                      decoration: _inputDecoration('Quantity'),
                      initialValue: productPurchase?.quantity.toString(),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.integer(context),
                        FormBuilderValidators.min(context, 1),
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
              text: _text,
              icon: _icon,
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();

                  final _productId = product!.id;
                  final _cost = formKey.currentState!.fields['cost']!.value;
                  final _quantity =
                      formKey.currentState!.fields['quantity']!.value;

                  if (actionType == ActionType.create) {
                    await db.productPurchasesDao.make(
                      ProductPurchasesCompanion(
                        productId: d.Value(_productId),
                        cost: d.Value(double.parse(_cost)),
                        quantity: d.Value(int.parse(_quantity)),
                      ),
                    );
                  } else {
                    final _id = productPurchase!.id;
                    final _dateCreated = productPurchase.dateCreated;

                    await db.productPurchasesDao.revise(
                      ProductPurchasesCompanion(
                        id: d.Value(_id),
                        productId: d.Value(_productId),
                        cost: d.Value(double.parse(_cost)),
                        quantity: d.Value(int.parse(_quantity)),
                        dateCreated: d.Value(_dateCreated),
                      ),
                    );
                  }

                  _navigator.pop();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future _deletePurchaseDialog({
    required AppDatabase db,
    required ThemeData theme,
    required BuildContext context,
    required ProductPurchase productPurchase,
  }) {
    final _navigator = Navigator.of(context);

    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.red,
        title: const Text('Confirm'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Text('Are you sure you want\nto delete this?'),
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
              _navigator.pop();
            },
          ),
          _outlineButton(
            text: 'Delete',
            color: AppColor.white,
            onPressed: () async {
              await db.productPurchasesDao.omit(
                ProductPurchasesCompanion(id: d.Value(productPurchase.id)),
              );

              _navigator.pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPriceList(
    AppDatabase db,
    ThemeData theme,
    BuildContext context,
    ProductWithDetails product,
    GlobalKey<FormBuilderState> formKey,
  ) {
    final _d = DateFormat("d MMM y", "en_PH");
    final _f = NumberFormat("###,###.##", "en_US");
    List<ProductPrice> _productPrices = product.productPrices!;

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
                'Price',
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
                        FontAwesomeIcons.tags,
                        color: AppColor.red,
                      ),
                    ],
                  ),
                ),
                title: Text(
                  '₱ ${_f.format(product.activePrice)}',
                  style: theme.textTheme.bodyText1,
                ),
                subtitle: Text(
                  'as of ${_d.format(product.activePriceDate!)}',
                  style: theme.textTheme.bodyText2,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _iconButton(
                      icon: Icons.add_circle,
                      onPressed: () async {
                        await _showPriceDialog(
                          db: db,
                          theme: theme,
                          context: context,
                          formKey: formKey,
                          product: product,
                        );
                      },
                    ),
                  ],
                ),
              ),
              expanded: SizedBox(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: Scrollbar(
                  child: ListView.builder(
                    itemCount: _productPrices.length,
                    itemBuilder: (context, index) {
                      ProductPrice _productPrice = _productPrices[index];

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.tag,
                                color: _productPrice.isActive
                                    ? AppColor.green
                                    : AppColor.red,
                              ),
                            ],
                          ),
                        ),
                        title: Text(
                          "₱ ${_f.format(_productPrice.retail)}",
                          style: theme.textTheme.bodyText1,
                        ),
                        subtitle: Text(
                          _d.format(_productPrice.dateCreated),
                          style: theme.textTheme.bodyText2,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _iconButton(
                              icon: _productPrice.isActive
                                  ? Icons.check_circle
                                  : Icons.remove_circle,
                              color: _productPrice.isActive
                                  ? Colors.green
                                  : Colors.red,
                              onPressed: _productPrice.isActive
                                  ? null
                                  : () async {
                                      await db.productPricesDao.setActive(
                                        ProductPricesCompanion(
                                          id: d.Value(_productPrice.id),
                                          productId:
                                              d.Value(_productPrice.productId),
                                          retail: d.Value(_productPrice.retail),
                                          isActive:
                                              d.Value(!_productPrice.isActive),
                                          dateCreated: d.Value(
                                              _productPrice.dateCreated),
                                        ),
                                        actionType: ActionType.update,
                                      );
                                    },
                            ),
                            _iconButton(
                              icon: Icons.edit,
                              onPressed: () async {
                                await _showPriceDialog(
                                  db: db,
                                  theme: theme,
                                  context: context,
                                  formKey: formKey,
                                  product: product,
                                  productPrice: _productPrice,
                                  actionType: ActionType.update,
                                );
                              },
                            ),
                            _productPrices.length > 1
                                ? _iconButton(
                                    icon: Icons.delete,
                                    color: AppColor.black,
                                    onPressed: () async {
                                      await _deletePriceDialog(
                                        db: db,
                                        theme: theme,
                                        context: context,
                                        productPrice: _productPrice,
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
            ),
          )
        ],
      ),
    );
  }

  Future _showPriceDialog({
    ProductWithDetails? product,
    ProductPrice? productPrice,
    ActionType actionType = ActionType.create,
    required AppDatabase db,
    required ThemeData theme,
    required BuildContext context,
    required GlobalKey<FormBuilderState> formKey,
  }) {
    final _navigator = Navigator.of(context);
    final _text = actionType == ActionType.create ? 'Create' : 'Edit';
    final _icon = actionType == ActionType.create ? Icons.add : Icons.edit;

    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.white,
        title: Text("$_text price", style: theme.textTheme.headline6),
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
                      name: 'retail',
                      textInputAction: TextInputAction.done,
                      decoration: _inputDecoration('Retail'),
                      initialValue: productPrice?.retail.toString(),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.numeric(context),
                        FormBuilderValidators.min(context, 1),
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
              text: _text,
              icon: _icon,
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();

                  final _productId = product!.id;
                  final _retail = formKey.currentState!.fields['retail']!.value;

                  if (actionType == ActionType.create) {
                    await db.productPricesDao.setActive(
                      ProductPricesCompanion(
                        productId: d.Value(_productId),
                        retail: d.Value(double.parse(_retail)),
                        isActive: d.Value(true),
                      ),
                      actionType: ActionType.create,
                    );
                  } else {
                    final _id = productPrice!.id;
                    final _isActive = productPrice.isActive;
                    final _dateCreated = productPrice.dateCreated;

                    await db.productPricesDao.revise(
                      ProductPricesCompanion(
                        id: d.Value(_id),
                        productId: d.Value(_productId),
                        retail: d.Value(double.parse(_retail)),
                        isActive: d.Value(_isActive),
                        dateCreated: d.Value(_dateCreated),
                      ),
                    );
                  }

                  _navigator.pop();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future _deletePriceDialog({
    required AppDatabase db,
    required ThemeData theme,
    required BuildContext context,
    required ProductPrice productPrice,
  }) {
    final _navigator = Navigator.of(context);

    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.red,
        title: const Text('Confirm'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Text('Are you sure you want\nto delete this?'),
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
              _navigator.pop();
            },
          ),
          _outlineButton(
            text: 'Delete',
            color: AppColor.white,
            onPressed: () async {
              await db.productPricesDao.omit(
                ProductPricesCompanion(id: d.Value(productPrice.id)),
              );

              _navigator.pop();
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

  InputDecoration _inputDecoration(String placeholder) {
    return InputDecoration(
      labelText: placeholder,
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
