import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

AppTheme appTheme = AppTheme();

class AppTheme with ChangeNotifier {
  static bool _isDarkTheme = false;
  ThemeMode get appTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'Montserrat',
      primaryColor: AppColor.white,
      scaffoldBackgroundColor: AppColor.white,
      appBarTheme: AppBarTheme(
        elevation: 1,
        backgroundColor: AppColor.white,
        foregroundColor: AppColor.red,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColor.black,
          statusBarIconBrightness: Brightness.light,
        ),
        actionsIconTheme: IconThemeData(color: AppColor.black),
        iconTheme: IconThemeData(color: AppColor.black),
        titleTextStyle: TextStyle(
          fontSize: 18,
          color: AppColor.red,
          fontWeight: FontWeight.w700,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: AppColor.red,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColor.black,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: AppColor.white,
        titleTextStyle: TextStyle(
          fontSize: 24,
          color: AppColor.white,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: TextStyle(
          fontSize: 18,
          color: AppColor.white,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(24),
          ),
        ),
      ),
      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: 96,
          letterSpacing: -1.5,
          color: AppColor.black,
        ),
        headline2: TextStyle(
          fontSize: 60,
          letterSpacing: -0.5,
          color: AppColor.black,
        ),
        headline3: TextStyle(
          fontSize: 48,
          letterSpacing: 0,
          color: AppColor.black,
        ),
        headline4: TextStyle(
          fontSize: 34,
          letterSpacing: 0.25,
          color: AppColor.black,
        ),
        headline5: TextStyle(
          fontSize: 24,
          letterSpacing: 0,
          color: AppColor.black,
        ),
        headline6: TextStyle(
          fontSize: 20,
          letterSpacing: 0.15,
          color: AppColor.black,
        ),
        bodyText1: TextStyle(
          fontSize: 16,
          letterSpacing: 0.5,
          color: AppColor.black,
        ),
        bodyText2: TextStyle(
          fontSize: 14,
          letterSpacing: 0.25,
          color: AppColor.black,
        ),
        subtitle1: TextStyle(
          fontSize: 16,
          letterSpacing: 0.15,
          color: AppColor.black,
        ),
        subtitle2: TextStyle(
          fontSize: 14,
          letterSpacing: 0.1,
          color: AppColor.black,
        ),
        button: TextStyle(
          fontSize: 14,
          letterSpacing: 0.75,
          color: AppColor.black,
        ),
        caption: TextStyle(
          fontSize: 12,
          letterSpacing: 0.4,
          color: AppColor.black,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData();
  }
}

class AppColor {
  static Color white = const Color(0xFFFFFFFF);
  static Color black = const Color(0xFF02040F);

  static Color red = const Color(0xFF930E4D);
  static Color darkRed = const Color(0xFF4A092E);
  static Color lightRed = const Color(0xFFDC136C);

  static Color red1 = const Color(0xFFA8201A);
  static Color green = const Color(0xFF009B72);
  static Color yellow = const Color(0xFFEC9A29);
}
