import 'dart:io';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cross_file/cross_file.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:vendibase/database/app_database.dart';
import 'package:vendibase/provider/app_database_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

class ProductUpdate extends StatefulWidget {
  final args;
  const ProductUpdate({
    Key? key,
    this.args,
  }) : super(key: key);

  @override
  State<ProductUpdate> createState() => _ProductUpdateState();
}

class _ProductUpdateState extends State<ProductUpdate> {
  ProductWithDetails? _product;
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
    final _args = jsonDecode(jsonEncode(widget.args));

    _units = await _db.unitsDao.getUnits();
    _categories = await _db.categoriesDao.getCategories();
    _product = await _db.productsDao.getProduct(_args['id']);

    setState(() {}); // Force rebuild
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _radius = Radius.circular(4);
    final _db = context.watch<AppDatabaseProvider>().database;
    final _navigator = Navigator.of(context);

    if (_product != null && _units != null && _categories != null) {
      final _image = _product!.photo.contains('asset')
          ? AssetImage(_product!.photo)
          : FileImage(File(_product!.photo));

      return Scaffold(
        appBar: AppBar(
          title: Text('Product Update'),
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
                  FormBuilderImagePicker(
                    name: 'photo',
                    maxImages: 1,
                    initialValue: [_image],
                    decoration: _inputDecoration('Photo'),
                    fit: BoxFit.fill,
                    validator: FormBuilderValidators.required(),
                  ),
                  _sizedBox(height: 16.0),
                  if (_product!.categoryId == null ||
                      _product!.category == null)
                    FormBuilderSearchableDropdown<DropdownMenuItem>(
                      name: 'categoryId',
                      showClearButton: true,
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
                  if (_product!.categoryId != null &&
                      _product!.category != null)
                    FormBuilderSearchableDropdown<DropdownMenuItem>(
                      name: 'categoryId',
                      showClearButton: true,
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
                      initialValue: DropdownMenuItem(
                        value: _product!.categoryId!,
                        child: Text(_product!.category!),
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
                  _sizedBox(height: 16.0),
                  if (_product!.unitId == null || _product!.unit == null)
                    FormBuilderSearchableDropdown<DropdownMenuItem>(
                      name: 'unitId',
                      showClearButton: true,
                      compareFn: (item, selectedItem) =>
                        item.value == selectedItem.value,
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
                  if (_product!.unitId != null && _product!.unit != null)
                    FormBuilderSearchableDropdown<DropdownMenuItem>(
                      name: 'unitId',
                      showClearButton: true,
                      compareFn: (item, selectedItem) =>
                        item.value == selectedItem.value,
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
                      initialValue: DropdownMenuItem(
                        value: _product!.unitId!,
                        child: Text(_product!.unit!),
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
                  _sizedBox(height: 16.0),
                  FormBuilderTextField(
                    name: 'name',
                    initialValue: _product!.name,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration('Name'),
                    validator: FormBuilderValidators.required(),
                  ),
                  _sizedBox(height: 16.0),
                  FormBuilderTextField(
                    maxLines: 4,
                    name: 'remarks',
                    initialValue: _product!.remarks,
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

                    final _id = _product!.id;
                    final _photo = await _updateImage(
                      _fState.fields['photo']!.value,
                      _product!.photo,
                    );

                    var _categoryId =
                        _formKey.currentState!.fields['categoryId']?.value;
                    _categoryId =
                        (_categoryId != null) ? _categoryId.value : null;

                    var _unitId =
                        _formKey.currentState!.fields['unitId']?.value;
                    _unitId = (_unitId != null) ? _unitId.value : null;

                    final _name = _fState.fields['name']!.value;
                    final _remarks = _fState.fields['remarks']!.value;

                    final _isFavorite = _product!.isFavorite;
                    final _dateCreated = _product!.dateCreated;

                    await _db.productsDao.revise(
                      ProductsCompanion(
                        id: d.Value(_id),
                        photo: d.Value(_photo),
                        name: d.Value(_name),
                        categoryId: d.Value(_categoryId),
                        unitId: d.Value(_unitId),
                        remarks: d.Value(_remarks),
                        isFavorite: d.Value(_isFavorite),
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

  Future<String> _updateImage(List arr, String prevImage) async {
    const albumName = 'Vendibase/Product';

    if (arr.isEmpty) {
      return prevImage;
    } else {
      final param = arr[0];
      var imgPath = prevImage;

      if (param is XFile) {
        final result = await GallerySaver.saveImage(
          param.path,
          fileName: "image-${uuid.v4()}",
          albumName: albumName,
        );
        imgPath = result.path;

        // Delete the prev image
        await GallerySaver.deleteImage(prevImage);
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
