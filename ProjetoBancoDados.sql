
PRAGMA foreign_key = ON;

-- criar tabelas (Rayane Barbosa)
CREATE TABLE Categoria (
    codigo integer PRIMARY KEY autoincrement not null,
    nome text,
    descricao text
);

CREATE TABLE Produto (
    codigo integer PRIMARY KEY autoincrement not null,
    nome text,
    descricao text,
    quantidade_estoque integer,
    data_fabricacao date,
    valor_unitario DECIMAL(10, 2),
    categoria_codigo integer,
    funcionario_codigo integer,
    FOREIGN KEY (categoria_codigo) REFERENCES Categoria(codigo)
    FOREIGN KEY (funcionario_codigo) REFERENCES Funcionario(codigo)
);


CREATE TABLE Cliente (
    codigo integer PRIMARY KEY autoincrement not null,
    nome_completo text,
    nome_usuario text,
    email text,
    cpf text,
    data_nascimento date,
    endereco text
);

CREATE TABLE Funcionario (
    codigo integer PRIMARY KEY autoincrement not null,
    nome text,
    cpf text
);

CREATE TABLE Pedido (
    codigo integer PRIMARY KEY autoincrement not null,
    data_pedido date,
    cliente_codigo integer,
    FOREIGN KEY (cliente_codigo) REFERENCES Cliente(codigo)
);

CREATE TABLE Pedido_Produto (
    pedido_codigo integer,
    produto_codigo integer,
    quantidade integer,
    PRIMARY KEY (pedido_codigo, produto_codigo),
    FOREIGN KEY (pedido_codigo) REFERENCES Pedido(codigo),
    FOREIGN KEY (produto_codigo) REFERENCES Produto(codigo )
);

-- inserir 5 produtos (João Pedro Alves)
INSERT INTO Produto(nome, descricao , quantidade_estoque, data_fabricacao, valor_unitario, categoria_codigo, funcionario_codigo)
VALUES 
	('Camisa Social Masculina Slim', 'Camisa Social Masculina, Slim, Fio 80', 100, '2023-08-01', 79.99,3,5),
	('Vestido Feminino', 'Vestido Feminino da Dafiti', 100, '2023-08-01', 99.99,4,3),
	('Vestuário Infantil', 'Vestuário Infantil da Loja Kyly', 100, '2023-08-01', 64.90,2,1),
	('Macacão Recém-Nascido', 'Macacão de recém nascido, tecido Soft', 100, '2023-08-01', 29.99,5,2),
	('Biquíni Ripple', 'Biquíni Ripple', 100, '2023-08-01', 89.99,1,4);

-- inserir 5 funcionarios (Taissa Gouvea)
INSERT INTO Funcionario (nome, cpf) VALUES 
	('João','829.617.175-90'),
	('Gabriela', '248.284.013-93'),
	('Pedro', '701.476.232-00'),
	('Maria', '661.418.542-06'),
	('Larissa', '728.068.519-63');

-- inserir 5 categorias (Paula Beatriz)
INSERT INTO Categoria (nome,descricao) VALUES
	('praia', 'moda praia'),
	('infantil', 'moda infatil'),
	('masculino', 'moda masculina'),
	('feminina', 'moda feminina' ),
	('recem nascido', 'moda RN');

-- inserir 5 pedidos (Rafael Ziviani)

INSERT INTO Pedido (data_pedido, cliente_codigo) VALUES
	('2023-08-23', 1),
	('2023-08-22', 2),
	('2023-08-25', 3),
	('2023-08-26', 4),
	('2023-08-26', 5);

INSERT INTO Pedido_Produto (pedido_codigo, produto_codigo, quantidade) VALUES
	(1, 1, 10),
	(2, 2, 12),
	(3, 3, 6), 
	(4, 4, 5),
	(5, 5, 1),
	(2, 4, 16), 
	(3, 5, 1),
	(4, 1, 1),
	(4, 2, 3),
	(1, 3, 1),
	(1, 5, 1);

-- inserir 5 cliente (Alex Oliveira)
INSERT INTO Cliente(nome_completo,cpf,nome_usuario,email,data_nascimento, endereco)
VALUES
	('Alex de Laurinha','17746328709','alexmatadordepombo','alexdrxx@gmail.com','1999-02-09','rua herminio goulart, 777'),
	('Rayanne Briane','01335868729','ray_barbie','rayannes2@gmail.com','1993-12-02','rua constantino, 44'),
	('Taissa Minna','13834033729','issataissa','taissanx0@gmail.com','1997-06-24','rua jurubeba, 1433'),
	('Rafael Papel','72797168739','rafaelzão','rafael_o_moreno@gmail.com','1991-08-17','rua do tunel, 33'),
	('Paula Beatriz','09362063719','paulinhabx','beatrizwinx@gmail.com','1998-02-02','rua da feira, 13');

-- Todos

-- alterar um registro pelo comando uptade 
UPDATE Produto
SET quantidade_estoque = 90
WHERE codigo = 3;

-- excluir um registro 
DELETE FROM Funcionario
WHERE codigo = 4;

-- SQLs de consulta
-- a. Pelo menos 2 com algum tipo de junção
SELECT Pedido.codigo AS Pedido, Cliente.nome_completo as Cliente, Cliente.email
FROM Pedido
JOIN Cliente ON Pedido.cliente_codigo = Cliente.codigo
WHERE Cliente.codigo = 1; 

SELECT Pedido.codigo AS Pedido, Produto.nome AS Produto, Produto.descricao AS Descricao, Categoria.nome AS Categoria
FROM Pedido_Produto
JOIN Pedido ON Pedido_Produto.pedido_codigo = Pedido.codigo
JOIN Produto ON Pedido_Produto.produto_codigo = Produto.codigo
JOIN Categoria ON Produto.categoria_codigo = Categoria.codigo
WHERE Pedido.codigo = 1; 

-- b. Pelo menos 1 com usando count() e group by()
SELECT pr.nome as Produto, COUNT(pp.pedido_codigo) AS Qtd_Pedidos
FROM Produto pr
JOIN Pedido_Produto pp ON pr.codigo = pp.pedido_codigo 
GROUP BY pr.codigo
ORDER by pp.pedido_codigo ASC

-- c. Uma consulta livre
SELECT Produto.nome, Produto.quantidade_estoque AS total_estoque
FROM Produto
GROUP BY Produto.nome;

-- d. 1 SQL para construção de nota fiscal
SELECT Pedido.codigo AS Pedido, 
       Cliente.nome_completo AS Cliente, 
       Funcionario.nome AS Funcionario, 
       Produto.nome AS Produto, 
       Pedido_Produto.quantidade AS Qtd_produto, 
       Produto.valor_unitario AS Valor,
       Pedido_Produto.quantidade * Produto.valor_unitario AS Valor_Total
FROM Pedido
JOIN Cliente ON Pedido.cliente_codigo = Cliente.codigo
JOIN Funcionario ON Pedido.cliente_codigo = Funcionario.codigo
JOIN Pedido_Produto ON Pedido.codigo = Pedido_Produto.pedido_codigo
JOIN Produto ON Pedido_Produto.produto_codigo = Produto.codigo
WHERE Pedido.codigo = 4
ORDER BY Valor_Total DESC;

