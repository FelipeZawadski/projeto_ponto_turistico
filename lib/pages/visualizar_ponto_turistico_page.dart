

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_ponto_turistico/model/ponto_turistico.dart';

class VisualizarPontoTuristicoPage extends StatefulWidget {
  final PontoTuristico pontoTuristico;

  const VisualizarPontoTuristicoPage({Key? key, required this.pontoTuristico}) : super(key: key);

  @override
  _VisualizarPontoTuristicoPageState createState() => _VisualizarPontoTuristicoPageState();
}

class _VisualizarPontoTuristicoPageState extends State<VisualizarPontoTuristicoPage> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes dos Pontos Turisticos'),
      ) ,
      body: _criaBody(),
    );
  }

  Widget _criaBody(){
    return Padding(
      padding: EdgeInsets.all(10),
      child: ListView(
        children: [
          Row(
            children: [
              Campo(descricao:'Código: '),
              Valor(valor: '${widget.pontoTuristico.id}'),
            ],
          ),
          Row(
            children: [
              Campo(descricao:'Nome: '),
              Valor(valor: '${widget.pontoTuristico.nome}'),
            ],
          ),
          Row(
            children: [
              Campo(descricao:'Descrição: '),
              Valor(valor: '${widget.pontoTuristico.descricao}'),
            ],
          ),
          Row(
            children: [
              Campo(descricao:'Diferencial: '),
              Valor(valor: '${widget.pontoTuristico.diferenciais}'),
            ],
          ),
          Row(
            children: [
              Campo(descricao:'Prazo: '),
              Valor(valor: '${widget.pontoTuristico.data}'),
            ],
          ),
        ],
      ),
    );
  }
}

class Campo extends StatelessWidget{
  final String descricao;

  const Campo({Key? key,required this.descricao}) : super(key: key);

  @override
  Widget build (BuildContext context){
    return Expanded(
      flex: 1,
      child: Text(descricao,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class Valor extends StatelessWidget{
  final String valor;

  const Valor({Key? key,required this.valor}) : super(key: key);

  @override
  Widget build (BuildContext context){
    return Expanded(
      flex: 4,
      child: Text(valor),
    );
  }
}