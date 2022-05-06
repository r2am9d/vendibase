import 'package:flutter/material.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:vendibase/router/app_router.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:vendibase/utils/app_notification_alt.dart';

class CodelabIndex extends StatefulWidget {
  const CodelabIndex({Key? key}) : super(key: key);

  @override
  State<CodelabIndex> createState() => _CodelabIndexState();
}

class _CodelabIndexState extends State<CodelabIndex> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Codelab'),
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
                FormBuilderTextField(
                  name: 'amount',
                  textInputAction: TextInputAction.next,
                  decoration: _inputDecoration('Amount'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                    FormBuilderValidators.numeric(context),
                    FormBuilderValidators.min(context, 1),
                  ]),
                ),
                _sizedBox(height: 16.0),
                FormBuilderTextField(
                  name: 'cost',
                  textInputAction: TextInputAction.next,
                  decoration: _inputDecoration('Cost'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                    FormBuilderValidators.numeric(context),
                    FormBuilderValidators.min(context, 1),

                    // Dependent validation: FormBuilderValidators.max
                    (value) {
                      final _fState = _formKey.currentState!;
                      final _cost = int.tryParse(value!);
                      final _amount =
                          int.tryParse(_fState.fields['amount']!.value)!;

                      if (_cost == null) return null;
                      if (_cost > _amount)
                        return 'Cost cannot be higher than Amount';
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
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Row(
                children: [
                  const Text('Save'),
                  _sizedBox(width: 8),
                  const Icon(Icons.save, size: 16),
                ],
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                }
              },
            ),
          ],
        )
      ],
      floatingActionButton: FloatingActionButton(
        tooltip: 'FAB',
        heroTag: 'codelab-index-fab',
        child: const Icon(Icons.add),
        onPressed: () async {
          await AppNotificationAlt.showNotification(
            title: 'This is a notification',
            body: 'Lorem ipsum dolor sit amet.',
            payload: {
              'id': '1',
              'route': AppRouter.productView,
              'notification_id': '${AppNotificationAlt.notificationId}',
            },
          );
        },
      ),
    );
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
