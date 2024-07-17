import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Page4 extends StatefulWidget {
  Matrix4 matrix;
  Page4({super.key, required this.matrix});

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
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
                  'assets/4_2.png',
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
                    'assets/4_1.png',
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
          margin: EdgeInsets.only(left: 10, right: 10),
          // padding: const EdgeInsets.only(
          // left: 20,
          // ),
          // height: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            AppLocalizations.of(context)!
                .sellerOrBuyerHowDoYouSendYourBankDetailsToReceivePayments,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 19, fontFamily: "Helvetica-Neue"),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.03,
        ),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          padding: EdgeInsets.all(8),
          // height: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            AppLocalizations.of(context)!
                .withTheTemplateMessageFeatureYouCanAddYourFrequentlyUsedCompanyInformationAddressProductDescriptionOrBankAccountInformationAsQuickMessagesAndSendThemToYourCustomersWithOneClickWhenYouBuyOrSellSomethingYouCanSaveTime,
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
