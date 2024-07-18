import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/localeProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/splashScreen.dart';
import 'package:flutter/services.dart';

void main() async {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final onBoarding = prefs.getBool("onBoarding") ?? false;
  runApp(ProviderScope(child: MyApp(onboarding: onBoarding, prefs: prefs)));
}

class MyApp extends ConsumerStatefulWidget {
  final bool onboarding;
  final SharedPreferences prefs;
  const MyApp({super.key, this.onboarding = false, required this.prefs});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  Locale _resolveLocale(
      Locale locale, Iterable<Locale> supportedLocales, bool lang) {
    // print(lang);
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
      widget.prefs.setString('secondLocale', res.languageCode);
      if (widget.prefs.containsKey('lang')) {
        if (widget.prefs.getBool('lang') == false) {
          return const Locale('en');
        } else {
          return res;
        }
      } else {
        return const Locale('en');
      }
    }

    widget.prefs.setString('secondLocale', 'en');
    if (widget.prefs.containsKey('lang')) {
      if (widget.prefs.getBool('lang')!) {
        return Locale(widget.prefs.getString('secondLocale')!);
      }
    }

    return const Locale('en');
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(localeProvider);
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(View.of(context).platformDispatcher.locale.languageCode,
          View.of(context).platformDispatcher.locale.countryCode),
      debugShowCheckedModeBanner: false,
      localeResolutionCallback: (locale, supportedLocales) {
        return _resolveLocale(locale!, supportedLocales, lang);
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

      home: SplashScreen(onBoarding: widget.onboarding, prefs: widget.prefs),
      // home: OnboardingScreen(),
    );
  }
}
