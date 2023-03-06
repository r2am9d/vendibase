import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:flash/flash.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:external_path/external_path.dart';
import 'package:vendibase/database/app_database.dart';
import 'package:vendibase/provider/app_database_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BackupIndex extends StatefulWidget {
  const BackupIndex({Key? key}) : super(key: key);

  @override
  State<BackupIndex> createState() => _BackupIndexState();
}

class _BackupIndexState extends State<BackupIndex> {
  final uuid = Uuid();

  String? basePath;
  String? backupPath;
  List<FileSystemEntity>? files;

  void initDependencies() async {
    // Get refs
    backupPath = '/Vendibase/DB';
    basePath = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOCUMENTS,
    );

    // Check for directory
    final _fullPath = '${basePath}${backupPath}';
    final _doesExist = await Directory(_fullPath).exists();
    if (!_doesExist) new Directory(_fullPath).createSync(recursive: true);

    await initFiles();
  }

  Future<void> initFiles() async {
    // List files
    final _fullPath = '${basePath}${backupPath}';
    files = await Directory(_fullPath).listSync().toList()
      ..sort((l, r) => r.statSync().modified.compareTo(l.statSync().modified));

    setState(() {}); // Force rebuild
  }

  @override
  void initState() {
    super.initState();
    initDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _navigator = Navigator.of(context);
    final _df = DateFormat("d MMM y hh:mm a", "en_PH");
    final _dbNotifier = context.read<AppDatabaseProvider>();

    if (files != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Backups'),
        ),
        body: Scrollbar(
          child: files!.length >= 1
              ? ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: files!.length,
                  itemBuilder: (context, index) {
                    final _file = files![index] as File;

                    return FutureBuilder(
                      future: getFileSize(_file.path, 0),
                      builder: (context, snapshot) {
                        final _size = snapshot.data;
                        final _name = p.basename(_file.path);
                        final _dateCreated = _file.lastModifiedSync();

                        return Card(
                          child: ListTile(
                            leading: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.database,
                                    color: AppColor.red,
                                  ),
                                ],
                              ),
                            ),
                            title: Text(
                              _name,
                              style: _theme.textTheme.bodyLarge,
                            ),
                            subtitle: Text(
                              '$_size • ${_df.format(_dateCreated)}',
                              style: _theme.textTheme.bodyMedium,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _iconButton(
                                  icon: Icons.restore,
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        backgroundColor: AppColor.red,
                                        title: const Text('Confirm'),
                                        content: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            'Are you sure you want\nto restore this backup?',
                                          ),
                                        ),
                                        actions: [
                                          _outlineButton(
                                            text: 'Cancel',
                                            onPressed: () {
                                              _navigator.pop(context);
                                            },
                                          ),
                                          _outlineButton(
                                            text: 'Restore',
                                            onPressed: () async {
                                              // Get refs
                                              final _dbFile =
                                                  await AppDatabase.getDbFile();

                                              // Restore to current active db
                                              _dbNotifier.close();
                                              await File(_dbFile.path)
                                                  .writeAsBytes(
                                                await File(_file.path)
                                                    .readAsBytes(),
                                                flush: true,
                                              );
                                              _dbNotifier.reOpen();

                                              // Pop
                                              _navigator.pop(context);

                                              // Show flash
                                              await _showFlash(
                                                content:
                                                    'Database restore complete',
                                                theme: _theme,
                                              );
                                            },
                                          ),
                                        ],
                                        actionsPadding: const EdgeInsets.all(8),
                                      ),
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            'Are you sure you want\nto delete this backup?',
                                          ),
                                        ),
                                        actions: [
                                          _outlineButton(
                                            text: 'Cancel',
                                            onPressed: () {
                                              _navigator.pop(context);
                                            },
                                          ),
                                          _outlineButton(
                                            text: 'Delete',
                                            onPressed: () async {
                                              await _file.delete();

                                              // Re-render
                                              await initFiles();

                                              _navigator.pop(context);
                                            },
                                          ),
                                        ],
                                        actionsPadding: const EdgeInsets.all(8),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  separatorBuilder: (context, index) => _sizedBox(height: 16.0),
                )
              : Center(child: Text('No available backup.')),
        ),
        persistentFooterButtons: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  // Get refs
                  final _uid = uuid.v4().split('-')[0];
                  final _dbFile = await AppDatabase.getDbFile();
                  final _backupName = 'vendibase_${_uid}';
                  final _dbFolder = await getApplicationDocumentsDirectory();
                  final _parentPath = _dbFolder.parent.path.toString();
                  final _dbBackup = File(p.join(
                    _parentPath,
                    'databases/$_backupName.sqlite',
                  ));

                  // Save to internal
                  _dbNotifier.close();
                  await _dbBackup.writeAsBytes(
                    await _dbFile.readAsBytes(),
                    flush: true,
                  );
                  _dbNotifier.reOpen();

                  // Save to external
                  await GallerySaver.saveFile(
                    _dbBackup.path,
                    fileName: _backupName,
                    albumName: 'Vendibase/DB',
                  );

                  // Delete from internal
                  _dbBackup.delete();

                  // Re-render
                  await initFiles();

                  // Show flash
                  await _showFlash(
                    content: 'Database backup complete',
                    theme: _theme,
                  );
                },
                child: Row(
                  children: [
                    const Text('Backup DB'),
                    _sizedBox(width: 8.0),
                    const Icon(Icons.download, size: 16.0),
                  ],
                ),
              )
            ],
          )
        ],
      );
    }

    return Center(child: CircularProgressIndicator());
  }

  Future _showFlash({
    required String content,
    required ThemeData theme,
  }) {
    return showFlash(
      context: context,
      duration: Duration(seconds: 3),
      builder: (_, controller) {
        return Flash(
          controller: controller,
          margin: EdgeInsets.zero,
          behavior: FlashBehavior.fixed,
          position: FlashPosition.bottom,
          boxShadows: kElevationToShadow[8],
          backgroundColor: AppColor.white,
          onTap: () => controller.dismiss(),
          forwardAnimationCurve: Curves.easeInCirc,
          reverseAnimationCurve: Curves.bounceIn,
          child: DefaultTextStyle(
            style: TextStyle(color: AppColor.red),
            child: FlashBar(
              padding: const EdgeInsets.all(32.0),
              title: Text(
                'Success',
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                content,
                style: theme.textTheme.bodyMedium,
              ),
              indicatorColor: AppColor.green,
              icon: Icon(
                Icons.check_circle_outlined,
                size: 48.0,
                color: AppColor.green,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<String> getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
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
