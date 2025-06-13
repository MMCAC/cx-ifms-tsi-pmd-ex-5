import 'dart:convert';
import 'package:flutter/material.dart';
import '../Models/Filme.dart';
import 'FormCadastro.dart';
import 'package:navegacao/Services/FilmeService.dart';

class MeuApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MeuApp();
  }
}

class _MeuApp extends State<MeuApp>{
  List<Filme> filmes = [
    Filme(titulo: "Rambo")
  ];

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
        // Ver:
        // https://stackoverflow.com/questions/44004451/navigator-operation-requested-with-a-context-that-does-not-include-a-navigator
        home: Builder(builder: (context) => buildScaffold(context),)
     );
  }

  Widget buildScaffold(BuildContext context){
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(context),
      floatingActionButton: buildFAB(context)
    );
  }

  AppBar buildAppBar(){
    return AppBar(title: Text("Meu App"),);
  }

  Widget buildBody(BuildContext context){
    return FutureBuilder(
      future: buscarTodosOsFilmes(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          List<Filme>? filmes = snapshot.data;
          return ListView.builder(
            itemCount: filmes!.length,
            itemBuilder: (context, index){
              return ListTile(
                title: Text(filmes[index].titulo!),
              );
            }
          );
        } else{
          return Center(child: CircularProgressIndicator());
        }


      }
    );
  }


  Widget buildFAB(BuildContext context) {
    return FloatingActionButton(onPressed: () async {
        //Navigator.push(
        //  context, 
        //  MaterialPageRoute(
        //    builder: (context) => FormCadastro())
        //)

        Filme filme = await Navigator.push(
          context, 
          MaterialPageRoute(
          builder: (context) => FormCadastro())
        );
        setState(() {
          filmes.add(filme);
        });
    }, child: Icon(Icons.add),);
  }
}