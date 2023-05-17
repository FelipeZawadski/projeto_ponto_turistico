
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_ponto_turistico/model/ponto_turistico.dart';

class ConteudoFormDialog extends StatefulWidget{

  final PontoTuristico? pontoTuristico;

  ConteudoFormDialog({Key ? key, this.pontoTuristico}) : super(key: key);

  @override
  ConteudoFormDialogState createState() => ConteudoFormDialogState();
}

class ConteudoFormDialogState extends State<ConteudoFormDialog> {

  final formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final descricaoController = TextEditingController();
  final diferenciaisController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');
  final dataController = TextEditingController();

  @override
  void initState(){
    super.initState();
    if(widget.pontoTuristico != null){
      nomeController.text = widget.pontoTuristico!.nome;
      descricaoController.text = widget.pontoTuristico!.descricao;
      diferenciaisController.text = widget.pontoTuristico!.diferenciais;
      dataController.text = widget.pontoTuristico!.dataFormatada;
    }
  }

  Widget build(BuildContext context){
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
              validator: (String? valor){
                if(valor == null || valor.isEmpty){
                  return 'Informe o nome';
                }
                return null;
              },
            ),
            TextFormField(
              controller: descricaoController,
              decoration: InputDecoration(labelText: 'Descrição'),
              validator: (String? valor){
                if(valor == null || valor.isEmpty){
                  return 'Informe a descrição';
                }
                return null;
              },
            ),
            TextFormField(
              controller: diferenciaisController,
              decoration: InputDecoration(labelText: 'Diferenciais'),
              validator: (String? valor){
                if(valor == null || valor.isEmpty){
                  return 'Informe os diferenciais';
                }
                return null;
              },
            ),
            TextFormField(
              controller: dataController,
              readOnly: true,
              decoration: InputDecoration(labelText: 'Data'),
              validator: (String? valor){
                if(valor == null || valor.isEmpty){
                  final dataFormatada = dataController.text;
                  var data = DateTime.now();
                  if (dataFormatada.isNotEmpty){
                    data = _dateFormat.parse(dataFormatada);
                  }
                  return dataController.text = _dateFormat.format(data);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  bool dadosValidos() => formKey.currentState!.validate() == true;

  PontoTuristico get novoPontoTuristico => PontoTuristico(
      id: widget.pontoTuristico?.id ?? null,
      nome: nomeController.text,
      descricao: descricaoController.text,
      diferenciais: diferenciaisController.text,
      data: dataController.text.isEmpty ? null : _dateFormat.parse(dataController.text),
  );
}