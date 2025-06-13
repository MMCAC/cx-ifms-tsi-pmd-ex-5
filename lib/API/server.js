const express = require('express');
const app = express();
const cors = require('cors');

app.use(express.json({extends:false}));
app.use(express.static('public',{}));
app.use(cors());

let contador = 0;

const filmes = [{
	id: ++contador,
	titulo: "Rocky",
	favorito: false
}];

// LISTAGEM DE FILMES - MÉTODO HTTP GET
app.get('/ws/filme', function(req, res){
	return res.status(200).json(filmes);
});

// INSERIR UM NOVO FILME - MÉTODO HTTP POST
app.post('/ws/filme', function(req, res){
	const novoFilme = req.body;
	novoFilme.id = ++contador;
	filmes.push(novoFilme);
	return res.status(200).send();
});

// REMOVER UM FILME POR ID - MÉTODO HTTP DELETE
app.delete('/ws/filme/:id', function(req,res){
	const id = req.params.id;
	
	for(let index in filmes){
		if(filmes[index] != null && filmes[index].id == id){
			filmes.splice(index,1);
			return res.status(200).send();
		}
	}
	return res.status(404).send();
});

// ATUALIZAR UM FILME - MÉTODO HTTP PUT
app.put('/ws/filme', function(req, res){
	const filmeAlterado = req.body;
	const id = filmeAlterado.id;
	for(let index in filmes){
		if(filmes[index] != null && filmes[index].id == id){
			filmes[index].titulo = filmeAlterado.titulo;
			filmes[index].favorito = filmeAlterado.favorito;	
			return res.status(200).send();
		}
	}
	return res.status(404).send();
});

app.listen(3000, function(){
	console.log("Servidor HTTP no AR.");
});