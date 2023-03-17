import 'package:flutter/material.dart';
import 'package:projeto_ponto_turistico/pages/lista_ponto_turistico.dart';

void main() {
  runApp(const CadastrarPontoTuristico());
}

class CadastrarPontoTuristico extends StatelessWidget {
  const CadastrarPontoTuristico({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cadastro de Pontos Turisticos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListaPontoTuristicoPage(),
    );
  }
}

