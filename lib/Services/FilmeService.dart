import 'dart:convert';
import 'package:navegacao/Models/Filme.dart';
import 'package:http/http.dart' as http;

const BASE_URL = "localhost:3000";

Future<List<Filme>> buscarTodosOsFilmes() async {
  final uri = Uri.http(BASE_URL, "ws/filme");
  final response = await http.get(uri);

  if(response.statusCode == 200) {
    final bytes = response.bodyBytes;
    final utf8Map = utf8.decode(bytes);
    final List<dynamic> filmesMap = jsonDecode(utf8Map);

    return filmesMap.map<Filme>((json) {
      return Filme.fromJson(json);
    }).toList();
  } else {
    throw Exception("Erro ao buscar filmes: ${response.statusCode}");
  }
}

Future<Filme> criarFilme(Filme filme) async {
  final uri = Uri.http(BASE_URL, "ws/filme");
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(filme.toJson()),
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    return Filme.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Erro ao criar filme: ${response.statusCode}");
  }
}

Future<Filme> atualizarFilme(Filme filme) async {
  if (filme.id == null) {
    throw Exception("ID do filme não pode ser nulo para atualizar");
  }

  final uri = Uri.http(BASE_URL, "ws/filme/${filme.id}");
  final response = await http.put(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(filme.toJson()),
  );

  if (response.statusCode == 200) {
    return Filme.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Erro ao atualizar filme: ${response.statusCode}");
  }
}

Future<void> deletarFilme(int id) async {
  final uri = Uri.http(BASE_URL, "ws/filme/$id");
  final response = await http.delete(uri);

  if (response.statusCode != 200 && response.statusCode != 204) {
    throw Exception("Erro ao deletar filme: ${response.statusCode}");
  }
}