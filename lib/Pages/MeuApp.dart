import 'package:flutter/material.dart';
import '../Models/Filme.dart';
import 'FormCadastro.dart';
import 'package:navegacao/Services/FilmeService.dart';

class MeuApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MeuApp();
}

class _MeuApp extends State<MeuApp> {
  late Future<List<Filme>> filmesFuture;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    carregarFilmes();
  }

  void carregarFilmes() {
    filmesFuture = buscarTodosOsFilmes();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: Builder(
        builder: (context) => buildScaffold(context),
      ),
    );
  }

  Widget buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meu App")),
      body: FutureBuilder<List<Filme>>(
        future: filmesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Erro ao carregar filmes: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Nenhum filme cadastrado"));
          } else {
            final filmes = snapshot.data!;
            return ListView.builder(
              itemCount: filmes.length,
              itemBuilder: (context, index) {
                final filme = filmes[index];
                return ListTile(
                  title: Text(filme.titulo ?? 'Sem título'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          await _editarFilme(context, filme);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await _deletarFilme(filme.id!);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final precisaAtualizar = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormCadastro(),
            ),
          );
          if (precisaAtualizar == true) {
            setState(() {
              carregarFilmes();
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // 🔵 Método para editar
  Future<void> _editarFilme(BuildContext context, Filme filme) async {
    final TextEditingController controller =
        TextEditingController(text: filme.titulo);

    final novoTitulo = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Editar Filme"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Digite o novo título"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text("Salvar"),
          ),
        ],
      ),
    );

    if (novoTitulo != null && novoTitulo.isNotEmpty) {
      try {
        Filme atualizado = Filme(
          id: filme.id,
          titulo: novoTitulo,
        );
        await atualizarFilme(atualizado);
        setState(() {
          carregarFilmes();
        });
        scaffoldMessengerKey.currentState!.showSnackBar(
          SnackBar(content: Text("Filme atualizado com sucesso!")),
        );
      } catch (e) {
        scaffoldMessengerKey.currentState!.showSnackBar(
          SnackBar(content: Text("Erro ao atualizar filme")),
        );
      }
    }
  }

  // 🔴 Método para deletar
  Future<void> _deletarFilme(int id) async {
    try {
      await deletarFilme(id);
      setState(() {
        carregarFilmes();
      });
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Filme deletado com sucesso!"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(content: Text("Erro ao deletar filme")),
      );
    }
  }
}
