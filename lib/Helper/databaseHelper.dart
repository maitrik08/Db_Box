import 'package:db_box/Model/todoModel.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "TodoDatabase.db";
  static final _databaseVersion = 1;
  static final table = 'todos';

  static final columnId = 'id';
  static final columnTitle = 'title';
  static final columnDescription = 'description';
  static final columnIsBookmarked = 'isBookmarked';

  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      _databaseName,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle TEXT NOT NULL,
        $columnDescription TEXT NOT NULL,
        $columnIsBookmarked INTEGER NOT NULL
      )
    ''');
  }

  // Create
  Future<int> insert(Todo todo) async {
    try {
      Database db = await instance.database;
      return await db.insert(table, todo.toMap());
    } catch (e) {
      print('Error inserting todo: $e');
      rethrow;
    }
  }

  // Read
  Future<List<Todo>> queryAllTodos() async {
    Database? db = await instance.database;
    final result = await db!.query(table);
    print('Todos queried: ${result.length}');
    return result.map((map) => Todo.fromMap(map)).toList();
  }


  // Update
  Future<int> update(Todo todo) async {
    try {
      Database db = await instance.database;
      return await db.update(
        table,
        todo.toMap(),
        where: '$columnId = ?',
        whereArgs: [todo.id],
      );
    } catch (e) {
      print('Error updating todo: $e');
      rethrow;
    }
  }

  // Delete
  Future<int> delete(int id) async {
    try {
      Database db = await instance.database;
      return await db.delete(
        table,
        where: '$columnId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error deleting todo: $e');
      rethrow;
    }
  }
}
