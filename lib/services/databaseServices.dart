import 'package:flutter_application_1/models/customMessage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter_application_1/models/message.dart';
import 'package:flutter_application_1/models/task.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._constructor();
  static Database? _db;
  DatabaseService._constructor();
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "direct_message.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
    CREATE TABLE history (
        id INTEGER PRIMARY KEY, 
        message TEXT, 
        date INTEGER, 
        number TEXT, 
        app TEXT
    );
''');

        db.execute('''
    CREATE TABLE customMessages (
        id INTEGER PRIMARY KEY, 
        title TEXT, 
        date INTEGER, 
        message TEXT
    );
''');
      },
    );
    return database;
  }

  Future<bool> addData(Message message) async {
    final db = await database;

    int id = await db.insert('history', {
      "message": message.text,
      "number": message.sentTo,
      "date": DateTime.now().millisecondsSinceEpoch,
      "app": message.app
    });
    return id != 0;
  }

  Future<bool> addCustomMessage(String title, String message) async {
    final db = await database;
    int id = await db.insert('customMessages', {
      'title': title,
      "date": DateTime.now().millisecondsSinceEpoch,
      'message': message,
    });
    return id != 0;
  }

  Future<List<Task>> getAllMessagesByNum(String phoneNumber) async {
    final db = await getDatabase();
    final data = await db.rawQuery('''
      SELECT * FROM history
      WHERE number = ?
    ''', [phoneNumber]);
    List<Task> tasks = data
        .map((e) => Task(
            text: e["message"] as String,
            date: e["date"] as int,
            number: e["number"] as String,
            app: e["app"] as String))
        .toList();
    return tasks;
  }

  Future<List<Task>> getTasks() async {
    final db = await getDatabase();
    final data = await db
        .rawQuery('''SELECT h1.id, h1.message, h1.date, h1.number, h1.app
                            FROM history h1
                            INNER JOIN (
                                SELECT number, MAX(date) AS max_date
                                FROM history
                                GROUP BY number
                            ) h2 ON h1.number = h2.number AND h1.date = h2.max_date;
''');
    List<Task> tasks = data
        .map((e) => Task(
            text: e["message"] as String,
            date: e["date"] as int,
            number: e["number"] as String,
            app: e['app'] as String))
        .toList();
    return tasks;
  }

  Future<bool> deleteHistory(String phNumber) async {
    final db = await database;
    final res =
        await db.delete('history', where: 'number=?', whereArgs: [phNumber]);

    return res != 0;
  }

  Future<List<CustomMessages>> getAllCustomMessages() async {
    final db = await getDatabase();
    final data = await db.rawQuery('''SELECT  *
                     FROM customMessages
                     ORDER BY date DESC
''');
    List<CustomMessages> messages = data
        .map(
          (e) => (CustomMessages(
              title: e['title'] as String,
              message: e['message'] as String,
              date: e['date'] as int,
              id: e['id'] as int)),
        )
        .toList();

    return messages;
  }

  Future<bool> updateCustomMessage(int id, String title, String message) async {
    final db = await database;
    final res = await db.update(
        'customMessages',
        {
          'title': title,
          "date": DateTime.now().millisecondsSinceEpoch,
          'message': message,
        },
        where: "id=?",
        whereArgs: [id]);
    return res != 0;
  }

  Future<bool> deleteCustomMessage(int id) async {
    final db = await database;
    final res =
        await db.delete('customMessages', where: 'id=?', whereArgs: [id]);

    return res != 0;
  }
}
