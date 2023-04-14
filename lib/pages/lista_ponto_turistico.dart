import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_ponto_turistico/pages/visualizar_ponto_turistico_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dao/ponto_turistico_dao.dart';
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

  /*final pontosTuristicos = <PontoTuristico>[
    PontoTuristico(id: 1, nome: 'Igreja', descricao: 'Igreja Matriz', diferenciais: 'Centro', data: DateTime.now())
  ];*/

  final _pontoTuristico = <PontoTuristico>[];
  final _dao = PontoTuristicoDao();
  var _carregando = false;


  @override
  void initState(){
    super.initState();
    _atualizarLista();
  }

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

  Widget _criarBody(){
    if(_carregando){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.center,
            child: CircularProgressIndicator(),
          ),
          Align(
            alignment: AlignmentDirectional.center,
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text('Carregando seus pontos turisticos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          )
        ],
      );
    }
    if(_pontoTuristico.isEmpty){
      return const Center(
        child: Text('Nenhum ponto turistico cadastrado',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }
    return ListView.separated(
      itemBuilder: (BuildContext context, int index){
        final pontoTuristico = _pontoTuristico[index];
        return PopupMenuButton<String>(
          child: ListTile(
            title: Text('${pontoTuristico.id} - ${pontoTuristico.descricao}',
              style: TextStyle(
              ),
            ),
          ),
          itemBuilder: (BuildContext context) => criarItensMenuPopup(),
          onSelected: (String valorSelecionado){
            if (valorSelecionado == ACAO_EDITAR){
              _abrirCadastro(pontoTuristico: pontoTuristico);
            }else if (valorSelecionado == ACAO_VISUALIZAR){
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => VisualizarPontoTuristicoPage(pontoTuristico: pontoTuristico),
              ));
            }
            else{
              _excluir(pontoTuristico);
            }
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemCount: _pontoTuristico.length,
    );
  }

  void _paginaFiltro(){
    final navigator = Navigator.of(context);
    navigator.pushNamed(FiltroPage.ROUTE_NAME).then((alteracaoValores) {
      if(alteracaoValores == true){
        ///////
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

  void _atualizarLista() async {
      setState(() {
        _carregando = true;
      });

      final prefs = await SharedPreferences.getInstance();
      final campoOrdenacao = prefs.getString(FiltroPage.CAMPO_ORDENACAO) ?? PontoTuristico.CAMPO_ID;
      final usarOrdemDecrescente = prefs.getBool(FiltroPage.CAMPO_ORDEM_DECRECENTE) == true;
      final filtroNome = prefs.getString(FiltroPage.CAMPO_NOME) ?? '';

      final pontoTuristico = await _dao.listar(
        filtro: filtroNome,
        campoOrdenacao: campoOrdenacao,
        usarOrdemDecrescente: usarOrdemDecrescente,
      );

      setState(() {
        _pontoTuristico.clear();
        if (pontoTuristico.isNotEmpty) {
          _pontoTuristico.addAll(pontoTuristico);
        }
      });
      setState(() {
        _carregando = false;
      });
  }

  void _abrirCadastro({PontoTuristico? pontoTuristico}){
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(pontoTuristico == null ? 'Novo ponto turistico' : 'Alterar ponto turistico ${pontoTuristico.id}'),
            content: ConteudoFormDialog(key: key, pontoTuristico: pontoTuristico,),
            actions: [
              TextButton(
                child: Text('Cancelar'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('Salvar'),
                onPressed: () {
                  if (key.currentState?.dadosValidos() != true) {
                    return;
                  }
                  Navigator.of(context).pop();
                  final novoPontoTuristico = key.currentState!.novoPontoTuristico;
                  _dao.salvar(novoPontoTuristico).then((success) {
                  if (success) {
                    _atualizarLista();
                  }
                  });
                _atualizarLista();
              },
              ),
            ],
          );
        });
  }

  /*void _abrirVisualizacao({PontoTuristico? pontoTuristicoAtual, int? index}){
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
  }*/

  void _excluir(PontoTuristico pontoTuristico){
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
                  onPressed: () {
                    Navigator.of(context).pop();
                    if(pontoTuristico.id == null){
                      return;
                    }
                    _dao.remover(pontoTuristico.id!).then((sucess) {
                      if (sucess)
                        _atualizarLista();
                    });
                  },
                  child: Text('OK')
              )
            ],
          );
        }
    );
  }
}