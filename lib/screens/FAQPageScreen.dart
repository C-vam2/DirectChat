import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/FAQItem.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FAQPage extends StatelessWidget {
  FAQPage({super.key});
  final items = [
    FAQItem(
        question: "What is this app for?",
        answer:
            "This app is used to send whatsapp messages or text messages without saving the contact"),
    FAQItem(
        question: "What details do I have to fill for sending a message?",
        answer:
            "All you need to do is just enter the number with required country code and type the message to send the message"),
    FAQItem(
        question: "What is Custom Message",
        answer:
            "Users can save a custom message for their future purpose. All they have to do is add a title and a text and then save the message.")
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.white,
        title: Text(AppLocalizations.of(context)!.faq),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            height: 80,
            child: Text(
              "Top Queries",
              style: TextStyle(fontSize: 25),
            ),
          ),
          Expanded(
            child: Container(
                padding: EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: const Color(0xffF5F5F5),
                      surfaceTintColor: Colors.white,
                      child: ExpansionTile(
                        backgroundColor: const Color(0xffF5F5F5),
                        title: Text(
                          items[index].question,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Helvetica-Neue2"),
                        ),
                        children: <Widget>[
                          ListTile(
                              title: Text(
                            items[index].answer,
                            style: TextStyle(fontFamily: "Helvetica-Neue2"),
                          )),
                        ],
                      ),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}
