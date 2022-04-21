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
  Product? _product;
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
    final _db = context.read<AppDatabaseProvider>().database;
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
                  _sizedBox(height: 16.0),
                  FormBuilderImagePicker(
                    name: 'photo',
                    maxImages: 1,
                    initialValue: [_image],
                    decoration: _inputDecoration('Photo'),
                    fit: BoxFit.fill,
                    validator: FormBuilderValidators.required(context),
                  ),
                  _sizedBox(height: 16.0),
                  FormBuilderDropdown(
                    name: 'categoryId',
                    allowClear: true,
                    initialValue: _product!.categoryId,
                    items: _categories!.map((_category) {
                      return DropdownMenuItem(
                        value: _category.id,
                        child: Text(_category.name),
                      );
                    }).toList(),
                    decoration: _inputDecoration('Category'),
                  ),
                  _sizedBox(height: 16.0),
                  FormBuilderDropdown(
                    name: 'unitId',
                    allowClear: true,
                    initialValue: _product!.unitId,
                    items: _units!.map((_unit) {
                      return DropdownMenuItem(
                        value: _unit.id,
                        child: Text(_unit.name),
                      );
                    }).toList(),
                    decoration: _inputDecoration('Unit'),
                  ),
                  _sizedBox(height: 16.0),
                  FormBuilderTextField(
                    name: 'name',
                    initialValue: _product!.name,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration('Name'),
                    validator: FormBuilderValidators.required(context),
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
                    final _categoryId = _fState.fields['categoryId']!.value;
                    final _unitId = _fState.fields['unitId']!.value;
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

  InputDecoration _inputDecoration(String placeholder) {
    return InputDecoration(
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
