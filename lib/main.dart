import 'dart:ffi';

import 'package:flutter_config/flutter_config.dart';
import 'package:sqlite3/open.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as fr;
import 'package:vendibase/provider/app_database_provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import 'package:vendibase/theme/app_theme.dart';
import 'package:vendibase/router/app_router.dart';

import 'package:vendibase/utils/app_notification.dart';

void _setupSqlCipher() {
  open.overrideFor(
    OperatingSystem.android,
    () => DynamicLibrary.open('libsqlcipher.so'),
  );
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await FlutterConfig.loadEnvVariables();
  await AppNotification.init();
  _setupSqlCipher();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppDatabaseProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  static const title = 'Vendibase';
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _initialRoute;

  Future<bool> _checkOnboard() async {
    final _prefs = await SharedPreferences.getInstance();
    final _isInitial = _prefs.getBool('isInitial') ?? true;
    await _prefs.setBool('isInitial', false);
    return _isInitial;
  }

  void _requestPermission() async {
    final permissions = [
      Permission.storage,
      Permission.manageExternalStorage,
      Permission.camera,
      Permission.photos,
      Permission.accessNotificationPolicy,
      Permission.notification
    ];

    bool f = true;
    var status = [];
    for (var permission in permissions) {
      final state = await permission.request();
      if (!f || state != PermissionStatus.granted) {
        f = false;
      }
      status.add(f);
    }

    FlutterNativeSplash.remove();
  }

  void _initTimezone() async {
    tz.initializeTimeZones();
    final timezone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezone));
  }

  void _setupRoute() async {
    final launchDetails = await AppNotification.getLaunchDetails();
    final didNotifLaunchApp = launchDetails?.didNotificationLaunchApp ?? false;

    _initialRoute =
        await _checkOnboard() ? AppRouter.onboardIndex : AppRouter.home;
    if (didNotifLaunchApp) {
      AppNotification.selectedPayload =
          launchDetails!.notificationResponse!.payload;
      _initialRoute = AppRouter.arrearView;
    }

    setState(() {}); // Force rebuild
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _initTimezone();
    _setupRoute();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialRoute != null) {
      return fr.ProviderScope(
        child: MaterialApp(
          title: MyApp.title,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appTheme.appTheme,
          initialRoute: _initialRoute,
          onGenerateRoute: AppRouter.generateRoute,
          supportedLocales: FormBuilderLocalizationsImpl.supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            FormBuilderLocalizations.delegate,
          ],
        ),
      );
    }

    return Center(child: CircularProgressIndicator());
  }
}
