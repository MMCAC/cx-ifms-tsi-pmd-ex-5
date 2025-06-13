import 'dart:convert';

class Filme{
  int? id;
  String? titulo;
  bool? favorito;

  Filme({this.id = 0, this.titulo="", this.favorito=false});

  Filme.fromJson(Map<String, dynamic> jsonMap){
    id = jsonMap['id'],
    titulo = jsonMap['t itulo']
    favorito = jsonMap['favorito'];
  }
    
    Map<String, dynamic> toJson(){
      return {
        'id': this.id,
        'titulo': this.titulo,
        'favorito': this.favorito
      };
    }
  
}