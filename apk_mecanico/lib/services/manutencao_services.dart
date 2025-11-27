import '../database/db.dart';
import '../model/manutencao_model.dart';

class ManutencaoService {
  final AppDatabase _appDatabase = AppDatabase.instance;

  Future<int> inserir(Manutencao manutencao) async {
    final db = await _appDatabase.database;
    return await db.insert('manutencoes', manutencao.toMap());
  }

  Future<List<Manutencao>> listarTodos() async {
    final db = await _appDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query('manutencoes');
    return List.generate(maps.length, (i) => Manutencao.fromMap(maps[i]));
  }

  Future<Manutencao?> buscarPorId(int id) async {
    final db = await _appDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'manutencoes',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Manutencao.fromMap(maps.first);
    }
    return null;
  }

  Future<int> atualizar(Manutencao manutencao) async {
    final db = await _appDatabase.database;
    return await db.update(
      'manutencoes',
      manutencao.toMap(),
      where: 'id = ?',
      whereArgs: [manutencao.id],
    );
  }

  Future<int> deletar(int id) async {
    final db = await _appDatabase.database;
    return await db.delete(
      'manutencoes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}