import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/customMessage.dart';
import 'package:flutter_application_1/screens/createCustomMessage.dart';
import 'package:flutter_application_1/services/databaseServices.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/labledRadio.dart';

class CustomMessagesScreen extends StatefulWidget {
  const CustomMessagesScreen({super.key});

  @override
  State<CustomMessagesScreen> createState() => _CustomMessagesScreenState();
}

class _CustomMessagesScreenState extends State<CustomMessagesScreen> {
  final DatabaseService _databaseService = DatabaseService.instance;
  CustomMessages? selectedMessage;
  var _currSelectedMessage;

  Future<List<CustomMessages>> _fetchCustomMessages() async {
    return await _databaseService.getAllCustomMessages();
  }

  final ValueNotifier<int> _isRadioSelected = ValueNotifier<int>(-1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.pop(context, _currSelectedMessage),
        ),
        title: Text(
          AppLocalizations.of(context)!.customMessage,
          style: const TextStyle(fontSize: 15, fontFamily: 'Helvetica-Neue2'),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => CreateCustomMessage(isForUpdate: false),
                  ),
                );
                setState(() {});
                _isRadioSelected.value = -1;
              },
              child: Text("+ ${AppLocalizations.of(context)!.createNew}"))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              AppLocalizations.of(context)!
                  .slideTheCardLeftToEditDeleteTheMessage,
              style: TextStyle(fontSize: 12, color: Color(0xff999999)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<CustomMessages>>(
                  future: _fetchCustomMessages(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Text(AppLocalizations.of(context)!
                              .noCustomMessageAvailable));
                    } else {
                      List<CustomMessages> customMessagesList = snapshot.data!;
                      return ListView.builder(
                        itemCount: customMessagesList.length,
                        itemBuilder: (context, index) {
                          final customMessage = customMessagesList[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Slidable(
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                extentRatio: 0.3,
                                children: [
                                  SlidableAction(
                                    padding: const EdgeInsets.only(top: 4),
                                    onPressed: (context) async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) => CreateCustomMessage(
                                            isForUpdate: true,
                                            customMessages: customMessage,
                                          ),
                                        ),
                                      );

                                      setState(() {});
                                    },
                                    backgroundColor: Color(0xFF259164),
                                    foregroundColor: Colors.white,
                                    icon: Icons.edit,
                                    label: AppLocalizations.of(context)!.edit,
                                  ),
                                  SlidableAction(
                                    padding: const EdgeInsets.only(top: 4),
                                    onPressed: (context) async {
                                      final res = await _databaseService
                                          .deleteCustomMessage(
                                              customMessage.id);
                                      if (res) {
                                        setState(() {});
                                        _isRadioSelected.value = -1;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("Deleted!!"),
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                        ));
                                      }
                                    },
                                    backgroundColor: Color(0xFF259164),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: AppLocalizations.of(context)!.delete,
                                  ),
                                ],
                              ),
                              direction: Axis.horizontal,
                              enabled: true,
                              child: ValueListenableBuilder<int>(
                                valueListenable: _isRadioSelected,
                                builder: (context, selectedValue, _) {
                                  return LabledRadio(
                                    customMessage: customMessage,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    value: index,
                                    groupValue: selectedValue,
                                    onChanged: (int? newValue) {
                                      if (newValue != null && newValue != -1) {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (_) {
                                            return AlertDialog(
                                              titleTextStyle: const TextStyle(
                                                  fontFamily: "Helvetica-Neue",
                                                  fontSize: 20,
                                                  color: Colors.black),
                                              contentTextStyle: const TextStyle(
                                                  fontFamily: "Helvetica-Neue2",
                                                  color: Colors.grey),
                                              surfaceTintColor: Colors.white,
                                              title: const Text(
                                                  "Confirm Selection?"),
                                              content: const Text(
                                                  "Do you want to select the current messaage?"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      _isRadioSelected.value =
                                                          newValue;
                                                      _currSelectedMessage =
                                                          customMessage.message;
                                                      Navigator.pop(context);
                                                      Navigator.pop(context,
                                                          _currSelectedMessage);
                                                    },
                                                    child: const Text("Yes")),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("No")),
                                              ],
                                              elevation: 10,
                                            );
                                          },
                                        );
                                      } else if (newValue != null &&
                                          newValue == -1) {
                                        _isRadioSelected.value = -1;
                                        _currSelectedMessage = "";
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
