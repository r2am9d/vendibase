import 'dart:io';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:vendibase/router/app_router.dart';
import 'package:vendibase/database/app_database.dart';
import 'package:vendibase/provider/app_database_provider.dart';

class ProductIndex extends StatefulWidget {
  const ProductIndex({Key? key}) : super(key: key);

  @override
  State<ProductIndex> createState() => _ProductIndexState();
}

class _ProductIndexState extends State<ProductIndex> {
  String _searchTerm = '';
  bool _isSearching = false;

  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _db = context.read<AppDatabaseProvider>().database;
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

                  debugPrint(term);
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
            onPressed: () {
              // @TODO:
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
          stream: _db.productsDao.watchProducts(_searchTerm),
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
        : Image.file(File(_photo), fit: BoxFit.fill);

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
                child: _image,
              ),
            ),
          ),
        ),
      ],
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
}
