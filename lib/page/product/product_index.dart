import 'dart:io';

import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:vendibase/router/app_router.dart';
import 'package:vendibase/database/app_database.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:dropdown_search/dropdown_search.dart' as ds;
import 'package:vendibase/provider/app_database_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

class ProductIndex extends StatefulWidget {
  const ProductIndex({Key? key}) : super(key: key);

  @override
  State<ProductIndex> createState() => _ProductIndexState();
}

class _ProductIndexState extends State<ProductIndex> {
  String _searchTerm = '';
  Map<String, dynamic> _filters = {};

  bool _isSearching = false;
  bool _isVisible = true;

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _db = context.watch<AppDatabaseProvider>().database;
    final _navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _isSearching
            ? TextField(
                autofocus: true,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Search products',
                ),
                onSubmitted: (term) {
                  setState(() {
                    _searchTerm = term;
                  });
                },
              )
            : const Text('Products'),
        actions: [
          _iconButton(
            icon: _isSearching ? Icons.clear : Icons.search,
            color: AppColor.black,
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchTerm = '';
                }
              });
            },
          ),
          _iconButton(
            icon: Icons.filter_alt,
            color: AppColor.black,
            onPressed: () async {
              setState(() {
                _filters = {};
              });

              await _showFilterDialog(
                db: _db,
                theme: _theme,
                context: context,
                formKey: _formKey,
              );
            },
          ),
        ],
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          setState(() {
            if (notification.direction == ScrollDirection.forward) {
              if (!_isVisible) _isVisible = true;
            } else if (notification.direction == ScrollDirection.reverse) {
              if (_isVisible) _isVisible = false;
            }
          });

          return true;
        },
        child: StreamBuilder<List<ProductWithDetails>>(
          stream: _db.productsDao.watchProducts(_searchTerm, _filters),
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
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              _widget = Center(child: Text('No available data.'));
            } else {
              List<ProductWithDetails> _products = snapshot.data!;

              _widget = GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(32.0),
                mainAxisSpacing: 32.0,
                crossAxisSpacing: 32.0,
                children: List<Widget>.generate(_products.length, (index) {
                  return _buildCard(
                    _products[index],
                    context,
                    _db,
                    _theme,
                    _navigator,
                  );
                }),
              );
            }

            return _widget;
          },
        ),
      ),
      floatingActionButton: _isVisible
          ? FloatingActionButton(
              tooltip: 'Add product',
              heroTag: 'product-index-fab',
              child: const Icon(Icons.add_shopping_cart),
              onPressed: () {
                _navigator.pushNamed(AppRouter.productCreate);
              },
            )
          : null,
    );
  }

  Widget _buildCard(
    ProductWithDetails product,
    BuildContext context,
    AppDatabase db,
    ThemeData theme,
    NavigatorState navigator,
  ) {
    final _photo = product.photo;
    final _f = NumberFormat("###,###.##", "en_US");
    final _borderRadius = BorderRadius.circular(20.0);
    final _image = _photo.contains('asset')
        ? Image.asset(_photo)
        : File(_photo).existsSync()
            ? Image.file(File(_photo), fit: BoxFit.fill)
            : Image.asset('assets/images/basket.png');

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: _borderRadius,
            boxShadow: [
              BoxShadow(
                spreadRadius: 0,
                blurRadius: 7,
                color: Colors.grey.withOpacity(0.5),
              ),
            ],
          ),
          child: Material(
            color: AppColor.white,
            borderRadius: _borderRadius,
            child: InkWell(
              onLongPress: () async {
                await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Confirm'),
                    backgroundColor: AppColor.red,
                    content: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'Are you sure you want\nto delete "${product.name}"?',
                      ),
                    ),
                    actions: [
                      _outlineButton(
                        text: 'Cancel',
                        color: AppColor.white,
                        onPressed: () {
                          navigator.pop(context);
                        },
                      ),
                      _outlineButton(
                        text: 'Delete',
                        color: AppColor.white,
                        onPressed: () async {
                          // Delete photo
                          final _product =
                              await db.productsDao.getProduct(product.id);
                          await GallerySaver.deleteImage(_product.photo);

                          await db.productsDao.omit(
                            ProductsCompanion(
                              id: d.Value(product.id),
                            ),
                          );

                          navigator.pop();
                        },
                      ),
                    ],
                    actionsPadding: const EdgeInsets.all(8),
                  ),
                );
              },
              onTap: () {
                navigator.pushNamed(
                  AppRouter.productView,
                  arguments: {'id': product.id},
                );
              },
              borderRadius: _borderRadius,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        top: 24.0,
                        right: 16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "₱ ${_f.format(product.activePrice)}",
                            style: theme.textTheme.bodyText1?.copyWith(
                              color: AppColor.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${_f.format(product.activeQuantity)} pc/s",
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColor.black.withOpacity(.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 8.0,
                        bottom: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyText2,
                            ),
                          ),
                          IconButton(
                            color: AppColor.red,
                            iconSize: 24.0,
                            splashRadius: 24.0,
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
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: -24,
          child: Container(
            height: MediaQuery.of(context).size.height / 10,
            width: MediaQuery.of(context).size.width / 5,
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: _borderRadius,
              border: Border.all(
                color: AppColor.red.withOpacity(.5),
              ),
            ),
            child: ClipRRect(
              borderRadius: _borderRadius,
              child: SizedBox.fromSize(
                size: Size.fromRadius(40.0),
                child: Material(
                  child: InkWell(
                    onTap: () async {
                      await showImageViewer(
                        context,
                        _image.image,
                        immersive: false,
                        useSafeArea: true,
                        backgroundColor: AppColor.red,
                      );
                    },
                    child: _image,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future _showFilterDialog({
    required AppDatabase db,
    required ThemeData theme,
    required BuildContext context,
    required GlobalKey<FormBuilderState> formKey,
  }) {
    final _radius = Radius.circular(4);
    final _mQ = MediaQuery.of(context);
    final _navigator = Navigator.of(context);

    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.white,
        title: Text(
          'Filters',
          style: theme.textTheme.headline6?.copyWith(
            color: AppColor.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Scrollbar(
          child: SingleChildScrollView(
            child: SizedBox(
              width: _mQ.size.width,
              child: FormBuilder(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: StreamBuilder2<double, List<Category>>(
                  streams: Tuple2(
                    db.productPricesDao.watchMaxRetail(),
                    db.categoriesDao.watchCategories(),
                  ),
                  builder: (context, snapshots) {
                    var _maxRetail = snapshots.item1.data;
                    final _categories = snapshots.item2.data ?? [];

                    if (_maxRetail != null) {
                      _maxRetail = (_maxRetail == 0.0) ? 1.0 : _maxRetail;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sizedBox(height: 16.0),
                          FormBuilderRangeSlider(
                            min: 1,
                            enabled: (_maxRetail == 0.0) ? false : true,
                            max: _maxRetail,
                            name: 'priceRange',
                            labels: RangeLabels('1', '${_maxRetail}'),
                            initialValue: RangeValues(1, _maxRetail),
                            decoration: _inputDecoration('Price Range (PHP)'),
                            numberFormat: NumberFormat("###,###.##", "en_US"),
                            textStyle: TextStyle(
                              fontSize: 12.0,
                              color: Colors.black45,
                            ),
                          ),
                          _sizedBox(height: 16.0),
                          FormBuilderSearchableDropdown(
                            name: 'categoryId',
                            showClearButton: true,
                            mode: ds.Mode.BOTTOM_SHEET,
                            decoration: InputDecoration(
                              labelText: 'Category',
                              alignLabelWithHint: true,
                              fillColor: AppColor.white,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.all(12.0),
                            ),
                            items: _categories.map((_category) {
                              return DropdownMenuItem(
                                value: _category.id,
                                child: Text(_category.name),
                              );
                            }).toList(),
                            itemAsString: (DropdownMenuItem<int>? menuItem) {
                              final _text = menuItem!.child as Text;
                              return _text.data.toString();
                            },
                            popupShape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey, width: .5),
                              borderRadius:
                                  BorderRadius.vertical(bottom: _radius),
                            ),
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                hintText: "Search a category..",
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
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                                borderRadius: BorderRadius.all(_radius),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: .5),
                                borderRadius:
                                    BorderRadius.vertical(top: _radius),
                              ),
                            ),
                          ),
                          _sizedBox(height: 16.0),
                        ],
                      );
                    }

                    return Center(child: CircularProgressIndicator());
                  },
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
              text: 'Filter',
              icon: Icons.filter_alt,
              onPressed: () async {
                final _fState = formKey.currentState!;
                if (_fState.validate()) {
                  final _priceRange =
                      _fState.fields['priceRange']!.value as RangeValues;

                  var _categoryId = _fState.fields['categoryId']?.value;
                  _categoryId =
                      (_categoryId != null) ? _categoryId.value : null;

                  setState(() {
                    _filters = {
                      'priceRange': _priceRange,
                      'categoryId': _categoryId
                    };
                  });

                  _navigator.pop();
                }
              },
            ),
          )
        ],
      ),
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
            _sizedBox(width: 8.0),
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

  Widget _sizedBox({double? height, double? width}) {
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
}
