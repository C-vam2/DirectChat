import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/onboardingScreens/onBoardingMain.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/splashScreen.dart';
import 'package:flutter/services.dart';

void main() async {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final onBoarding = prefs.getBool("onBoarding") ?? false;
  runApp(MyApp(
    onboarding: onBoarding,
  ));
}

class MyApp extends StatelessWidget {
  final bool onboarding;
  const MyApp({super.key, this.onboarding = false});

  Locale _resolveLocale(Locale locale, Iterable<Locale> supportedLocales) {
    Locale res = Locale("Dummy");
    for (var supportedLocale in supportedLocales) {
      if ((supportedLocale.languageCode == locale.languageCode)) {
        if (supportedLocale.countryCode != null &&
            supportedLocale.countryCode == locale.countryCode) {
          return supportedLocale;
        } else if (supportedLocale.countryCode == null) {
          res = supportedLocale;
        }
      }
    }

    if (res.languageCode != 'Dummy') {
      return res;
    }

    return const Locale('en');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(View.of(context).platformDispatcher.locale.languageCode,
          View.of(context).platformDispatcher.locale.countryCode),
      debugShowCheckedModeBanner: false,
      localeResolutionCallback: (locale, supportedLocales) {
        return _resolveLocale(locale!, supportedLocales);
      },
      theme: ThemeData(
        primaryColor: const Color(0xff259164),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          background: Colors.white,
          onBackground: Colors.white,
          primary: const Color(0xff259164),
        ),
        unselectedWidgetColor: const Color(0xff259164),
      ),

      home: SplashScreen(onBoarding: onboarding),
      // home: OnboardingScreen(),
    );
  }
}
