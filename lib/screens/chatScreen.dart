import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/services/databaseServices.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter_application_1/utils/bottomSheetWidget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatScreen extends StatefulWidget {
  final String number;
  const ChatScreen({super.key, required this.number});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final DatabaseService _databaseService = DatabaseService.instance;
  final _formKey = GlobalKey<FormState>();
  late ScrollController _scrollController;
  List<Task> _messages = [];

  void initState() {
    super.initState();
    _fetchMessages();
    _scrollController = ScrollController();
  }

  Future<void> _fetchMessages() async {
    List<Task> messages =
        await _databaseService.getAllMessagesByNum(widget.number);
    setState(() {
      _messages = messages;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Widget _messageList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _messages.length,
      itemBuilder: ((context, index) {
        Task message = _messages[index];
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(message.date);
        String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
        return LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth = constraints.maxWidth;
            String text = message.text;
            TextSpan textSpan =
                TextSpan(text: text, style: TextStyle(fontSize: 14));
            TextPainter textPainter = TextPainter(
                text: textSpan,
                maxLines: null,
                textDirection: Directionality.of(context));
            textPainter.layout(
                maxWidth: maxWidth * 0.75); // Set a max width for the text

            double textWidth =
                textPainter.size.width + 50; // Add some padding to the width

            return ListTile(
              // tileColor: Colors.red,
              subtitle: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        message.app == "sms"
                            ? SvgPicture.asset(
                                "assets/material-message.svg",
                                color: Color(0xff4a7ec4),
                              )
                            : SvgPicture.asset(
                                'assets/logo-whatsapp.svg',
                                color: Color(0xff0cc142),
                              ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          " |  $formattedDate",
                          style: const TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  )),
              title: Align(
                alignment: Alignment.centerRight,
                child: ClipPath(
                  clipper: LowerNipMessageClipper(MessageType.send,
                      bubbleRadius: 5, sizeOfNip: 8),
                  child: Container(
                    width: textWidth,
                    padding: const EdgeInsets.all(15),
                    color: message.app == "sms"
                        ? const Color(0xffD6DFEA)
                        : const Color(0xffD7EAD6),
                    alignment: Alignment.topRight,
                    child: Text(
                      text,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xff333333),
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.15),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
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

  @override
  Widget build(BuildContext context) {
    String enteredMessage = "";
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        title: Text(
          widget.number,
          style: const TextStyle(fontSize: 14),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(child: _messageList()),
            Material(
              elevation: 15,
              shadowColor: Colors.black,
              child: Container(
                padding: const EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height * 0.135,
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.typeMessage,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        Container(
                          // padding: const EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.065,
                          decoration: BoxDecoration(
                              color: const Color(0xffF2F4F7),
                              borderRadius: BorderRadius.circular(5)),
                          child: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
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
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                  hintText:
                                      AppLocalizations.of(context)!.typeMessage,
                                  hintStyle: const TextStyle(
                                      color: Color(0xff999999), fontSize: 14),
                                  filled: true,
                                  fillColor: const Color(0xffF2F4F7),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        5), // Change this value to adjust the radius
                                    borderSide:
                                        BorderSide.none, // Removes the border
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                maxLines:
                                    null, // Allows text to wrap and expand
                                minLines: 1,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(5)),
                          height: MediaQuery.of(context).size.height * 0.065,
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: IconButton(
                              onPressed: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                var status = _saveItem(context);
                                if (status == "success") {
                                  String code = widget.number.substring(0, 3);
                                  String phoneNumber =
                                      widget.number.substring(3);
                                  final MessageSender messageSender =
                                      MessageSender(
                                          enteredCode: code,
                                          enteredNumber: phoneNumber,
                                          enteredMessage: enteredMessage);
                                  final res =
                                      await messageSender.bottomSheet(context);
                                  if (res) {
                                    List<Task> updatedMessages =
                                        await _databaseService
                                            .getAllMessagesByNum(widget.number);
                                    _formKey.currentState!.reset();
                                    setState(() {
                                      _messages = updatedMessages;
                                    });
                                  }
                                }
                              },
                              icon: const Icon(
                                Icons.send,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
