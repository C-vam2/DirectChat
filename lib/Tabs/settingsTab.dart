import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/settingsListItems.dart';
import 'package:flutter_application_1/screens/FAQPageScreen.dart';
import 'package:flutter_application_1/screens/privacy_policyScreen.dart';
import 'package:flutter_application_1/screens/termsAndConditionScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsTab extends StatefulWidget {
  SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  // TODO: implement context
  _shareApp() {
    Share.share(AppLocalizations.of(context)!
            .heyIAmUsingDirectmessageToSendMessagesWithoutSavingNumberGetTheAppHere +
        "https://apps.apple.com/us/app/direct-message-for-whatsapp/id1557291502 ");
  }

  _rateApp() {
    launchUrlString(
        "https://apps.apple.com/us/app/direct-message-for-whatsapp/id1557291502 ");
  }

  _sendMail() async {
    String email = Uri.encodeComponent("utlityapps@gmail.com");
    String subject = Uri.encodeComponent(
        AppLocalizations.of(context)!.emailFromDirectMessage);
    String body =
        Uri.encodeComponent(AppLocalizations.of(context)!.theAppVersionIs);
    // print(subject); //output: Hello%20Flutter
    Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
    await launchUrl(mail);
    // if (await launchUrl(mail)) {
    //   //email app opened
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(SnackBar(content: Text("Email Sent!")));
    // } else {
    //   //email app is not opened
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text("Failed to contact developer!")));
    // }
  }

  @override
  Widget build(BuildContext context) {
    final List<SettingsListItem> itemList = [
      SettingsListItem(
          icon: Icons.mail,
          title: AppLocalizations.of(context)!.contactUs,
          function: _sendMail),
      SettingsListItem(
          icon: Icons.star,
          title: AppLocalizations.of(context)!.rateApp,
          function: _rateApp),
      SettingsListItem(
          icon: Icons.share,
          title: AppLocalizations.of(context)!.shareThisApp,
          function: _shareApp),
      SettingsListItem(
          icon: Icons.wechat,
          title: AppLocalizations.of(context)!.faq,
          widget: FAQPage()),
      SettingsListItem(
          icon: Icons.privacy_tip_rounded,
          title: AppLocalizations.of(context)!.privacyPolicy,
          widget: PrivacyPolicyScreen()),
      SettingsListItem(
          icon: Icons.document_scanner_sharp,
          title: AppLocalizations.of(context)!.termsAndCondition,
          widget: TermsAndConditionScreen()),
    ];
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                dense: true,
                onTap: () {
                  if (itemList[index].widget != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => itemList[index].widget!));
                  } else if (itemList[index].function != null) {
                    itemList[index].function!();
                  }
                },
                leading: Icon(itemList[index].icon),
                title: Text(
                  itemList[index].title,
                  style: const TextStyle(
                      fontSize: 14, fontFamily: "Helvetica-Neue2"),
                ),
              ),
              const Divider(
                thickness: 0.3,
                color: Colors.grey,
                indent: 20,
                endIndent: 20,
              )
            ],
          );
        },
      ),
    );
  }
}
