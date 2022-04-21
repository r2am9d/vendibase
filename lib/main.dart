import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as fr;
import 'package:vendibase/provider/app_database_provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:vendibase/home.dart';
import 'package:vendibase/utils/debug.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:vendibase/router/app_router.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => AppDatabaseProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  static const title = 'Vendibase';
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void _requestPermission() async {
    final permissions = [
      Permission.storage,
      Permission.manageExternalStorage,
      Permission.camera,
      Permission.photos,
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

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return fr.ProviderScope(
      child: MaterialApp(
        title: MyApp.title,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appTheme.appTheme,
        initialRoute: AppRouter.home,
        onGenerateRoute: AppRouter.generateRoute,
        supportedLocales: const [
          Locale('de'),
          Locale('en'),
          Locale('es'),
          Locale('fr'),
          Locale('it'),
          Locale('lo'),
          Locale('uk'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          FormBuilderLocalizations.delegate,
        ],
        home: kReleaseMode ? const Home() : const Debug(home: Home()),
      ),
    );
  }
}