

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_ponto_turistico/model/ponto_turistico.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FiltroPage extends StatefulWidget{
  static const ROUTE_NAME = '/filtro';
  static const CAMPO_ORDENACAO = 'campoOrdenacao';
  static const CAMPO_ORDEM_DECRECENTE = 'campoOrdemDescrecente';
  static const CAMPO_NOME = 'campoNome';
  static const CAMPO_DATA = 'campoData';

  @override
  _FiltroPageState createState() => _FiltroPageState();
}

class _FiltroPageState extends State<FiltroPage>{

  final _campoParaOrdenacao = {
    PontoTuristico.CAMPO_ID : 'Código', PontoTuristico.DATA : 'Data', PontoTuristico.CAMPO_NOME : 'Nome',
  };

  late final SharedPreferences pref;
  final nomeController = TextEditingController();
  final dataController = TextEditingController();
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

  Widget _criarBody(){
    return ListView(
      children: [
        Padding(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: Text('Campo para Ordenação'),
        ),
        for(final campo in _campoParaOrdenacao.keys)
          Row(
            children: [
              Radio(
                value: campo,
                groupValue: campoOrdenacao,
                onChanged: _onCampoOrdenacaoChange,
              ),
              Text(_campoParaOrdenacao[campo] ?? ''),
            ],
          ),
        Divider(),
        Row(
          children: [
            Checkbox(
              value: ordenacaoDecrescente,
              onChanged: _onUsarOrdemDecrescenteChange,
            ),
            Text('Usar ordem decrescente'),
          ],
        ),
        Divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextField(decoration: InputDecoration(labelText: 'Nome começa com: '),
            controller: nomeController,
            onChanged: _onFiltroNomeChange,
          ),
        ),
        Divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextField(decoration: InputDecoration(labelText: 'Diferenciais começa com: '),
            controller: dataController,
            onChanged: _onFiltroDataChange,
          ),
        ),
      ],
    );
  }

  Future<bool> _onClickVoltar() async {
    Navigator.of(context).pop(_alteracaoValores);
    return true;
  }

  void _carregarSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    pref = prefs;
    setState(() {
      campoOrdenacao = pref.getString(FiltroPage.CAMPO_ORDENACAO) ?? PontoTuristico.CAMPO_ID;
      ordenacaoDecrescente = pref.getBool(FiltroPage.CAMPO_ORDEM_DECRECENTE) ?? false;
      nomeController.text = pref.getString(FiltroPage.CAMPO_NOME) ?? '';
      dataController.text = pref.getString(FiltroPage.CAMPO_DATA) ?? '';
    });
  }

  void _onCampoOrdenacaoChange(String? valor){
    pref.setString(FiltroPage.CAMPO_ORDENACAO, valor ?? '');
    _alteracaoValores = true;
    setState(() {
      campoOrdenacao = valor ?? '';
    });
  }

  void _onUsarOrdemDecrescenteChange(bool? valor){
    pref.setBool(FiltroPage.CAMPO_ORDEM_DECRECENTE, valor == true);
    _alteracaoValores = true;
    setState(() {
      ordenacaoDecrescente = valor == true;
    });
  }

  void _onFiltroNomeChange(String? valor){
    pref.setString(FiltroPage.CAMPO_NOME, valor ?? '');
    _alteracaoValores = true;
  }

  void _onFiltroDataChange(String? valor){
  }
}