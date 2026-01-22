CREATE DATABASE IF NOT EXISTS Oficina;
USE Oficina;

CREATE TABLE cliente (
    i_id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    v_nome_cliente VARCHAR(255) NOT NULL,
    v_cpf_cliente VARCHAR(11) NOT NULL UNIQUE
);

CREATE TABLE funcionario (
    i_id_funcionario INT PRIMARY KEY AUTO_INCREMENT,
    v_nome_funcionario VARCHAR(255) NOT NULL,
    v_cpf_funcionario VARCHAR(11) NOT NULL UNIQUE
);

CREATE TABLE peca (
    i_id_peca INT PRIMARY KEY AUTO_INCREMENT,
    v_nome_peca VARCHAR(255) NOT NULL,
    f_valor_peca DECIMAL(10,2) NOT NULL,
    i_qtd_peca INT NOT NULL DEFAULT 0
);

CREATE TABLE pedido (
    i_id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    d_data_pedido DATE NOT NULL,
    f_valorTotal_pedido DECIMAL(10,2),
    v_formaPagamento_pedido VARCHAR(100),
    id_cliente INT,
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente (i_id_cliente)
);

CREATE TABLE automovel (
    i_id_automovel INT PRIMARY KEY AUTO_INCREMENT,
    v_categoria_automovel VARCHAR(50),
    v_placa_automovel VARCHAR(10) NOT NULL UNIQUE,
    v_cor_automovel VARCHAR(50),
    v_modelo_automovel VARCHAR(100),
    id_cliente INT,
    CONSTRAINT fk_automovel_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente (i_id_cliente)
);

CREATE TABLE conserto (
    i_id_conserto INT PRIMARY KEY AUTO_INCREMENT,
    d_dataHora_conserto DATETIME NOT NULL,
    id_funcionario INT,
    id_automovel INT,
    CONSTRAINT fk_conserto_automovel
        FOREIGN KEY (id_automovel)
        REFERENCES automovel (i_id_automovel),
    CONSTRAINT fk_conserto_funcionario
        FOREIGN KEY (id_funcionario)
        REFERENCES funcionario (i_id_funcionario)
);

CREATE TABLE conserto_has_peca (
    id_conserto INT,
    id_peca INT,
    i_qtd_consertoHasPeca INT NOT NULL,
    PRIMARY KEY (id_conserto, id_peca),
    CONSTRAINT fk_chp_conserto
        FOREIGN KEY (id_conserto)
        REFERENCES conserto (i_id_conserto),
    CONSTRAINT fk_chp_peca
        FOREIGN KEY (id_peca)
        REFERENCES peca (i_id_peca)
);

CREATE TABLE pedido_has_peca (
    id_peca INT,
    id_pedido INT,
    i_qtd_pedidoHasPeca INT NOT NULL,
    PRIMARY KEY (id_peca, id_pedido),
    CONSTRAINT fk_php_peca
        FOREIGN KEY (id_peca)
        REFERENCES peca (i_id_peca),
    CONSTRAINT fk_php_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES pedido (i_id_pedido)
);


USE Oficina;

-- 1. Inserir Clientes
INSERT INTO cliente (v_nome_cliente, v_cpf_cliente) VALUES 
('João Silva', '12345678901'),
('Maria Oliveira', '23456789012'),
('Carlos Souza', '34567890123'),
('Ana Costa', '45678901234'),
('Paulo Santos', '56789012345');

-- 2. Inserir Funcionários
INSERT INTO funcionario (v_nome_funcionario, v_cpf_funcionario) VALUES 
('Ricardo Técnico', '98765432100'),
('Roberto Mecânico', '87654321099'),
('Julia Especialista', '76543210988'),
('Marcos Auxiliar', '65432109877'),
('Sandra Supervisora', '54321098766');

-- 3. Inserir Peças
INSERT INTO peca (v_nome_peca, f_valor_peca, i_qtd_peca) VALUES 
('Filtro de Óleo', 45.50, 50),
('Pastilha de Freio', 120.00, 30),
('Vela de Ignição', 35.00, 100),
('Amortecedor Dianteiro', 350.00, 12),
('Correia Dentada', 85.00, 15);

-- 4. Inserir Automóveis (vinculados aos clientes)
INSERT INTO automovel (v_categoria_automovel, v_placa_automovel, v_cor_automovel, v_modelo_automovel, id_cliente) VALUES 
('Sedan', 'ABC1D23', 'Preto', 'Toyota Corolla', 1),
('Hatch', 'XYZ9E87', 'Prata', 'VW Gol', 2),
('SUV', 'KJH4F56', 'Branco', 'Jeep Compass', 3),
('Picape', 'LMN2G34', 'Azul', 'Ford Ranger', 4),
('Sedan', 'OPQ8H90', 'Vermelho', 'Honda Civic', 5);

-- 5. Inserir 5 Vendas (Pedidos de Peças)
INSERT INTO pedido (d_data_pedido, f_valorTotal_pedido, v_formaPagamento_pedido, id_cliente) VALUES 
('2026-01-10', 91.00, 'Cartão de Crédito', 1),
('2026-01-12', 120.00, 'PIX', 2),
('2026-01-15', 35.00, 'Dinheiro', 3),
('2026-01-18', 700.00, 'Cartão de Débito', 4),
('2026-01-20', 85.00, 'PIX', 5);

-- Relacionar peças às vendas (Tabela Associativa pedido_has_peca)
INSERT INTO pedido_has_peca (id_peca, id_pedido, i_qtd_pedidoHasPeca) VALUES 
(1, 1, 2), 
(2, 2, 1), 
(3, 3, 1), 
(4, 4, 2), 
(5, 5, 1);

-- 6. Inserir 5 Consertos
INSERT INTO conserto (d_dataHora_conserto, id_funcionario, id_automovel) VALUES 
('2026-01-10 09:00:00', 1, 1),
('2026-01-12 14:30:00', 2, 2),
('2026-01-15 10:00:00', 3, 3), -- Conserto sem peças (para teste de filtro)
('2026-01-18 16:00:00', 4, 4),
('2026-01-20 11:00:00', 5, 5);

-- Relacionar peças aos consertos (Tabela Associativa conserto_has_peca)
-- O conserto de ID 3 não receberá peças para atender ao requisito de filtro do enunciado
INSERT INTO conserto_has_peca (id_conserto, id_peca, i_qtd_consertoHasPeca) VALUES 
(1, 1, 1),
(2, 2, 2),
(4, 4, 1),
(5, 5, 1);

/*
1) Relatório de Vendas: Listar todas as vendas contendo os dados da venda, dados do cliente e as peças compradas.
*/


SELECT
	cliente.v_nome_cliente,
    cliente.v_cpf_cliente,
	pedido.d_data_pedido,
    pedido.f_valorTotal_pedido,
    pedido.v_formaPagamento_pedido,
    PHP.i_qtd_pedidoHasPeca,
    peca.v_nome_peca,
    peca.f_valor_peca,
    peca.i_qtd_peca
FROM pedido
	INNER JOIN cliente ON pedido.id_cliente = cliente.i_id_cliente
    INNER JOIN pedido_has_peca PHP ON pedido.i_id_pedido = PHP.id_pedido
    INNER JOIN peca ON PHP.id_peca = peca.i_id_peca;

/*
2) Relatório de Consertos: Listar todos os consertos, identificando os carros, a quais clientes pertencem e quais peças foram utilizadas.
*/

SELECT
	conserto.i_id_conserto,
    conserto.d_dataHora_conserto,
    automovel.*,
    cliente.*,
    peca.*
FROM conserto
	INNER JOIN automovel ON conserto.id_automovel = automovel.i_id_automovel
    INNER JOIN cliente ON automovel.id_cliente = cliente.i_id_cliente
    INNER JOIN conserto_has_peca CHP ON conserto.i_id_conserto = CHP.id_conserto
    INNER JOIN peca ON CHP.id_peca = peca.i_id_peca;


/*
3) Filtro de Serviços: Listar especificamente os consertos de carros que não geraram consumo de peças.
*/

SELECT
	*
FROM conserto
	INNER JOIN automovel ON conserto.id_automovel = automovel.i_id_automovel
	LEFT JOIN conserto_has_peca CHP ON conserto.i_id_conserto = CHP.id_conserto
    WHERE CHP.id_conserto IS NULL
    