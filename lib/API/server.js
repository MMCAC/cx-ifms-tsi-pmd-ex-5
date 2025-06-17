const express = require('express');
const app = express();
const cors = require('cors');

app.use(express.json());
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
	const { titulo, favorito = false } = req.body;

	const jaExiste = filmes.some(f => f.titulo.toLowerCase() === titulo.trim().toLowerCase());

	if(jaExiste){
		return res.status(409).json({message: 'Filme já cadastrado.'});
	}

	if(!titulo || titulo.trim() === ''){
		return res.status(400).json({message: 'Título do filme é obrigatório.'});
	}

	const novoFilme = {
		id: ++contador,
		titulo: titulo.trim(),
		favorito: favorito
	};

	filmes.push(novoFilme);
	return res.status(201).json(novoFilme);
});

// REMOVER UM FILME POR ID - MÉTODO HTTP DELETE
app.delete('/ws/filme/:id', function(req,res){
	const id = Number(req.params.id);
	const index = filmes.findIndex(filme => filme && filme.id === id);

	if(index !== -1){
		filmes.splice(index, 1);
		return res.status(200).json({message: 'Filme removido com sucesso!'});
	}
	
	return res.status(404).json({message: 'Filme não encontrado.'});
});

// ATUALIZAR UM FILME - MÉTODO HTTP PUT
app.put('/ws/filme/:id', function(req, res){
	const id = Number(req.params.id);
	const { titulo, favorito } = req.body;

	if(!id){
		return res.status(400).json({message: 'ID do filme é obrigatório.'});
	}

	const filme = filmes.find(f => f && f.id === id);

	if(!filme){
		return res.status(404).json({message: 'Filme não encontrado.'});
	}

	if(titulo !== undefined && titulo.trim() !== ''){
		filme.titulo = titulo.trim();
	}
	
	if(favorito !== undefined){
		filme.favorito = favorito;
	}	

	return res.status(200).json(filme);
});

app.listen(3000, function(){
	console.log("Servidor HTTP no AR - Porta 3000");
});

app.use((err, req, res, next) => {
	console.error(err.stack);
	res.status(500).send('Algo deu errado!');
}	);