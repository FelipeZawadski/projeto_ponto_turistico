

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cep.dart';
import 'lista_ponto_turistico.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  var _fragmentIndex = 0;
  final buscaCep = GlobalKey<ConsultaCepFragmentState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_fragmentIndex == 0
            ? ListaPontoTuristicoPage.title : ConsultaCepFragment.title),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _fragmentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: ListaPontoTuristicoPage.title,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: ConsultaCepFragment.title,
          ),
        ],
        onTap: (int newIndex) {
          if (newIndex != _fragmentIndex) {
            setState(() {
              _fragmentIndex = newIndex;
            });
          }
        },
      ),
      //floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildBody() => _fragmentIndex == 0
      ? ListaPontoTuristicoPage() : ConsultaCepFragment();


}