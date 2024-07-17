import 'package:flutter/material.dart';
import 'package:flutter_application_1/Tabs/composeTab.dart';
import 'package:flutter_application_1/Tabs/historyTab.dart';
import 'package:flutter_application_1/Tabs/settingsTab.dart';
import 'package:flutter_application_1/screens/onboardingScreens/onBoardingMain.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.black,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => OnboardingScreen(isRevisit: true)));
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
}
