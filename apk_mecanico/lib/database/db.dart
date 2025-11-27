import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('manutencao.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE manutencoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descricao TEXT NOT NULL,
        tipo_servico TEXT NOT NULL,
        data TEXT NOT NULL,
        quilometragem INTEGER NOT NULL,
        valor REAL NOT NULL,
        status TEXT NOT NULL,
        mecanico TEXT NOT NULL
      );
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
