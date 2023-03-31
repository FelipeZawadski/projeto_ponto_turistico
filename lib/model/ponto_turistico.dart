
import 'package:intl/intl.dart';

class PontoTuristico{

  static const CAMPO_ID = 'id';
  static const CAMPO_NOME = 'nome';
  static const CAMPO_DESCRICAO = 'descricao';
  static const CAMPO_DIFERENCIAIS = 'diferenciais';
  static const DATA = 'data';
  static const NOME_TABLE = 'pontosturisticos';

  int id;
  String nome;
  String descricao;
  String diferenciais;
  DateTime data;

  PontoTuristico({required this.id, required this.nome ,required this.descricao, required this.diferenciais, required this.data});

  String get dataFormatada{
    if(data == null){
      return  "";
    }
    return DateFormat('dd/MM/yyyy').format(data!);
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    CAMPO_ID: id,
    CAMPO_NOME: nome,
    CAMPO_DESCRICAO: descricao,
    CAMPO_DIFERENCIAIS: diferenciais,
    DATA: data == null ? null : DateFormat("dd/MM/yyyy").format(data!),
  };

  factory PontoTuristico.fromMap(Map<String, dynamic>  map) => PontoTuristico(
      id: map[CAMPO_ID] is int ? map[CAMPO_ID] : null,
      nome: map[CAMPO_NOME] is String ? map[CAMPO_NOME] : '',
      descricao: map[CAMPO_DESCRICAO] is String ? map[CAMPO_DESCRICAO] : '',
      diferenciais: map[CAMPO_DIFERENCIAIS] is String ? map[CAMPO_DIFERENCIAIS] : '',
      data: map[DATA] == null ? null : DateFormat("dd/MM/yyyy").parse(map[DATA])
  );
}