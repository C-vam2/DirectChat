import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Page2 extends StatefulWidget {
  Matrix4 matrix;
  Page2({super.key, required this.matrix});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
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
                width: MediaQuery.of(context).size.width * 1,
                child: Image.asset(
                  'assets/2_2.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              child: Transform(
                transform: widget.matrix,
                child: Container(
                  alignment: const Alignment(0, 1),
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Image.asset(
                    'assets/2_1.png',
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
          margin: EdgeInsets.only(left: 16, right: 16),
          alignment: Alignment.center,
          // padding: const EdgeInsets.only(
          // left: 20,
          // ),
          // height: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            AppLocalizations.of(context)!
                .didYouJustReceiveACallFromAnUnknownNumber,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 19, fontFamily: "Helvetica-Neue"),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.03,
        ),
        Container(
          margin: EdgeInsets.all(10),
          // color: Colors.red,
          padding: EdgeInsets.all(20),
          child: Text(
            AppLocalizations.of(context)!
                .copyTheNumberAndOpenMessagetheNumberWillBeDetectedAutomaticallyAndYouWillBeAbleToAccessTheWhatsappProfile,
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
