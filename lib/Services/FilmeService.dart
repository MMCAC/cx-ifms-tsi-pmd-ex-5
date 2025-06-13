import 'dart:convert';
import 'package:navegacao/Models/Filme.dart';
import 'package:http/http.dart' as http;

const BASE_URL = "localhost:3000";

Future<List<Filme>> buscarTodosOsFilmes() async {
  final uri = Uri.http(BASE_URL, "ws/filme");
  final response = await http.get(uri);
  List<Filme> filmes = [];
  if(response.statusCode == 200){
    final bytes = response.bodyBytes;
    final utf8Map = utf8.decode(bytes);
    final dynamic filmesMap = jsonDecode(utf8Map);

    filmes = filmesMap.map<Filme>((json){
      return Filme.fromJson(json);
    }).toList();
  }
  return filmes;
}