import express from 'express';
import cors from 'cors';
import listarLivros from './rotas/listarLivros.js';
import buscarLivroPorId from './rotas/buscarLivroPorId.js';
import cadastrarLivro from './rotas/cadastrarLivro.js';
import atualizarLivro from './rotas/atualizarLivro.js';
import removerLivro from './rotas/removerLivro.js';
import criarRotasCrud from './rotas/criarRotasCrud.js';

const app = express();
app.use(cors());
app.use(express.json());

// Rotas da livraria: os cinco arquivos separados seguem o modelo do professor.
app.get('/livros', listarLivros);
app.get('/livros/:id', buscarLivroPorId);
app.post('/livros', cadastrarLivro);
app.put('/livros/:id', atualizarLivro);
app.delete('/livros/:id', removerLivro);

// Rotas adicionais para completar os exercícios 1 a 4.
app.use('/livraria/clientes', criarRotasCrud({"banco": "livraria_db", "tabela": "cliente", "campos": ["id", "nome", "email", "data_cadastro"], "chaves": ["id"]}));
app.use('/pedidos-livraria', criarRotasCrud({"banco": "livraria_db", "tabela": "pedido", "campos": ["id", "id_cliente", "id_livro", "data_pedido", "quantidade"], "chaves": ["id"]}));
app.use('/loja/clientes', criarRotasCrud({"banco": "loja_informatica_db", "tabela": "cliente", "campos": ["id", "nome", "email", "telefone", "data_cadastro"], "chaves": ["id"]}));
app.use('/loja/produtos', criarRotasCrud({"banco": "loja_informatica_db", "tabela": "produto", "campos": ["id", "nome", "marca", "categoria", "preco", "estoque"], "chaves": ["id"]}));
app.use('/loja/pedidos', criarRotasCrud({"banco": "loja_informatica_db", "tabela": "pedido", "campos": ["id", "id_cliente", "id_produto", "data_pedido", "quantidade", "valor_total"], "chaves": ["id"]}));
app.use('/viagens/clientes', criarRotasCrud({"banco": "site_viagens_db", "tabela": "cliente", "campos": ["id", "nome", "email", "telefone", "data_cadastro"], "chaves": ["id"]}));
app.use('/viagens/destinos', criarRotasCrud({"banco": "site_viagens_db", "tabela": "destino_turistico", "campos": ["id", "nome", "pais", "cidade", "descricao"], "chaves": ["id"]}));
app.use('/viagens/pacotes', criarRotasCrud({"banco": "site_viagens_db", "tabela": "pacote_viagem", "campos": ["id", "id_cliente", "id_destino", "nome_pacote", "data_partida", "data_retorno", "preco"], "chaves": ["id"]}));
app.use('/estoque/fornecedores', criarRotasCrud({"banco": "estoque_filiais_db", "tabela": "fornecedor", "campos": ["id", "nome", "telefone", "endereco"], "chaves": ["id"]}));
app.use('/estoque/produtos', criarRotasCrud({"banco": "estoque_filiais_db", "tabela": "produto", "campos": ["id", "id_fornecedor", "nome"], "chaves": ["id"]}));
app.use('/estoque/identificacoes', criarRotasCrud({"banco": "estoque_filiais_db", "tabela": "identificacao", "campos": ["id", "id_produto", "descricao", "observacao"], "chaves": ["id"]}));
app.use('/estoque/filiais', criarRotasCrud({"banco": "estoque_filiais_db", "tabela": "filial", "campos": ["cnpj", "nome", "telefone", "endereco"], "chaves": ["cnpj"]}));
app.use('/estoque/itens', criarRotasCrud({"banco": "estoque_filiais_db", "tabela": "estoque", "campos": ["id_produto", "cnpj_filial", "preco", "quantidade", "validade"], "chaves": ["id_produto", "cnpj_filial"]}));

app.listen(3000, '0.0.0.0', () => {
  console.log('API (CRUD) ativa na porta 3000.');
});
