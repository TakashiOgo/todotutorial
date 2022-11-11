import 'package:sqflite/sqflite.dart';
import 'main.dart';
import 'models.dart';
import 'package:path/path.dart';

class TaskDatabase {

  Future<Database> get database async {
    final Future<Database> _database = openDatabase(
      join(await getDatabasesPath(), 'task.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE task(id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT)",
        );
      },
    );
    return _database;
  }

  Future<void> insertTask(Task task) async {
    final Database db = await database;
    await db.insert(
      'task',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> getTasks() async {
    final Database db = await database;
    final List<Map> maps = await db.query('task');
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        title: maps[i]['title'],
        isDone: maps[i]['isDone'],
      );
    });
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      'task',
      task.toMap(),
      where: "id = ?",
      whereArgs: [task.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(
      'task',
      where: "id = ?",
      whereArgs: [id],
    );
  }

}