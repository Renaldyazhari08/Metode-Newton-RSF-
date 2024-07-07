import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/solution.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._();
  static Database? _database;

  DBHelper._();

  factory DBHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'solutions.db');
    return await openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE solutions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            equation TEXT,
            x0 REAL,
            error REAL,
            result REAL
          )
        ''');
      },
      version: 1,
    );
  }

  Future<int> insertSolution(Solution solution) async {
    Database db = await database;
    return await db.insert('solutions', solution.toMap());
  }

  Future<List<Solution>> getSolutions() async {
    Database db = await database;
    var res = await db.query('solutions');
    List<Solution> list =
        res.isNotEmpty ? res.map((c) => Solution.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> deleteSolution(int id) async {
    Database db = await database;
    return await db.delete('solutions', where: 'id = ?', whereArgs: [id]);
  }

  Future<Solution?> getSolution(int id) async {
    Database db = await database;
    var res = await db.query('solutions', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? Solution.fromMap(res.first) : null;
  }
}
