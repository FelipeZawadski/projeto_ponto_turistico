import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/ponto_turistico.dart';
import '../widget/conteudo_form_dialog.dart';
import 'filtro_page.dart';


class ListaPontoTuristicoPage extends StatefulWidget{

  @override
  _ListaPontoTuristicoPageState createState() =>_ListaPontoTuristicoPageState();
}

class _ListaPontoTuristicoPageState extends State<ListaPontoTuristicoPage>{

  static const ACAO_EDITAR = 'editar';
  static const ACAO_EXCLUIR = 'excluir';
  static const ACAO_VISUALIZAR = 'visualizar';

  final pontosTuristicos = <PontoTuristico>[
    PontoTuristico(id: 1, nome: 'Igreja', descricao: 'Igreja Matriz', diferenciais: 'Centro', data: DateTime.now())
  ];

  int _ultimoId = 0;

  @override
  Widget build(BuildContext context){
      return Scaffold(
        appBar: _criarAppBar(),
        body: _criarBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: _abrirCadastro,
          tooltip: 'Novo Ponto Turistico',
          child: Icon(Icons.add),
        ),
      );
  }

  AppBar _criarAppBar(){
    return AppBar(
      title: Text('Pontos Turisticos'),
      actions: [
        IconButton(onPressed: _paginaFiltro, icon: Icon(Icons.filter_list)), // _paginaFiltro
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
                subtitle: Text('${pontoTuristico.descricao} - ${pontoTuristico.diferenciais} - Data - ${pontoTuristico.dataFormatada}'),),
                itemBuilder: (BuildContext context) => criarItensMenuPopup(),
                onSelected: (String valorSelecionado){
                  if(valorSelecionado == ACAO_EDITAR){
                    _abrirCadastro(pontoTuristicoAtual: pontoTuristico, index: index);
                  } else if(valorSelecionado == ACAO_VISUALIZAR){
                    _abrirVisualizacao(pontoTuristicoAtual: pontoTuristico, index: index);
                  }
                  else{
                    _excluir(index);
                  }
                },
            );
          },
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: pontosTuristicos.length);
    }
  }

  void _paginaFiltro(){
    final navigator = Navigator.of(context);
    navigator.pushNamed(FiltroPage.ROUTE_NAME).then((alteracaoValores) {
      if(alteracaoValores == true){
        //////
      }
    });
  }

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
      ),
      PopupMenuItem<String>(
          value: ACAO_VISUALIZAR,
          child: Row(
              children: [
                Icon (Icons.visibility, color: Colors.black),
                Padding(padding: EdgeInsets.only(left: 10),
                    child: Text('Visualizar')),
              ]
          )
      ),
    ];
  }

  void _abrirCadastro({PontoTuristico? pontoTuristicoAtual, int? index}){
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(pontoTuristicoAtual == null ? 'Novo ponto turistico' : 'Alterar ponto turistico ${pontoTuristicoAtual.id}'),
            content: ConteudoFormDialog(key: key, pontoTuristicoAtual: pontoTuristicoAtual,),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancelar')),
              TextButton(onPressed: () {
                if(key.currentState != null && key.currentState!.dadosValidos()){
                  setState(() {
                    final novoPontoturistico = key.currentState!.novoPontoTuristico;
                    if(index == null){
                      novoPontoturistico.id = ++ _ultimoId;
                    }
                    else{
                      pontosTuristicos[index] = novoPontoturistico;
                    }
                    pontosTuristicos.add(novoPontoturistico);
                  });
                  Navigator.of(context).pop();
                }
              }, child: Text('Salvar'),
              )
            ],
          );
        });
  }

  void _abrirVisualizacao({PontoTuristico? pontoTuristicoAtual, int? index}){
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Visualizar ponto Turistico ${pontoTuristicoAtual?.id}'),
            content: ConteudoFormDialog(key: key, pontoTuristicoAtual : pontoTuristicoAtual,),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK')),
            ],
          );
        }
    );
  }

  void _excluir(int index){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.warning, color: Colors.red,),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text('ATENÇÃO'),
                ),
              ],
            ),
            content: Text('Esse registro será deletado definitivamente'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancelar')
              ),
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                    setState(() {
                      pontosTuristicos.removeAt(index);
                    });
                  },
                  child: Text('OK')
              ),
            ],
          );
        }
    );
  }
}