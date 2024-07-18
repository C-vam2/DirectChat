import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/localeProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_application_1/Tabs/composeTab.dart';
import 'package:flutter_application_1/Tabs/historyTab.dart';
import 'package:flutter_application_1/Tabs/settingsTab.dart';
import 'package:flutter_application_1/screens/onboardingScreens/onBoardingMain.dart';

class MyTabs extends ConsumerStatefulWidget {
  SharedPreferences prefs;
  MyTabs({
    Key? key,
    required this.prefs,
  }) : super(key: key);
  @override
  ConsumerState<MyTabs> createState() => _MyTabsState();
}

class _MyTabsState extends ConsumerState<MyTabs> {
  bool lang = false;
  // var initialValue = null;
  @override
  Widget build(BuildContext context) {
    String locale1 = "EN",
        locale2 = widget.prefs.getString('secondLocale')!.toUpperCase();
    lang = widget.prefs.getBool('lang') ?? false;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.black,
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          actions: [
            locale1 == locale2
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        locale1,
                        style: TextStyle(
                            color: lang == false ? Colors.black : Colors.grey,
                            fontWeight: lang == false ? FontWeight.bold : null),
                      ),
                      Transform.scale(
                        scale: lang == false ? 1 : 0.85,
                        child: Switch(
                          thumbColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            return Colors.white;
                          }),
                          activeTrackColor: Theme.of(context).primaryColor,
                          inactiveTrackColor: Theme.of(context).primaryColor,
                          value: lang,
                          onChanged: (value) => setState(() {
                            widget.prefs.setBool('lang', value);
                            ref
                                .read(localeProvider.notifier)
                                .toggleLocaleStatus();
                          }),
                        ),
                      ),
                      Text(
                        locale2,
                        style: TextStyle(
                            color: lang == true ? Colors.black : Colors.grey,
                            fontWeight: lang == true ? FontWeight.bold : null),
                      ),
                    ],
                  ),
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => OnboardingScreen(
                          isRevisit: true, prefs: widget.prefs)));
                },
                icon: Icon(
                  Icons.help_outline_rounded,
                  color: Theme.of(context).primaryColor,
                ))
          ],
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
                height: 20,
                width: 27,
                child: SvgPicture.asset(
                  'assets/logo.svg',
                  colorFilter: null,
                )),
          ),
          title: Text(
            AppLocalizations.of(context)!.directMessage,
            style: TextStyle(
                fontFamily: "Helvetica-Neue",
                fontSize: 16,
                color: Theme.of(context).primaryColor),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  AppLocalizations.of(context)!.compose,
                  style: TextStyle(
                      fontSize: 12, color: Theme.of(context).primaryColor),
                ),
              ),
              Tab(
                child: Text(
                  AppLocalizations.of(context)!.history,
                  style: TextStyle(
                      fontSize: 12, color: Theme.of(context).primaryColor),
                ),
              ),
              Tab(
                child: Text(
                  AppLocalizations.of(context)!.settings,
                  style: TextStyle(
                      fontSize: 12, color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          const Center(
            child: ComposeTab(),
          ),
          const Center(child: HistoryTab()),
          Center(
            child: SettingsTab(),
          ),
        ]),
      ),
    );
  }

  // Widget langSwitcher(bool lang) {

  // }
}
