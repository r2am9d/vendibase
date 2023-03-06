import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cross_file/cross_file.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:vendibase/router/app_router.dart';
import 'package:vendibase/database/app_database.dart';
import 'package:vendibase/provider/app_database_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

class ProductCreate extends StatefulWidget {
  const ProductCreate({Key? key}) : super(key: key);

  @override
  State<ProductCreate> createState() => _ProductCreateState();
}

class _ProductCreateState extends State<ProductCreate> {
  final uuid = Uuid();
  List<Unit>? _units;
  List<Category>? _categories;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _setVaraibles();
  }

  void _setVaraibles() async {
    final _db = context.read<AppDatabaseProvider>().database;

    _units = await _db.unitsDao.getUnits();
    _categories = await _db.categoriesDao.getCategories();

    setState(() {}); // Force rebuild
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _radius = Radius.circular(4);
    final _db = context.watch<AppDatabaseProvider>().database;
    final _navigator = Navigator.of(context);

    if (_units != null && _categories != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Product Create'),
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
                    style: _theme.textTheme.titleLarge?.copyWith(
                      color: AppColor.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _sizedBox(height: 32),
                  FormBuilderImagePicker(
                    name: 'photo',
                    maxImages: 1,
                    initialValue: const [
                      AssetImage('assets/images/basket.png')
                    ],
                    decoration: _inputDecoration('Photo'),
                    fit: BoxFit.fill,
                    validator: FormBuilderValidators.required(),
                  ),
                  _sizedBox(height: 16),
                  FormBuilderSearchableDropdown<DropdownMenuItem>(
                    name: 'categoryId',
                    clearButtonProps: ClearButtonProps(isVisible: true),
                    compareFn: (item, selectedItem) =>
                        item.value == selectedItem.value,
                    popupProps: PopupProps.modalBottomSheet(
                      showSearchBox: true,
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
                    ),
                    decoration: InputDecoration(
                      labelText: 'Category',
                      alignLabelWithHint: true,
                      fillColor: AppColor.white,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.all(12.0),
                    ),
                    items: _categories!.map((_category) {
                      return DropdownMenuItem(
                        value: _category.id,
                        child: Text(_category.name),
                      );
                    }).toList(),
                    // itemAsString: (DropdownMenuItem<int>? menuItem) {
                    //   final _text = menuItem!.child as Text;
                    //   return _text.data.toString();
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
                    dropdownSearchTextStyle: TextStyle(color: AppColor.black),
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
                  ),
                  _sizedBox(height: 16),
                  FormBuilderSearchableDropdown<DropdownMenuItem>(
                    name: 'unitId',
                    compareFn: (item, selectedItem) =>
                        item.value == selectedItem.value,
                    clearButtonProps: ClearButtonProps(isVisible: true),
                    popupProps: PopupProps.modalBottomSheet(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          hintText: "Search a unit..",
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
                      labelText: 'Unit',
                      alignLabelWithHint: true,
                      fillColor: AppColor.white,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.all(12.0),
                    ),
                    items: _units!.map((_unit) {
                      return DropdownMenuItem(
                        value: _unit.id,
                        child: Text(_unit.name),
                      );
                    }).toList(),
                    // itemAsString: (DropdownMenuItem<int>? menuItem) {
                    //   final _text = menuItem!.child as Text;
                    //   return _text.data.toString();
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
                    dropdownSearchTextStyle: TextStyle(color: AppColor.black),
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
                  ),
                  _sizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'name',
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration('Name'),
                    validator: FormBuilderValidators.required(),
                  ),
                  _sizedBox(height: 16),
                  FormBuilderTextField(
                    maxLines: 4,
                    name: 'remarks',
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration('Remarks'),
                  ),
                  _sizedBox(height: 32),
                  Text(
                    'Purchase',
                    style: _theme.textTheme.titleLarge?.copyWith(
                      color: AppColor.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _sizedBox(height: 32),
                  FormBuilderTextField(
                    name: 'cost',
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration('Cost', true),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.min(1),
                    ]),
                  ),
                  _sizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'quantity',
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    decoration: _inputDecoration('Quantity'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.integer(),
                      FormBuilderValidators.min(1),
                    ]),
                  ),
                  _sizedBox(height: 32),
                  Text(
                    'Price',
                    style: _theme.textTheme.titleLarge?.copyWith(
                      color: AppColor.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _sizedBox(height: 32),
                  FormBuilderSwitch(
                    name: 'isActive',
                    title: Text('Is active'),
                    initialValue: true,
                    decoration: _inputDecoration('Is active'),
                  ),
                  _sizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'retail',
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    decoration: _inputDecoration('Retail', true),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
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
                    const Text('Create'),
                    _sizedBox(width: 8),
                    const Icon(Icons.add_shopping_cart, size: 16),
                  ],
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final _photo = await _saveImage(
                      _formKey.currentState!.fields['photo']!.value,
                    );

                    var _categoryId =
                        _formKey.currentState!.fields['categoryId']?.value;
                    _categoryId =
                        (_categoryId != null) ? _categoryId.value : null;

                    var _unitId =
                        _formKey.currentState!.fields['unitId']?.value;
                    _unitId = (_unitId != null) ? _unitId.value : null;

                    final _name = _formKey.currentState!.fields['name']!.value;
                    final _remarks =
                        _formKey.currentState!.fields['remarks']!.value;
                    final _productId = await _db.productsDao.make(
                      ProductsCompanion(
                        photo: d.Value(_photo),
                        categoryId: d.Value(_categoryId),
                        unitId: d.Value(_unitId),
                        name: d.Value(_name),
                        remarks: d.Value(_remarks),
                      ),
                    );

                    final _cost = _formKey.currentState!.fields['cost']!.value;
                    final _quantity =
                        _formKey.currentState!.fields['quantity']!.value;
                    await _db.productPurchasesDao.make(
                      ProductPurchasesCompanion(
                        productId: d.Value(_productId),
                        cost: d.Value(double.parse(_cost)),
                        quantity: d.Value(int.parse(_quantity)),
                      ),
                    );

                    final _isActive =
                        _formKey.currentState!.fields['isActive']!.value;
                    final _retail =
                        _formKey.currentState!.fields['retail']!.value;

                    await _db.productPricesDao.make(
                      ProductPricesCompanion(
                        productId: d.Value(_productId),
                        retail: d.Value(double.parse(_retail)),
                        isActive: d.Value(_isActive),
                      ),
                    );

                    await _navigator.pushReplacementNamed(
                      AppRouter.productView,
                      arguments: {'id': _productId},
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

  Future<String> _saveImage(List arr) async {
    const albumName = 'Vendibase/Product';
    const assetPath = 'assets/images/basket.png';

    if (arr.isEmpty) {
      return assetPath;
    } else {
      final param = arr[0];
      var imgPath = param is XFile ? param.path : assetPath;

      if (param is XFile) {
        final result = await GallerySaver.saveImage(
          imgPath,
          fileName: "image-${uuid.v4()}",
          albumName: albumName,
        );
        imgPath = result.path;
      }

      return imgPath;
    }
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
