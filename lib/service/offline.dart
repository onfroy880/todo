import 'package:sqflite/sqflite.dart' as sql;

class OfflineService {
  static Future<void> createTable(sql.Database database) async {
    String task =
        "CREATE TABLE task (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, category TEXT NOT NULL, description TEXT NULL, date DATETIME NOT NULL, statut TEXT NOT NULL);";

    String user =
        "CREATE TABLE user (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, language TEXT NOT NULL, avatar TEXT NOT NULL);";
    await database.execute(task);
    await database.execute(user);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'taratodo.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTable(database);
      },
    );
  }

  ///////////////////////////////////////////////////// task method /////////////////////////////////////////////////////
  // create task
  static Future<int> createTask(
    String title,
    String category,
    String description,
    String date,
    String time
  ) async {
    final db = await OfflineService.db();
    final data = {
      'title': title,
      'category': category,
      'description': description,
      'date': "$date $time:00",
      'statut': 'false',
    };
    return await db.insert('task', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);


  }

  // get task store valid
  static Future<List<Map<String, dynamic>>> doneTask() async {
    final db = await OfflineService.db();
    return db.query('task',
        where: 'statut=?', whereArgs: ['true'], orderBy: 'id');
  }

  // get task store valid
  static Future<List<Map<String, dynamic>>> listTask() async {
    final db = await OfflineService.db();
    return db.query('task', orderBy: 'id');
  }

  // get task store on progress
  static Future<List<Map<String, dynamic>>> onProgressTask() async {
    final db = await OfflineService.db();
    return db.query('task',
        where: 'statut=?', whereArgs: ['false'], orderBy: 'id');
  }

  // read single task
  static Future<List<Map<String, dynamic>>> singleTask(int id) async {
    final db = await OfflineService.db();
    return db.query('task', where: 'id=?', whereArgs: [id], limit: 1);
  }

  // delete task
  static Future<int> deleteTask(int id) async {
    final db = await OfflineService.db();
    return await db.delete('task', where: 'id=?', whereArgs: [id]);
  }

  // make task done
  static Future<int> makeDoneTask(int id) async {
    final db = await OfflineService.db();
    final data = {
      'statut': 'true',
    };
    return await db.update('task', data, where: 'id=?', whereArgs: [id]);
  }

  static Future<int> updateTask(int id,
      String title,
      String category,
      String description,
      String date,
      String time) async {
    final db = await OfflineService.db();
    final data = {
      'title': title,
      'category': category,
      'description': description,
      'date': "$date $time:00",
    };
    return await db.update('task', data, where: 'id=?', whereArgs: [id]);
  }


  ///////////////////////////////////////////////////// user method /////////////////////////////////////////////////////
  // create user
  static Future<int> createUser(
      String name,
      String language,
      String avatar,
      ) async {
    final db = await OfflineService.db();
    final data = {
      'name': name,
      'language': language,
      'avatar': avatar,
    };
    return await db.insert('user', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);


  }

  // list user
  static Future<List<Map<String, dynamic>>> listUser() async {
    final db = await OfflineService.db();
    return db.query('user');
  }
}
