import 'package:flutter/material.dart';
import 'package:vendibase/theme/app_theme.dart';

class ErrorIndex extends StatelessWidget {
  const ErrorIndex({Key? key}) : super(key: key);

  final text = 'Oops, something\'s\ngone wrong!';

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _mQ = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: _mQ.size.width,
          height: _mQ.size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/vendarr-error.png',
                fit: BoxFit.fitWidth,
                width: _mQ.size.width / 2,
              ),
              Text(
                text,
                style: _theme.textTheme.headline5?.copyWith(
                  color: AppColor.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
