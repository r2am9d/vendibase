import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:vendibase/database/app_database.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:vendibase/provider/app_database_provider.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class EarningIndex extends StatefulWidget {
  const EarningIndex({Key? key}) : super(key: key);

  @override
  State<EarningIndex> createState() => _EarningIndexState();
}

class _EarningIndexState extends State<EarningIndex> {
  bool _isVisible = true;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _db = context.watch<AppDatabaseProvider>().database;
    final _navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Earnings'),
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
        child: StreamBuilder<List<Earning>>(
          stream: _db.earningsDao.all(),
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
              List<Earning> _earnings = snapshot.data!;

              _widget = Scrollbar(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _earnings.length,
                  itemBuilder: (context, index) {
                    return _buildListTile(
                      earning: _earnings[index],
                      db: _db,
                      theme: _theme,
                      context: context,
                      navigator: _navigator,
                    );
                  },
                  separatorBuilder: (context, index) => _sizedBox(height: 16.0),
                ),
              );
            }
            return _widget;
          },
        ),
      ),
      floatingActionButton: _isVisible
          ? FloatingActionButton(
              tooltip: 'Add earning',
              heroTag: 'earning-index-fab',
              child: const Icon(Icons.add),
              onPressed: () async {
                await _showEarningDialog(
                  db: _db,
                  theme: _theme,
                  context: context,
                  formKey: _formKey,
                  navigator: _navigator,
                );
              },
            )
          : null,
    );
  }

  Future _showEarningDialog({
    Earning? earning,
    required AppDatabase db,
    required ThemeData theme,
    required BuildContext context,
    required NavigatorState navigator,
    required GlobalKey<FormBuilderState> formKey,
    ActionType actionType = ActionType.create,
  }) {
    final _amount = earning == null ? '' : earning.amount;
    final _text = actionType == ActionType.create ? 'Create' : 'Edit';
    final _icon = actionType == ActionType.create ? Icons.add : Icons.edit;

    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.white,
        title: Text("$_text earning", style: theme.textTheme.titleLarge),
        content: Scrollbar(
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: FormBuilder(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    _sizedBox(height: 16.0),
                    FormBuilderTextField(
                      name: 'amount',
                      keyboardType: TextInputType.number,
                      initialValue: _amount.toString(),
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
                      initialValue: earning?.remarks,
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
                    await db.earningsDao.make(
                      EarningsCompanion(
                        amount: d.Value(double.parse(_amount)),
                        remarks: d.Value(_remarks),
                      ),
                    );
                  } else {
                    final _id = earning!.id;
                    final _dateCreated = earning.dateCreated;

                    await db.earningsDao.revise(
                      EarningsCompanion(
                        id: d.Value(_id),
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

  Widget _buildListTile({
    required Earning earning,
    required AppDatabase db,
    required ThemeData theme,
    required BuildContext context,
    required NavigatorState navigator,
  }) {
    final _df = DateFormat("d MMM y", "en_PH");
    final _nf = NumberFormat("###,###.##", "en_US");

    final _amount = _nf.format(earning.amount);

    return Card(
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.attach_money,
                color: AppColor.red,
              ),
            ],
          ),
        ),
        title: Text(
          "₱ $_amount",
          style: theme.textTheme.bodyLarge,
        ),
        subtitle: Text(
          'on ${_df.format(earning.dateCreated)}',
          style: theme.textTheme.bodyMedium,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _iconButton(
              icon: Icons.edit,
              onPressed: () async {
                await _showEarningDialog(
                  db: db,
                  theme: theme,
                  context: context,
                  formKey: _formKey,
                  navigator: navigator,
                  earning: earning,
                  actionType: ActionType.update,
                );
              },
            ),
            _iconButton(
              icon: Icons.delete,
              color: AppColor.black,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: AppColor.red,
                    title: const Text('Confirm'),
                    content: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'Are you sure you want\nto delete "₱ $_amount" earning?',
                      ),
                    ),
                    actions: [
                      _outlineButton(
                        text: 'Cancel',
                        onPressed: () {
                          navigator.pop(context);
                        },
                      ),
                      _outlineButton(
                        text: 'Delete',
                        onPressed: () async {
                          await db.earningsDao.omit(
                            EarningsCompanion(
                              id: d.Value(earning.id),
                            ),
                          );

                          navigator.pop();
                        },
                      ),
                    ],
                    actionsPadding: const EdgeInsets.all(8.0),
                  ),
                );
              },
            ),
          ],
        ),
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
      style: ElevatedButton.styleFrom(backgroundColor: color),
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

  Widget _outlineButton({
    required String text,
    required void Function()? onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: AppColor.white)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppColor.white),
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
