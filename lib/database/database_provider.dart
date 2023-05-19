
import 'package:sqflite/sqflite.dart';

import '../model/ponto_turistico.dart';

class DatabaseProvider {
  static const _dbName = 'cadastroPontoTuristico.db';
  static const _dbVersion = 7;

  DatabaseProvider._init();
  static final DatabaseProvider instance = DatabaseProvider._init();

  Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final dbPath = '$databasesPath/$_dbName';
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE ${PontoTuristico.NOME_TABLE} (
        ${PontoTuristico.CAMPO_ID} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${PontoTuristico.CAMPO_DESCRICAO} TEXT NOT NULL,
        ${PontoTuristico.DATA} TEXT NOT NULL,
        ${PontoTuristico.CAMPO_NOME} TEXT NOT NULL,
        ${PontoTuristico.CAMPO_DIFERENCIAIS} TEXT,
        ${PontoTuristico.LONGITUDE} FLOAT,
        ${PontoTuristico.LATITUDE} FLOAT);
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    switch(oldVersion){
      case 2:
        await db.execute('''
        ALTER TABLE ${PontoTuristico.NOME_TABLE}
        ADD ${PontoTuristico.LONGITUDE} FLOAT;
        ''');

        await db.execute('''
        ALTER TABLE ${PontoTuristico.NOME_TABLE}
        ADD ${PontoTuristico.LATITUDE} FLOAT;
        ''');
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}