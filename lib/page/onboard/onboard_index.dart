import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:vendibase/theme/app_theme.dart';
import 'package:vendibase/router/app_router.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardIndex extends StatefulWidget {
  const OnboardIndex({Key? key}) : super(key: key);

  @override
  State<OnboardIndex> createState() => _OnboardIndexState();
}

class _OnboardIndexState extends State<OnboardIndex> {
  final _introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(BuildContext context) async {
    await Navigator.of(context).pushReplacementNamed(AppRouter.home);
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Image.asset(
        '$assetName',
        width: width,
      ),
    );
  }

  Widget _buildTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Text(
        title,
        style: theme.textTheme.headlineMedium?.copyWith(
          color: AppColor.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSubTitle(String subtitle, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Text(subtitle, style: theme.textTheme.bodyLarge),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _mQ = MediaQuery.of(context);
    final _pageDecoration = PageDecoration(
      pageColor: AppColor.white,
      bodyTextStyle: TextStyle(fontSize: 19.0),
      bodyAlignment: Alignment.center,
      imagePadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      bodyPadding: EdgeInsets.zero,
      imageFlex: 0,
      bodyFlex: 1,
    );

    return SafeArea(
      child: IntroductionScreen(
        key: _introKey,
        globalBackgroundColor: AppColor.white,
        pages: [
          PageViewModel(
            image: const SizedBox(),
            titleWidget: const SizedBox(),
            bodyWidget: Container(
              height: _mQ.size.height - 128,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildImage('assets/images/vendarr-cart.png'),
                  _buildTitle('Definitive storage', _theme),
                  _buildSubTitle(
                      'Storehouse for your products and stuff!', _theme),
                ],
              ),
            ),
            decoration: _pageDecoration,
          ),
          PageViewModel(
            image: const SizedBox(),
            titleWidget: const SizedBox(),
            bodyWidget: Container(
              height: _mQ.size.height - 128,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildImage('assets/images/vendarr-phone.png'),
                  _buildTitle('Works Offline', _theme),
                  _buildSubTitle('No connection? No problem!', _theme),
                ],
              ),
            ),
            decoration: _pageDecoration,
          ),
          PageViewModel(
            image: const SizedBox(),
            titleWidget: const SizedBox(),
            bodyWidget: Container(
              height: _mQ.size.height - 128,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildImage('assets/images/vendarr-money.png'),
                  _buildTitle('Monitor Earnings', _theme),
                  _buildSubTitle('Tracking profit as easy as it gets!', _theme),
                ],
              ),
            ),
            decoration: _pageDecoration,
          ),
        ],
        onDone: () => _onIntroEnd(context),
        // onSkip: () => _onIntroEnd(context),
        showSkipButton: true,
        skipOrBackFlex: 0,
        nextFlex: 0,
        showBackButton: false,
        back: const Icon(Icons.arrow_back),
        skip: Text(
          'Skip',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColor.red,
          ),
        ),
        next: Icon(
          Icons.arrow_forward,
          color: AppColor.red,
        ),
        done: Text(
          'Done',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColor.white,
          ),
        ),
        doneStyle: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColor.red),
        ),
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: const EdgeInsets.all(16.0),
        controlsPadding: kIsWeb
            ? const EdgeInsets.all(12.0)
            : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        dotsDecorator: DotsDecorator(
          size: Size(10.0, 10.0),
          color: AppColor.gray,
          activeColor: AppColor.red,
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        dotsContainerDecorator: ShapeDecoration(
          color: AppColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
    );
  }
}
