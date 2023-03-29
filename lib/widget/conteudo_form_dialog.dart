

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_ponto_turistico/model/ponto_turistico.dart';

class ConteudoFormDialog extends StatefulWidget{

  final PontoTuristico? pontoTuristicoAtual;

  @override
  ConteudoFormDialogState createState() => ConteudoFormDialogState();
}

class ConteudoFormDialogState extends State<ConteudoFormDialog> {

  final formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final descricaoController = TextEditingController();
  final diferenciaisController = TextEditingController();
  final dataController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState(){
    super.initState();
    if(widget.pontoTuristicoAtual != null){
      descricaoController.text = widget.pontoTuristicoAtual!.descricao;
      dataController.text = widget.pontoTuristicoAtual!.dataFormatada;
    }
  }

  Widget build(BuildContext context){
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [TextFormField(
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
            controller: prazoController,
            decoration: InputDecoration(labelText: 'Prazo', prefix: IconButton(
              onPressed: _mostraCalendario,
              icon: Icon(Icons.calendar_today),
            ),
                suffixIcon: IconButton(
                  onPressed: () => prazoController.clear(),
                  icon: Icon(Icons.close),
                )
            ),
            readOnly: true,
          )
        ],
      ),
    );
  }

  void _mostraCalendario(){
    final dataFormatada = prazoController.text;
    var data = DateTime.now();
    if (dataFormatada.isNotEmpty){
      data = _dateFormat.parse(dataFormatada);
    }
    showDatePicker(
      context: context,
      initialDate: data,
      firstDate: data.subtract(Duration(days: 365 * 5)),
      lastDate: data.add(Duration(days: 365 * 5)),
    ).then((DateTime? dataSelecionada){
      if(dataSelecionada != null){
        setState(() {
          prazoController.text = _dateFormat.format(dataSelecionada);
        });
      }
    });
  }

  bool dadosValidados() => formKey.currentState!.validate() == true;

  Tarefa get novaTarefa => Tarefa(
    id: widget.tarefaAtual?.id ?? 0,
    descricao: descricaoController.text,
    prazo: prazoController.text.isEmpty ? null : _dateFormat.parse(prazoController.text),
  );
}