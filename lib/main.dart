import 'package:flutter/material.dart';
import 'package:projeto_ponto_turistico/pages/filtro_page.dart';
import 'package:projeto_ponto_turistico/pages/home_page.dart';

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
      home: HomePage(),
      routes: {
        FiltroPage.ROUTE_NAME: (BuildContext context) => FiltroPage(),
      },
    );
  }
}

