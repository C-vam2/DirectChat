import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/customMessage.dart';
import 'package:flutter_application_1/services/databaseServices.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateCustomMessage extends StatefulWidget {
  final bool isForUpdate;
  final CustomMessages? customMessages;

  const CreateCustomMessage._(
      {super.key, required this.isForUpdate, this.customMessages});

  factory CreateCustomMessage(
      {required bool isForUpdate, CustomMessages? customMessages}) {
    if (isForUpdate && customMessages == null) {
      throw ArgumentError(
          'customMessages is required when isForUpdate is true');
    }
    return CreateCustomMessage._(
        isForUpdate: isForUpdate, customMessages: customMessages);
  }

  @override
  State<CreateCustomMessage> createState() => _CreateCustomMessageState();
}

class _CreateCustomMessageState extends State<CreateCustomMessage> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _databaseService = DatabaseService.instance;

  late TextEditingController _titleController;
  late TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.isForUpdate ? widget.customMessages?.title : '',
    );
    _messageController = TextEditingController(
      text: widget.isForUpdate ? widget.customMessages?.message : '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  var enteredTitle;
  var enteredMessage;
  Future<bool> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _formKey.currentState!.reset();
      FocusScope.of(context).unfocus();
      final res =
          await _databaseService.addCustomMessage(enteredTitle, enteredMessage);
      return res;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Title or Message is missing!!"),
      duration: Duration(milliseconds: 1500),
      backgroundColor: Color(0xff259164),
    ));
    return false;
  }

  Future<bool> _updateItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _formKey.currentState!.reset();
      FocusScope.of(context).unfocus();
      final res = await _databaseService.updateCustomMessage(
          widget.customMessages!.id, enteredTitle, enteredMessage);
      return res;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Title or Message is missing!!"),
      duration: Duration(milliseconds: 1500),
      backgroundColor: Color(0xff259164),
    ));
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          shadowColor: Colors.black,
          surfaceTintColor: Colors.white,
          title: Text(
            widget.isForUpdate
                ? AppLocalizations.of(context)!.edit
                : AppLocalizations.of(context)!.createCustomMessage,
            style: TextStyle(fontSize: 14, fontFamily: 'Helvetica-Neue2'),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.titleOfMessage,
                      style: TextStyle(
                          fontSize: 12, fontFamily: 'Helvetica-Neue2'),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Container(
                      // padding: const EdgeInsets.only(top: 20),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.065,
                      decoration: BoxDecoration(
                          color: const Color(0xffF2F4F7),
                          borderRadius: BorderRadius.circular(5)),
                      child: SingleChildScrollView(
                        child: TextFormField(
                          controller: _titleController,
                          style: const TextStyle(fontSize: 13),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().isEmpty) {
                              return "";
                            }
                            return null;
                          },
                          onSaved: (message) {
                            enteredTitle = message!;
                          },

                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.enter,
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 14),
                            filled: true,
                            fillColor: const Color(0xffF2F4F7),
                            errorStyle: TextStyle(
                                color: Theme.of(context).primaryColor),
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
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.typeMessage,
                          style: TextStyle(
                              fontSize: 12, fontFamily: 'Helvetica-Neue2'),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.125,
                          decoration: BoxDecoration(
                              color: const Color(0xffF2F4F7),
                              borderRadius: BorderRadius.circular(5)),
                          child: TextFormField(
                            controller: _messageController,
                            style: const TextStyle(fontSize: 13),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().isEmpty) {
                                return "";
                              }
                              return null;
                            },
                            onSaved: (message) {
                              enteredMessage = message!;
                            },

                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              hintText:
                                  AppLocalizations.of(context)!.typeMessage,
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                              filled: true,
                              fillColor: const Color(0xffF2F4F7),
                              errorStyle: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    5), // Change this value to adjust the radius
                                borderSide:
                                    BorderSide.none, // Removes the border
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            maxLines: null, // Allows text to wrap and expand
                            minLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  // margin: const EdgeInsets.all(3),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: const Color.fromRGBO(37, 145, 100, 1)),
                  child: TextButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      final result = widget.isForUpdate
                          ? await _updateItem()
                          : await _saveItem();
                      if (result) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(widget.isForUpdate
                                ? "Custom Message Edited Successfully!!"
                                : "Custom Message Created Successfully!!"),
                            duration: const Duration(milliseconds: 1500),
                            backgroundColor: const Color(0xff259164),
                          ),
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color(0xFF259164)), // Use primary color
                      foregroundColor: MaterialStateProperty.all(
                          Colors.white), // Set text color
                    ),
                    child: Text(
                      widget.isForUpdate
                          ? AppLocalizations.of(context)!.edit
                          : AppLocalizations.of(context)!.saveMessage,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
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
