// Conexao centralizada com o MySQL.
// O banco padrao e livraria_db, mas as rotas dos exercicios usam o nome completo
// do banco (ex.: loja_informatica_db.produto) para acessar os outros projetos.
import mysql from 'mysql2';

const bd = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'root',
  database: 'livraria_db'
});

bd.connect((erro) => {
  if (erro) console.error('Erro no MySQL:', erro.message);
  else console.log('Conectado ao MySQL com sucesso!');
});

export default bd;
