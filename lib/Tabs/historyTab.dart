import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/screens/chatScreen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../services/databaseServices.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  final DatabaseService _databaseService = DatabaseService.instance;

  Future<List<Task>> _fetchTasks() async {
    return await _databaseService.getTasks();
  }

  Widget _messageList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: FutureBuilder(
          future: _fetchTasks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child:
                      Text(AppLocalizations.of(context)!.noHistoryAvailable));
            } else {
              return ListView.builder(
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: ((context, index) {
                  Task message = snapshot.data![index];
                  return Column(
                    children: [
                      Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          extentRatio: 0.3,
                          children: [
                            SlidableAction(
                              padding: const EdgeInsets.only(top: 4),
                              onPressed: (context) async {
                                final res = await _databaseService
                                    .deleteHistory(message.number);
                                if (res) {
                                  setState(() {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("Deleted!!"),
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                    ));
                                  });
                                }
                              },
                              backgroundColor: Color(0xFF259164),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: AppLocalizations.of(context)!.delete,
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            message.number,
                            style: const TextStyle(
                                color: Color(0xff333333),
                                fontFamily: "Helvetica-Neue2",
                                fontSize: 14),
                          ),
                          subtitle: Text(
                            message.text,
                            // maxLines: 1,
                            // overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                                color: Color(0xff999999),
                                fontFamily: "Helvetica-Neue2",
                                fontSize: 12),
                          ),
                          onTap: () async {
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) =>
                                    ChatScreen(number: message.number),
                              ),
                            );
                            if (true) {
                              setState(() {});
                            }
                          },
                        ),
                      ),
                      const Divider(
                        thickness: 0.3,
                        color: Colors.grey,
                        indent: 20,
                        endIndent: 20,
                      )
                    ],
                  );
                }),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "Slide the card left to delete chat history.",
              style: TextStyle(fontSize: 12, color: Color(0xff999999)),
            ),
          ),
          _messageList(),
        ],
      ),
    );
  }
}
