import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as d;
import 'package:provider/provider.dart';
import 'package:cross_file/cross_file.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:vendibase/router/app_router.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:vendibase/database/app_database.dart';
import 'package:vendibase/provider/app_database_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';

class PersonCreate extends StatefulWidget {
  const PersonCreate({Key? key}) : super(key: key);

  @override
  State<PersonCreate> createState() => _PersonCreateState();
}

class _PersonCreateState extends State<PersonCreate> {
  final uuid = Uuid();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _db = context.watch<AppDatabaseProvider>().database;
    final _navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Person Create'),
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
                _sizedBox(height: 16),
                FormBuilderImagePicker(
                  name: 'photo',
                  maxImages: 1,
                  initialValue: const [AssetImage('assets/images/man.png')],
                  decoration: _inputDecoration('Photo'),
                  fit: BoxFit.fill,
                  validator: FormBuilderValidators.required(),
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
                  name: 'contactNo',
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
                  _sizedBox(width: 8),
                  const Icon(Icons.add, size: 16),
                ],
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  final _photo = await _saveImage(
                    _formKey.currentState!.fields['photo']!.value,
                  );
                  final _name = _formKey.currentState!.fields['name']!.value;
                  final _contactNo =
                      _formKey.currentState!.fields['contactNo']!.value;
                  final _remarks =
                      _formKey.currentState!.fields['remarks']!.value;

                  final _id = await _db.personsDao.make(
                    PersonsCompanion(
                      photo: d.Value(_photo),
                      name: d.Value(_name),
                      contactNo: d.Value(_contactNo),
                      remarks: d.Value(_remarks),
                    ),
                  );

                  await _navigator.pushReplacementNamed(
                    AppRouter.personView,
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

  Future<String> _saveImage(List arr) async {
    const albumName = 'Vendibase/Person';
    const assetPath = 'assets/images/man.png';

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
