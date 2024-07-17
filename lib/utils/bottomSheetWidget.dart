import "package:flutter/material.dart";
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import "package:flutter_application_1/models/message.dart";
import "package:flutter_application_1/services/databaseServices.dart";
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageSender {
  final DatabaseService _databaseService = DatabaseService.instance;
  String enteredCode;
  String enteredNumber;
  String enteredMessage;

  MessageSender(
      {required this.enteredCode,
      required this.enteredNumber,
      required this.enteredMessage});

  String generateSmsUrl(String number, String body) {
    // Generate the SMS URL with the dynamic body content
    return 'sms:$number?body=${Uri.encodeComponent(body)}';
  }

  Future<bool> launchSMSUri() async {
    String phone = enteredCode + enteredNumber;
    final link = generateSmsUrl(phone, enteredMessage);
    // Convert the WhatsAppUnilink instance to a Uri.
    // The "launch" method is part of "url_launcher".
    final res = await launch(link);
    // final res2 = await Share.share(link);
    if (res) {
      final ans = await _databaseService
          .addData(Message(text: enteredMessage, sentTo: phone, app: "sms"));
      return ans;
    }
    return false;
  }

  Future<bool> launchWhatsAppUri() async {
    String phone = enteredCode + enteredNumber;
    final link = WhatsAppUnilink(
      phoneNumber: phone,
      text: enteredMessage,
    );
    // Convert the WhatsAppUnilink instance to a Uri.
    // The "launch" method is part of "url_launcher".
    final res = await launchUrl(link.asUri());
    if (res) {
      final ans = _databaseService.addData(
          Message(text: enteredMessage, sentTo: phone, app: "whatsapp"));
      return ans;
    }
    return false;
  }

  Future<dynamic> bottomSheet(BuildContext context) {
    return showModalBottomSheet(
        // elevation: 5,
        context: context,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5))),
            height: MediaQuery.of(context).size.height * 0.25,
            width: double.infinity,
            child: Column(children: [
              const SizedBox(
                height: 25,
              ),
              Container(
                padding: EdgeInsets.only(left: 4, right: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Theme.of(context).primaryColor,
                ),
                width: MediaQuery.of(context).size.width * 0.75,
                child: ElevatedButton(
                    onPressed: () async {
                      await launchWhatsAppUri();

                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      "WhatsApp",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 4, right: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Theme.of(context).primaryColor,
                ),
                width: MediaQuery.of(context).size.width * 0.75,
                child: ElevatedButton(
                    onPressed: () async {
                      await launchSMSUri();
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      "Messages",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )),
              ),
            ]),
          );
        });
  }
}
