import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Page1 extends StatefulWidget {
  Matrix4 matrix;
  Page1({super.key, required this.matrix});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            Positioned(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.95,
                child: SvgPicture.asset(
                  'assets/1_1.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              child: Container(
                alignment: const Alignment(0, 1),
                height: MediaQuery.of(context).size.height * 0.4,
                child: Transform(
                  transform: widget.matrix,
                  child: Image.asset(
                    'assets/1_2.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.07,
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          // height: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            AppLocalizations.of(context)!
                .areYouAlsoTiredOfAddingAContactNumberToSendOnlyOneWhatsappMessage,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 19, fontFamily: "Helvetica-Neue"),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.03,
        ),
        Container(
          // color: Colors.red,
          // height: MediaQuery.of(context).size.width * 0.8,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(8),
          child: Text(
            AppLocalizations.of(context)!
                .ifYouUseDirectMessageYouDontNeedToSaveAnyUnnecessaryContactsYouCanSendMessageDirectlyWithoutSavingTheNumber,
            style: TextStyle(fontSize: 14, fontFamily: "Helvetica-Neue3"),
            textAlign: TextAlign.center,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
