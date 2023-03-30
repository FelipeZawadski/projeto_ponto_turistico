

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_ponto_turistico/model/ponto_turistico.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FiltroPage extends StatefulWidget{
  static const ROUTE_NAME = '/filtro';
  static const CAMPO_ORDENACAO = 'campoOrdenacao';
  static const CAMPO_ORDEM_DECRECENTE = 'campoOrdemDescrecente';
  static const CAMPO_DESCRICAO = 'campoDescricao';

  @override
  _FiltroPageState createState() => _FiltroPageState();
}

class _FiltroPageState extends State<FiltroPage>{

  final _campoParaOrdenacao = {
    PontoTuristico.CAMPO_ID : 'Código', PontoTuristico.CAMPO_DESCRICAO : 'Descrição', PontoTuristico.DATA : 'Data',
    PontoTuristico.CAMPO_NOME : 'Nome', PontoTuristico.CAMPO_DIFERENCIAIS : 'Diferenciais',
  };

  late final SharedPreferences pref;
  final descricaoController = TextEditingController();
  final nomeController = TextEditingController();
  final diferenciais = TextEditingController();
  String campoOrdenacao = PontoTuristico.CAMPO_ID;
  bool ordenacaoDecrescente = false;
  bool _alteracaoValores = false;

  @override
  void initState(){
    super.initState();
    _carregarSharedPreferences();
  }

  Widget build(BuildContext context){
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(title: Text('Filtro e Ordenação'),
          ),
          body: _criarBody(),
        ),
        onWillPop: _onClickVoltar,
    );
  }
}