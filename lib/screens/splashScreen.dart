import 'package:flutter/material.dart';
import 'package:flutter_application_1/clippers/topDiagonal.dart';
import 'package:flutter_application_1/screens/myTabsScreen.dart';
import 'package:flutter_application_1/screens/onboardingScreens/onBoardingMain.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../clippers/bottomDiagonal.dart';

class SplashScreen extends StatefulWidget {
  final bool onBoarding;
  SharedPreferences prefs;
  SplashScreen({super.key, required this.onBoarding, required this.prefs});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _moveToHomeScreen();
  }

  _moveToHomeScreen() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (cnx) => widget.onBoarding == false
            ? OnboardingScreen(
                prefs: widget.prefs,
              )
            : MyTabs(
                prefs: widget.prefs,
              )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: customClipper(),
    );
  }

  Widget customClipper() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Positioned(
            // height: 0,
            // bottom: 0,
            child: ClipPath(
              clipper: BottomDiagonal(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.43,
                padding: const EdgeInsets.all(20),
                color: const Color(0xff259164),
                alignment: Alignment.center,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/splashLogo.svg"),
                Text(
                  "Direct Message",
                  style: TextStyle(
                      fontFamily: "Helvetica-Neue",
                      fontSize: 28,
                      color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: ClipPath(
              clipper: TopDiagonal(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.43,
                padding: const EdgeInsets.all(20),
                color: const Color(0xff259164),
                alignment: Alignment.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
