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

class PersonUpdate extends StatefulWidget {
  final args;
  const PersonUpdate({
    Key? key,
    this.args,
  }) : super(key: key);

  @override
  State<PersonUpdate> createState() => _PersonUpdateState();
}

class _PersonUpdateState extends State<PersonUpdate> {
  Person? _person;
  final uuid = Uuid();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _setVariables();
  }

  void _setVariables() async {
    final _db = context.read<AppDatabaseProvider>().database;
    final _args = jsonDecode(jsonEncode(widget.args));

    _person = await _db.personsDao.getPerson(_args['id']);

    setState(() {}); // Force rebuild
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _db = context.watch<AppDatabaseProvider>().database;
    final _navigator = Navigator.of(context);

    if (_person != null) {
      final _image = _person!.photo.contains('asset')
          ? AssetImage(_person!.photo)
          : FileImage(File(_person!.photo));

      return Scaffold(
        appBar: AppBar(
          title: Text('Person Update'),
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
                  _sizedBox(height: 16),
                  FormBuilderImagePicker(
                    name: 'photo',
                    maxImages: 1,
                    initialValue: [_image],
                    decoration: _inputDecoration('Photo'),
                    fit: BoxFit.fill,
                    validator: FormBuilderValidators.required(),
                  ),
                  _sizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'name',
                    initialValue: _person!.name,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration('Name'),
                    validator: FormBuilderValidators.required(),
                  ),
                  _sizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'contactNo',
                    initialValue: _person!.contactNo,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration('Contact No'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.maxLength(11),
                    ]),
                  ),
                  _sizedBox(height: 16),
                  FormBuilderTextField(
                    maxLines: 4,
                    name: 'remarks',
                    initialValue: _person!.remarks,
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
                    _formKey.currentState!.save();

                    final _photo = await _updateImage(
                      _formKey.currentState!.fields['photo']!.value,
                      _person!.photo,
                    );
                    final _name = _formKey.currentState!.fields['name']!.value;
                    final _contactNo =
                        _formKey.currentState!.fields['contactNo']!.value;
                    final _remarks =
                        _formKey.currentState!.fields['remarks']!.value;

                    await _db.personsDao.revise(
                      PersonsCompanion(
                        id: d.Value(_person!.id),
                        photo: d.Value(_photo),
                        name: d.Value(_name),
                        contactNo: d.Value(_contactNo),
                        remarks: d.Value(_remarks),
                      ),
                    );

                    _navigator.pop(context);
                  }
                },
              ),
            ],
          )
        ],
      );
    }

    return const Center(child: CircularProgressIndicator());
  }

  Future<String> _updateImage(List arr, String prevImage) async {
    const albumName = 'Vendibase/Person';

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

        // Delete prev image
        await GallerySaver.deleteImage(prevImage);
      }

      return imgPath;
    }
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
}
