import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/ponto_turistico.dart';


class ListaPontoTuristicoPage extends StatefulWidget{

  @override
  _ListaPontoTuristicoPageState createState() =>_ListaPontoTuristicoPageState();
}

class _ListaPontoTuristicoPageState extends State<ListaPontoTuristicoPage>{

  static const ACAO_EDITAR = 'editar';
  static const ACAO_EXCLUIR = 'excluir';

  final pontosTuristicos = <PontoTuristico>[
    PontoTuristico(id: 1, nome: 'Igreja', descricao: 'Igreja Matriz', diferenciais: 'Centro', data: DateTime.now())
  ];

  int _ultimo = 0;

  @override
  Widget build(BuildContext context){
      return Scaffold(
        appBar: _criarAppBar(),
        body: _criarBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: (){},//_abrirCadastro,
          tooltip: 'Novo Ponto Turistico',
          child: Icon(Icons.add),
        ),
      );
  }

  AppBar _criarAppBar(){
    return AppBar(
      title: Text('Pontos Turisticos'),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.filter_list)), // _paginaFiltro
      ],
    );
  }

  Widget _criarBody() {
    if (pontosTuristicos.isEmpty) {
      return const Center(
        child: Text('Nenhum ponto turistico foi cadastrado',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      return ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            final pontoTuristico = pontosTuristicos[index];
            return PopupMenuButton<String>(
                child: ListTile(title: Text('${pontoTuristico.id} - ${pontoTuristico.nome}'),
                subtitle: Text('${pontoTuristico.descricao} - ${pontoTuristico.diferenciais} - Data - ${pontoTuristico.data} -'),),
                itemBuilder: (BuildContext context) => criarItensMenuPopup(),
                onSelected: (String valorSelecionado){
                  /*if(valorSelecionado == ACAO_EDITAR){
                    _abrirForm(pontoAtual: pontoTuristico, index: index);
                  } else{
                    _excluir(index);
                  }*/
                },
            );
          },
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: pontosTuristicos.length);
    }
  }

  /*void _paginaFiltro(){
    final navigator = Navigator.of(context);
    navigator.pushNamed(FiltroPage.ROUTE_NAME).then((alterouValores) {
      if(alterouValores == true){
        //////
      }
    });
  }*/

  List<PopupMenuEntry<String>> criarItensMenuPopup(){
    return [
      PopupMenuItem<String>(
          value: ACAO_EDITAR,
          child: Row(
              children: [
                Icon (Icons.edit, color: Colors.black),
                Padding(padding: EdgeInsets.only(left: 10),
                    child: Text('Editar')),
              ]
          )
      ),
      PopupMenuItem<String>(
          value: ACAO_EXCLUIR,
          child: Row(
              children: [
                Icon (Icons.delete, color: Colors.red),
                Padding(padding: EdgeInsets.only(left: 10),
                    child: Text('Excluir')),
              ]
          )
      )
    ];
  }
}