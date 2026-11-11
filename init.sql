-- ============================================================
-- PRATICA 03: BANCOS DE DADOS PARA O APP REACT NATIVE
-- SGBD: MySQL
-- Execute este arquivo uma vez para criar os quatro bancos.
-- ATENCAO: os DROP DATABASE apagam os bancos homonimos existentes.
-- ============================================================

-- ------------------------------------------------------------
-- EXEMPLO DA LIVRARIA
-- ------------------------------------------------------------
DROP DATABASE IF EXISTS livraria_db;
CREATE DATABASE livraria_db;
USE livraria_db;

CREATE TABLE cliente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    data_cadastro DATE NOT NULL
);

CREATE TABLE livro (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    autor VARCHAR(100) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    estoque INT NOT NULL
);

CREATE TABLE pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_livro INT NOT NULL,
    data_pedido DATE NOT NULL,
    quantidade INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id),
    FOREIGN KEY (id_livro) REFERENCES livro(id)
);

INSERT INTO cliente (nome, email, data_cadastro) VALUES
('Ana Silva', 'ana.silva@email.com', '2026-01-15'),
('Bruno Costa', 'bruno.costa@email.com', '2026-02-10');

INSERT INTO livro (titulo, autor, preco, estoque) VALUES
('Introducao ao SQL', 'Luke Code', 49.90, 15),
('Bancos de Dados Relacionais', 'Maria Ramalho', 89.90, 8);

INSERT INTO pedido (id_cliente, id_livro, data_pedido, quantidade) VALUES
(1, 1, '2026-03-05', 1),
(2, 2, '2026-03-06', 2);

-- ------------------------------------------------------------
-- EXERCICIO 1: LOJA DE EQUIPAMENTOS DE INFORMATICA
-- ------------------------------------------------------------
DROP DATABASE IF EXISTS loja_informatica_db;
CREATE DATABASE loja_informatica_db;
USE loja_informatica_db;

CREATE TABLE cliente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    data_cadastro DATE NOT NULL
);

CREATE TABLE produto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    marca VARCHAR(80) NOT NULL,
    categoria VARCHAR(80) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    estoque INT NOT NULL DEFAULT 0
);

CREATE TABLE pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_produto INT NOT NULL,
    data_pedido DATE NOT NULL,
    quantidade INT NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id),
    FOREIGN KEY (id_produto) REFERENCES produto(id)
);

INSERT INTO cliente (nome, email, telefone, data_cadastro) VALUES
('Mariana Alves', 'mariana@email.com', '31999990001', '2026-01-10'),
('Pedro Lima', 'pedro@email.com', '31999990002', '2026-02-15');

INSERT INTO produto (nome, marca, categoria, preco, estoque) VALUES
('Notebook IdeaPad', 'Lenovo', 'Notebook', 3299.90, 10),
('Mouse sem fio', 'Logitech', 'Acessorio', 89.90, 35);

INSERT INTO pedido (id_cliente, id_produto, data_pedido, quantidade, valor_total) VALUES
(1, 1, '2026-04-02', 1, 3299.90),
(2, 2, '2026-04-03', 2, 179.80);

-- ------------------------------------------------------------
-- EXERCICIO 2: SITE DE VIAGENS
-- ------------------------------------------------------------
DROP DATABASE IF EXISTS site_viagens_db;
CREATE DATABASE site_viagens_db;
USE site_viagens_db;

CREATE TABLE cliente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    data_cadastro DATE NOT NULL
);

CREATE TABLE destino_turistico (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    pais VARCHAR(80) NOT NULL,
    cidade VARCHAR(80) NOT NULL,
    descricao TEXT
);

CREATE TABLE pacote_viagem (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_destino INT NOT NULL,
    nome_pacote VARCHAR(120) NOT NULL,
    data_partida DATE NOT NULL,
    data_retorno DATE NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id),
    FOREIGN KEY (id_destino) REFERENCES destino_turistico(id)
);

INSERT INTO cliente (nome, email, telefone, data_cadastro) VALUES
('Camila Rocha', 'camila@email.com', '31988880001', '2026-01-12'),
('Rafael Mendes', 'rafael@email.com', '31988880002', '2026-02-18');

INSERT INTO destino_turistico (nome, pais, cidade, descricao) VALUES
('Cristo Redentor', 'Brasil', 'Rio de Janeiro', 'Ponto turistico do Rio de Janeiro.'),
('Torre Eiffel', 'Franca', 'Paris', 'Monumento famoso de Paris.');

INSERT INTO pacote_viagem
(id_cliente, id_destino, nome_pacote, data_partida, data_retorno, preco) VALUES
(1, 1, 'Fim de semana no Rio', '2027-01-10', '2027-01-14', 1800.00),
(2, 2, 'Conhecendo Paris', '2027-02-05', '2027-02-13', 7500.00);

-- ------------------------------------------------------------
-- EXERCICIO 3: CONTROLE DE ESTOQUE POR FILIAL
-- ------------------------------------------------------------
DROP DATABASE IF EXISTS estoque_filiais_db;
CREATE DATABASE estoque_filiais_db;
USE estoque_filiais_db;

CREATE TABLE fornecedor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    telefone VARCHAR(20),
    endereco VARCHAR(180)
);

CREATE TABLE produto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_fornecedor INT NOT NULL,
    nome VARCHAR(120) NOT NULL,
    FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id)
);

-- O campo id_produto foi incluido para materializar o relacionamento 1:1
-- descrito no enunciado entre Produto e Identificacao.
CREATE TABLE identificacao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT NOT NULL UNIQUE,
    descricao VARCHAR(180) NOT NULL,
    observacao TEXT,
    FOREIGN KEY (id_produto) REFERENCES produto(id)
);

CREATE TABLE filial (
    cnpj VARCHAR(18) PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    telefone VARCHAR(20),
    endereco VARCHAR(180)
);

-- Chave primaria composta: o mesmo produto pode estar em varias filiais,
-- e cada filial pode manter varios produtos.
CREATE TABLE estoque (
    id_produto INT NOT NULL,
    cnpj_filial VARCHAR(18) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    quantidade INT NOT NULL,
    validade DATE,
    PRIMARY KEY (id_produto, cnpj_filial),
    FOREIGN KEY (id_produto) REFERENCES produto(id),
    FOREIGN KEY (cnpj_filial) REFERENCES filial(cnpj)
);

INSERT INTO fornecedor (nome, telefone, endereco) VALUES
('Tech Distribuidora', '3133331000', 'Rua das Industrias, 100'),
('Global Suprimentos', '3133332000', 'Avenida Central, 250');

INSERT INTO produto (id_fornecedor, nome) VALUES
(1, 'Mouse sem fio'),
(1, 'Teclado USB'),
(2, 'Monitor LED');

INSERT INTO identificacao (id_produto, descricao, observacao) VALUES
(1, 'Mouse optico USB', 'Cor preta'),
(2, 'Teclado ABNT2', 'Layout brasileiro'),
(3, 'Monitor de 24 polegadas', 'Tela LED');

INSERT INTO filial (cnpj, nome, telefone, endereco) VALUES
('12.345.678/0001-90', 'Filial Centro', '3133333000', 'Rua A, 100'),
('98.765.432/0001-10', 'Filial Pampulha', '3133334000', 'Avenida B, 250');

INSERT INTO estoque (id_produto, cnpj_filial, preco, quantidade, validade) VALUES
(1, '12.345.678/0001-90', 89.90, 25, NULL),
(2, '12.345.678/0001-90', 129.90, 15, NULL),
(1, '98.765.432/0001-10', 94.90, 10, NULL),
(3, '98.765.432/0001-10', 899.90, 7, NULL);

-- Consultas iniciais para conferir o relacionamento de estoque.
SELECT f.nome AS filial, p.nome AS produto, e.preco, e.quantidade, e.validade
FROM estoque e
INNER JOIN filial f ON e.cnpj_filial = f.cnpj
INNER JOIN produto p ON e.id_produto = p.id
ORDER BY f.nome, p.nome;
