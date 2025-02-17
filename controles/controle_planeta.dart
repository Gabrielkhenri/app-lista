import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
//import 'package:myapp/telas/telas_planetas.dart';

import '../modelos/planetas.dart';
//main class
class ControlePlaneta {
  static Database? _bd;

  Future<Database> get bd async {
    if (_bd != null) return _bd!;
    _bd = await _initBD('planetas.db');
    return _bd!;
  }

  Future<Database> _initBD(String localArquivo) async {
    final caminhoBD = await getDatabasesPath();
    final caminho = join(caminhoBD, localArquivo);
    return await openDatabase(caminho, version: 1, onCreate: _criarBD);
  }

  Future<void> _criarBD(Database bd, int versao) async {
    const sql = '''
    CREATE TABLE planetas(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT,
      tamanho REAL,
      distancia REAL,
      apelido TEXT
    )
    ''';
    await bd.execute(sql);
  }

  Future<List<Planeta>> lerPlanetas() async {
    final db = await bd;
    final resultado = await db.query('planetas');
    return resultado.map((item) => Planeta.fromMap(item)).toList();
  }

  Future<int> inserirPlaneta(Planeta planeta) async {
    final bd = await this.bd;
    return await bd.insert('planetas', planeta.toMap());
  }

  Future<int> excluirPlaneta(int id) async {
    final bd = await this.bd;
    return await bd.delete('planetas', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> alterarPlaneta(Planeta planeta) async {
    final db = await bd;
    return await db.update(
      'planetas',
      planeta.toMap(),
      where: 'id = ?',
      whereArgs: [planeta.id],
    );
  }
}
