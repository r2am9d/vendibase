import 'package:flutter/material.dart';
import 'package:drift_dev/api/migrations.dart';
import 'package:vendibase/database/app_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DatabaseState { none, valid, invalid }

final dbStateProvider = FutureProvider((ref) async {
  final dbFile = await AppDatabase.getDbFile();
  if (!await dbFile.exists()) return DatabaseState.none;

  final db = AppDatabase();
  try {
    await db.validateDatabaseSchema();
    return DatabaseState.valid;
  } catch (exception) {
    debugPrint(exception.toString());
    return DatabaseState.invalid;
  } finally {
    await db.close();
  }
});

class Debug extends ConsumerWidget {
  const Debug({
    required this.home,
    Key? key,
  }) : super(key: key);

  final Widget home;

  Future<void> openPage(BuildContext context) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => home,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbState = ref.watch(dbStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug'),
      ),
      body: dbState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Text(error.toString()),
        data: (state) => Stack(
          children: [
            SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      style: state == DatabaseState.invalid
                          ? ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                            )
                          : null,
                      onPressed: () => openPage(context),
                      child: state == DatabaseState.none
                          ? const Text('New Database')
                          : const Text('Keep Database'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: state != DatabaseState.none
                          ? () async {
                              await AppDatabase.deleteDatabase();
                              ref.refresh(dbStateProvider);
                            }
                          : null,
                      child: const Text('Delete Database'),
                    ),
                  ),
                ],
              ),
            ),
            if (state == DatabaseState.invalid)
              const MaterialBanner(
                content: Text('Database not valid'),
                leading: Icon(Icons.error, color: Colors.red),
                actions: <Widget>[
                  TextButton(
                    onPressed: null,
                    child: Text(''),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
