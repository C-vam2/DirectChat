import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_application_1/screens/customMessagesScreen.dart';
import 'package:flutter_application_1/services/databaseServices.dart';

import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import '../utils/bottomSheetWidget.dart';
import 'package:whatsapp/whatsapp.dart';
import 'package:clipboard/clipboard.dart';
import '../data/phoneNumLen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ComposeTab extends StatefulWidget {
  const ComposeTab({super.key});

  @override
  State<ComposeTab> createState() => _ComposeTabState();
}

class _ComposeTabState extends State<ComposeTab> {
  // var _numLen =
  Position? _currentLocation;
  final _formKey = GlobalKey<FormState>();
  final _numberFieldKey = GlobalKey<FormFieldState>();
  final _textFieldKey = GlobalKey<FormFieldState>();
  WhatsApp whatsapp = WhatsApp();
  TextEditingController? _messageController;
  TextEditingController? _numberController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _messageController = TextEditingController();
    _numberController = TextEditingController();
    FlutterClipboard.paste().then((value) {
      if (int.tryParse(value) != null) {
        setState(() {
          _numberController?.text = value;
        });
      } else {
        _messageController?.text = value;
      }
    });

    customMessageCount();
    // _getCurrentLocation();
  }

  void customMessageCount() async {
    var res = await _databaseService.getAllCustomMessages();
    setState(() {
      customMessageCnt = res.length;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageController?.dispose();
    _numberController?.dispose();
  }

  var enteredCode = "+91";
  var enteredNumber = "";
  var enteredMessage = "";
  var phNumLen = 10;
  var isLoading = false;
  String? mobileErrText;
  String? messageErrText;

  Future<void> _getCurrentLocation({isShared = false}) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, don't continue.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, don't continue.
      return Future.error('Location permissions are permanently denied.');
    }
    // print("shivam1");
    if (isShared) {
      setState(() {
        isLoading = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Getting your location..."),
        backgroundColor: Theme.of(context).primaryColor,
      ));
    }
    Position position = await Geolocator.getCurrentPosition();
    if (isShared) {
      setState(() {
        isLoading = false;
      });
    }
    // var addresses =
    //     await placemarkFromCoordinates(position.latitude, position.longitude);
    // var first = addresses.first;
    // debugPrint(first.country ?? "No country Found!!");
    // print("shivam2");
    setState(() {
      // print(position);
      _currentLocation = position;
    });
  }

  void _shareLocation(String phoneNumber) async {
    if (_currentLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Location not available')),
      );
      return;
    }

    final String locationUrl =
        'https://www.google.com/maps/search/?api=1&query=${_currentLocation!.latitude},${_currentLocation!.longitude}';

    final link = WhatsAppUnilink(
      phoneNumber: phoneNumber,
      text: locationUrl,
    );
    // Convert the WhatsAppUnilink instance to a Uri.
    // The "launch" method is part of "url_launcher".
    await launchUrl(link.asUri());
  }

  String _saveItem(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      return "success";
    }
    FocusScope.of(context).unfocus();
    // _formKey.currentState!.reset();
    return "failed";
  }

  var customMessageCnt = 0;
  final DatabaseService _databaseService = DatabaseService.instance;
  @override
  Widget build(BuildContext context) {
    // final res = View.of(context).platformDispatcher.locale.languageCode;
    // print(res ?? "shivam");

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.8,
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.countryCode,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xffF2F4F7),
                          ),
                          child: CountryCodePicker(
                            onChanged: (code) {
                              enteredCode = code.toString();
                              if (phoneNumberLengths.containsKey(enteredCode)) {
                                setState(() {
                                  phNumLen = phoneNumberLengths[enteredCode]!;
                                });
                              }
                            },
                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                            initialSelection: 'IN',

                            // optional. Shows only country name and flag
                            showCountryOnly: false,
                            // optional. Shows only country name and flag when popup is closed.
                            showOnlyCountryWhenClosed: false,
                            // optional. aligns the flag and the Text left
                            alignLeft: false,

                            flagWidth: 40,
                            dialogTextStyle: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.enterMobileNumber,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.55,
                          height: MediaQuery.of(context).size.height * 0.07,
                          decoration: BoxDecoration(
                              color: const Color(0xffF2F4F7),
                              borderRadius: BorderRadius.circular(5)),
                          child: TextFormField(
                            controller: _numberController,
                            key: _numberFieldKey,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color:
                                    _numberController?.text.length == phNumLen
                                        ? Colors.black
                                        : Colors.red),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().length != phNumLen ||
                                  int.parse(value) == null) {
                                return AppLocalizations.of(context)!
                                    .pleaseEnterTheValidPhoneNumber;
                              }
                              return null;
                            },
                            onSaved: (number) {
                              enteredNumber = number!;
                            },
                            onChanged: (value) {
                              setState(() {
                                if (_numberFieldKey.currentState!.hasError) {
                                  _numberFieldKey.currentState!.reset();
                                  _numberController!.text = value;
                                  // print(value);
                                }
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              // errorText: "Testinh",
                              errorStyle: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              // errorText: smobileErrText,
                              hintText: AppLocalizations.of(context)!.enter,
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                              filled: true,
                              fillColor: const Color(0xffF2F4F7),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    5), // Change this value to adjust the radius
                                borderSide:
                                    BorderSide.none, // Removes the border
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.typeMessage,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.135,
                      decoration: BoxDecoration(
                          color: const Color(0xffF2F4F7),
                          borderRadius: BorderRadius.circular(5)),
                      child: TextFormField(
                        controller: _messageController,
                        key: _textFieldKey,
                        style: const TextStyle(fontSize: 13),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().isEmpty) {
                            return "Enter valid message!!";
                          }
                          return null;
                        },
                        onSaved: (message) {
                          enteredMessage = message!;
                        },
                        onChanged: (value) {
                          setState(() {
                            if (_textFieldKey.currentState!.hasError) {
                              _textFieldKey.currentState!.reset();
                              _messageController!.text = value;
                              // print(value);
                            }
                          });
                        },

                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          hintText: AppLocalizations.of(context)!.typeMessage,
                          hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                          filled: true,
                          fillColor: const Color(0xffF2F4F7),
                          errorStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                5), // Change this value to adjust the radius
                            borderSide: BorderSide.none, // Removes the border
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        maxLines: null, // Allows text to wrap and expand
                        minLines: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment(0, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color(0xffF2F4F7),
                  ),
                  height: 23,
                  width: 23,
                  child: Text(
                    AppLocalizations.of(context)!.or,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    strokeWidth: 1,
                    color: Colors.grey,
                    child: ListTile(
                        leading: const Icon(
                          Icons.chat_bubble_outline_outlined,
                          size: 16,
                        ),
                        title: Row(
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                AppLocalizations.of(context)!
                                        .selectFromCustomMessage +
                                    " - ${customMessageCnt} " +
                                    AppLocalizations.of(context)!.msg,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 11,
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        trailing: SizedBox(
                          child: IconButton(
                            onPressed: () async {
                              final res = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => CustomMessagesScreen(),
                                ),
                              );
                              setState(() {
                                if (res != null && res != "") {
                                  _messageController!.text = res;
                                }
                                customMessageCount();
                              });
                            },
                            icon: Icon(
                              Icons.arrow_forward,
                              color: Theme.of(context).primaryColor,
                              size: 14,
                            ),
                          ),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    strokeWidth: 1,
                    color: Colors.grey,
                    child: ListTile(
                      onTap: () async {
                        if (_numberFieldKey.currentState!.validate()) {
                          _numberFieldKey.currentState!.save();
                          // _numberFieldKey.currentState!.reset();
                          FocusManager.instance.primaryFocus?.unfocus();
                          _getCurrentLocation(isShared: true)
                              .then((value) =>
                                  _shareLocation(enteredCode + enteredNumber))
                              .catchError((err) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(err),
                                duration: const Duration(milliseconds: 1500),
                                backgroundColor: const Color(0xff259164),
                              ),
                            );
                          });
                        }
                      },
                      leading: const Icon(
                        Icons.my_location_sharp,
                        size: 16,
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.shareMyCurrentLocation,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 12),
                        // softWrap: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  margin: const EdgeInsets.all(3),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: const Color.fromRGBO(37, 145, 100, 1)),
                  child: TextButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      var status = _saveItem(context);
                      if (status == "success") {
                        final MessageSender messageSender = MessageSender(
                            enteredCode: enteredCode,
                            enteredNumber: enteredNumber,
                            enteredMessage: enteredMessage);
                        messageSender.bottomSheet(context);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color(0xFF259164)), // Use primary color
                      foregroundColor: MaterialStateProperty.all(
                          Colors.white), // Set text color
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.sendMessage,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
