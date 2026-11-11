# Node.js + MySQL — API REST com rotas separadas

Este projeto continua a prática anterior e segue a estrutura apresentada pelo professor:
- `server.js`: importa as rotas e inicia o servidor;
- `bd.js`: centraliza a conexão com o MySQL;
- `rotas/`: contém os arquivos responsáveis pelos comandos SQL;
- `api.http`: testes da API pela extensão REST Client.

O projeto também implementa os quatro conjuntos de tabelas usados nas atividades.

## 1. Abrir no GitHub Codespaces

1. Envie os arquivos deste projeto para o repositório da atividade.
2. No GitHub, abra **Code > Codespaces > Create codespace on main**.
3. Aguarde o VS Code abrir no navegador.
4. Se necessário, use `Ctrl + Shift + P`, procure `Codespaces: Rebuild Container` e confirme o rebuild.

A extensão `humao.rest-client` já está indicada em `.devcontainer/devcontainer.json`.

## 2. Instalar dependências

No terminal, na raiz do projeto:

```bash
npm install
```

## 3. Iniciar o MySQL e criar os bancos

Se o MySQL ainda não estiver iniciado:

```bash
sudo mkdir -p /var/run/mysqld
sudo chown mysql:mysql /var/run/mysqld
sudo /usr/sbin/mysqld --user=mysql &
```

Importe as tabelas e os dados de exemplo:

```bash
sudo mysql -u root -proot < init.sql
```

O `init.sql` cria os bancos `livraria_db`, `loja_informatica_db`, `site_viagens_db` e `estoque_filiais_db`.

**Atenção:** o script contém `DROP DATABASE IF EXISTS`. Ele apaga e recria esses bancos. Faça backup antes de executar se já tiver dados importantes.

## 4. Configurar o Database Client

Na barra lateral do VS Code:
1. Abra o ícone Database Client.
2. Clique em `+` e escolha MySQL.
3. Host: `localhost`
4. User: `root`
5. Password: `root`
6. Database: `livraria_db` (ou deixe em branco)
7. Clique em Connect.

## 5. Iniciar a API

```bash
npm run dev
```

A API ficará disponível na porta `3000`. Mantenha esse terminal aberto.

## 6. Testar com REST Client

Abra `api.http`. Acima de cada requisição aparecerá **Send Request**. Clique para executar e visualizar o retorno.

Também é possível testar pelo navegador as rotas GET, por exemplo:

```text
http://localhost:3000/livros
http://localhost:3000/loja/produtos
http://localhost:3000/viagens/destinos
http://localhost:3000/estoque/fornecedores
```

## 7. Rotas disponíveis

### Exemplo da livraria
- `/livros` — GET, POST
- `/livros/:id` — GET, PUT, DELETE
- `/livraria/clientes` — CRUD de clientes da livraria
- `/pedidos-livraria` — lista pedidos da livraria

### Loja de informática
- `/loja/clientes`
- `/loja/produtos`
- `/loja/pedidos`

### Site de viagens
- `/viagens/clientes`
- `/viagens/destinos`
- `/viagens/pacotes`

### Controle de estoque das filiais
- `/estoque/fornecedores`
- `/estoque/produtos`
- `/estoque/identificacoes`
- `/estoque/filiais`
- `/estoque/itens`

Para rotas de recursos adicionais, a listagem é feita com GET na URL base. O CRUD também aceita GET por chave, POST, PUT e DELETE. No estoque, a chave é composta: `id_produto/cnpj_filial`.

## 8. Tornar a porta pública

1. Abra a aba **Ports** no VS Code do Codespaces.
2. Localize a porta `3000`.
3. Clique com o botão direito e escolha **Port Visibility > Public**.
4. Copie a URL encaminhada pelo Codespaces.

Use essa URL no aplicativo React Native no lugar de `http://localhost:3000`. Não use literalmente `https://github.dev`; cada Codespace gera sua própria URL.

## 9. Estrutura principal

```text
.
├── .devcontainer/
│   └── devcontainer.json
├── rotas/
│   ├── listarLivros.js
│   ├── buscarLivroPorId.js
│   ├── cadastrarLivro.js
│   ├── atualizarLivro.js
│   ├── removerLivro.js
│   └── criarRotasCrud.js
├── api.http
├── bd.js
├── init.sql
├── package.json
├── README.md
└── server.js
```

## Observações importantes

- Os cinco arquivos de rota de `livro` seguem o modelo separado demonstrado pelo professor.
- Para evitar criar dezenas de arquivos repetidos nos exercícios, as outras tabelas usam `criarRotasCrud.js`, que monta as operações CRUD a partir de configurações fixas no `server.js`.
- As rotas adicionais usam o nome completo do banco e da tabela. Assim, a mesma conexão MySQL consegue acessar os quatro bancos.
- A tabela `estoque` possui chave primária composta (`id_produto`, `cnpj_filial`); por isso, sua consulta por chave usa os dois valores.
- O projeto foi estruturado para a prática descrita. A execução final depende de importar o SQL, instalar as dependências e iniciar o MySQL no Codespaces.
