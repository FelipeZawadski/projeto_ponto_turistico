

import 'package:projeto_ponto_turistico/model/ponto_turistico.dart';

import '../database/database_provider.dart';

class PontoTuristicoDao{

  final dbProvider = DatabaseProvider.instance;

  Future<bool> salvar(PontoTuristico pontoTuristico) async {
    final database = await dbProvider.database;
    final valores = pontoTuristico.toMap();
    if (pontoTuristico.id == null) {
      pontoTuristico.id = await database.insert(PontoTuristico.NOME_TABLE, valores);
      return true;
    } else {
      final registrosAtualizados = await database.update(
        PontoTuristico.NOME_TABLE,
        valores,
        where: '${PontoTuristico.CAMPO_ID} = ?',
        whereArgs: [pontoTuristico.id],
      );
      return registrosAtualizados > 0;
    }
  }

  Future<bool> remover(int id) async {
    final database = await dbProvider.database;
    final registrosAtualizados = await database.delete(
      PontoTuristico.NOME_TABLE,
      where: '${PontoTuristico.CAMPO_ID} = ?',
      whereArgs: [id],
    );
    return registrosAtualizados > 0;
  }

  Future<List<PontoTuristico>> listar(
      {String filtro = '',
        String campoOrdenacao = PontoTuristico.CAMPO_ID,
        bool usarOrdemDecrescente = false
      }) async {
    String? where;
    if(filtro.isNotEmpty){
      where = "UPPER(${PontoTuristico.CAMPO_DESCRICAO}) LIKE '${filtro.toUpperCase()}%'";
    }
    var orderBy = campoOrdenacao;

    if(usarOrdemDecrescente){
      orderBy += ' DESC';
    }
    final database = await dbProvider.database;
    final resultado = await database.query(PontoTuristico.NOME_TABLE,
      columns: [PontoTuristico.CAMPO_ID, PontoTuristico.CAMPO_NOME, PontoTuristico.CAMPO_DESCRICAO, PontoTuristico.CAMPO_DIFERENCIAIS, PontoTuristico.DATA],
      where: where,
      orderBy: orderBy,
    );
    return resultado.map((m) => PontoTuristico.fromMap(m)).toList();
  }

}