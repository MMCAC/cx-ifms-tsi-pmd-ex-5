import 'package:flutter/material.dart';
import '../Models/Filme.dart';
import 'package:navegacao/Services/FilmeService.dart';

class FormCadastro extends StatefulWidget {
  final Filme? filme;

  FormCadastro({this.filme}); // Se vier um filme, é edição

  @override
  State<StatefulWidget> createState() => _FormCadastro();
}

class _FormCadastro extends State<FormCadastro> {
  final TextEditingController tituloController = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.filme != null) {
      tituloController.text = widget.filme!.titulo ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filme == null ? "Novo Filme" : "Editar Filme"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: key,
          child: Column(
            children: [
              TextFormField(
                controller: tituloController,
                decoration: InputDecoration(labelText: "Título"),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "Título é obrigatório";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: isLoading ? CircularProgressIndicator(color: Colors.white) : Icon(Icons.check),
        onPressed: isLoading
            ? null
            : () async {
                if (key.currentState!.validate()) {
                  setState(() => isLoading = true);
                  try {
                    final titulo = tituloController.text;

                    if (widget.filme == null) {
                      await criarFilme(Filme(titulo: titulo));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Filme cadastrado com sucesso"),
                            backgroundColor: Colors.green),
                      );
                    } else {
                      final filmeAtualizado = Filme(
                        id: widget.filme!.id,
                        titulo: titulo,
                      );
                      await atualizarFilme(filmeAtualizado);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Filme atualizado com sucesso"),
                            backgroundColor: Colors.blue),
                      );
                    }

                    Navigator.pop(context, true);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Erro ao salvar filme")),
                    );
                  } finally {
                    setState(() => isLoading = false);
                  }
                }
              },
      ),
    );
  }
}
