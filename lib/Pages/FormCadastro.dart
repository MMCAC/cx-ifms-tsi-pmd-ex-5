import 'package:flutter/material.dart';
import '../Models/Filme.dart';


class FormCadastro extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _FormCadastro();
  }
}

class _FormCadastro extends State<FormCadastro>{
  TextEditingController tituloController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
       return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      floatingActionButton: buildFAB(context)
    );
  }

  Widget buildScaffold(context){
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      floatingActionButton: buildFAB(context)
    );
  }

  AppBar buildAppBar(){
    return AppBar(title: Text("Novo Filme"),);
  }

  Widget buildBody(){
    return Form( 
      key: key ,
      child: Column(
        children: [
          TextFormField(
            controller: tituloController,
            decoration: InputDecoration(labelText: "Título"),
            validator: (text){
              if(text == null || text.isEmpty){
                return "Título é obrigatório"; 
              }
              return null;
            }
          )
        ],
      ),
    );
  }

  Widget buildFAB(context){
    Filme filme = Filme();
    return FloatingActionButton(onPressed: () {
      if(key.currentState!.validate()){
         filme.titulo = tituloController.text; 
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Filme Cadastrado"))
         ); 
         Navigator.pop(context, filme);
      }
    }, child: Icon(Icons.check),);
  }
}
