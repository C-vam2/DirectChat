import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/myTabsScreen.dart';
import 'package:flutter_application_1/screens/onboardingScreens/page1.dart';
import 'package:flutter_application_1/screens/onboardingScreens/page2.dart';
import 'package:flutter_application_1/screens/onboardingScreens/page3.dart';
import 'package:flutter_application_1/screens/onboardingScreens/page4.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  var isRevisit;
  OnboardingScreen({super.key, this.isRevisit = false});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  Matrix4 matrix = Matrix4.identity();
  double _scaleFactor = 0.3;
  var _currPageVal = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currPageVal = _controller.page!;
      });
      // print(_currPageVal);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  final List<Function(Matrix4)> _pageList = [
    (matrix) => Page1(matrix: matrix),
    (matrix) => Page2(matrix: matrix),
    (matrix) => Page3(matrix: matrix),
    (matrix) => Page4(matrix: matrix),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        TextButton(
            onPressed: () {
              _controller.animateToPage(3,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.linear);
            },
            child: Text(
              AppLocalizations.of(context)!.skip,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 12),
            ))
      ]),
      body: Stack(children: [
        PageView.builder(
          controller: _controller,
          physics: const BouncingScrollPhysics(),
          itemCount: _pageList.length,
          itemBuilder: (context, index) {
            // double _height = 230.0;

            if (index == _currPageVal.floor()) {
              var currScale = 1 - (_currPageVal - index) * (1 - _scaleFactor);
              // var currTrans = _height * (1 - currScale) / 2;
              matrix = Matrix4.diagonal3Values(1.0, currScale, 1.0);
              // ..setTranslationRaw(0, currTrans, 0);
            } else if (index == _currPageVal.floor() + 1) {
              var currScale = _scaleFactor +
                  (_currPageVal - index + 1) * (1 - _scaleFactor);
              // var currTrans = _height * (1 - currScale) / 2;
              matrix = Matrix4.diagonal3Values(1.0, currScale, 1.0);
              // ..setTranslationRaw(0, currTrans, 0);
            } else if (index == _currPageVal.floor() - 1) {
              var currScale = 1 - (_currPageVal - index) * (1 - _scaleFactor);
              // var currTrans = _height * (1 - currScale) / 2;
              matrix = Matrix4.diagonal3Values(1.0, currScale, 1.0);
              // ..setTranslationRaw(0, currTrans, 0);
            } else {
              var currScale = 0.8;
              matrix = Matrix4.diagonal3Values(1.0, currScale, 1.0);
              // ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 0);
            }

            return _pageList[index](matrix);
          },
        ),
        Container(
          alignment: const Alignment(0, 0.7),
          child: SmoothPageIndicator(
            controller: _controller,
            count: 4,
            effect: SlideEffect(
                dotWidth: 13.0,
                dotHeight: 13.0,
                paintStyle: PaintingStyle.fill,
                radius: 10,
                dotColor: Color(0xffBFEDDA),
                activeDotColor: Theme.of(context).primaryColor),
          ),
        ),
        Positioned(
          bottom: 30,
          left: 10,
          child: Container(
            // margin: const EdgeInsets.all(3),
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.07,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color.fromRGBO(37, 145, 100, 1)),
            child: TextButton(
              onPressed: () async {
                if (_currPageVal == 3) {
                  if (widget.isRevisit) {
                    Navigator.pop(context);
                    return;
                  }
                  final pres = await SharedPreferences.getInstance();
                  pres.setBool("onBoarding", true);
                  if (!mounted) return;
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (ctx) => MyTabs()));
                } else {
                  _controller.nextPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.linear);
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color(0xFF259164)), // Use primary color
                foregroundColor:
                    MaterialStateProperty.all(Colors.white), // Set text color
              ),
              child: Text(
                _currPageVal == 3
                    ? AppLocalizations.of(context)!.letsStart
                    : "Next",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
