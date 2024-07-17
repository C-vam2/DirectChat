import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Page3 extends StatefulWidget {
  Matrix4 matrix;
  Page3({super.key, required this.matrix});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment,
      children: [
        Stack(
          children: [
            Positioned(
              left: 20,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 1,
                child: Image.asset(
                  'assets/3_2.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              // left: 10,
              child: Transform(
                transform: widget.matrix,
                child: Container(
                  alignment: const Alignment(0, 1),
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Image.asset(
                    'assets/3_1.png',
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
          margin: EdgeInsets.only(left: 16, right: 16),
          // padding: const EdgeInsets.only(
          // left: 20,
          // ),
          // height: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            AppLocalizations.of(context)!
                .doYouWantToSaveSomeImportantTextsAndDocumentsForEasyAccess,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 19, fontFamily: "Helvetica-Neue"),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.03,
        ),
        Container(
          padding: const EdgeInsets.all(8),
          // height: MediaQuery.of(context).size.width * 0.8,
          margin: EdgeInsets.all(10),
          child: Text(
            AppLocalizations.of(context)!
                .heresALittleSecretThereIsNoLimitWhatOneCanDoYouCanDoThatByTextingYourself,
            style: TextStyle(fontSize: 14, fontFamily: "Helvetica-Neue3"),
            textAlign: TextAlign.center,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
