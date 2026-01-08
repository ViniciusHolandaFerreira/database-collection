-- ----------------------------------------------------------------------------
-- 1. CRIAÇÃO DO DATABASE E AMBIENTE
-- ----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS TechFlow;
USE TechFlow;

-- ----------------------------------------------------------------------------
-- 2. LIMPEZA DE ESTRUTURAS EXISTENTES (Garante um ambiente limpo para o script)
-- A ordem de DROP respeita as chaves estrangeiras para evitar erros de restrição.
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS pedidos_has_produtos;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS produtos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS BC_precos_produtos;

-- ----------------------------------------------------------------------------
-- 3. TABELA DE CLIENTES
-- Armazena informações básicas e data de cadastro.
-- ----------------------------------------------------------------------------
CREATE TABLE clientes(
    i_id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    v_nome_cliente VARCHAR(100) NOT NULL,
    v_email_cliente VARCHAR(100) UNIQUE NOT NULL,
    d_adesao_cliente DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- 4. TABELA DE PRODUTOS
-- Catálogo de itens disponíveis para venda e saldo de estoque.
-- ----------------------------------------------------------------------------
CREATE TABLE produtos(
    i_id_produto INT PRIMARY KEY AUTO_INCREMENT,
    v_nome_produto VARCHAR(100) NOT NULL,
    v_categoria_produto VARCHAR(50) NOT NULL,
    v_descricao_produto TEXT NOT NULL,
    i_estoque_produto INT NOT NULL DEFAULT 0,
    f_precoUnitario_produto DECIMAL(10,2) NOT NULL
);

-- ----------------------------------------------------------------------------
-- 5. TABELA DE PEDIDOS (Cabeçalho)
-- Armazena o resumo do pedido e o vínculo com o cliente.
-- ----------------------------------------------------------------------------
CREATE TABLE pedidos(
    i_id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    d_data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    f_valorTotal_pedido DECIMAL(10,2) DEFAULT 0.00,
    i_id_cliente INT NOT NULL,
    CONSTRAINT fk_pedidos_clientes 
        FOREIGN KEY(i_id_cliente) 
        REFERENCES clientes(i_id_cliente)
);

-- ----------------------------------------------------------------------------
-- 6. TABELA RELACIONAL: PEDIDOS_HAS_PRODUTOS (Itens do Pedido)
-- Tabela intermediária que permite múltiplos produtos em um único pedido.
-- ----------------------------------------------------------------------------
CREATE TABLE pedidos_has_produtos(
    i_id_pedido INT NOT NULL,
    i_id_produto INT NOT NULL,
    i_quantidade_pedidosHasProdutos INT NOT NULL,
    f_precoVenda_pedidosHasProdutos DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (i_id_pedido, i_id_produto),
    CONSTRAINT fk_pedidosHasProdutos_pedidos 
        FOREIGN KEY(i_id_pedido) 
        REFERENCES pedidos(i_id_pedido),
    CONSTRAINT fk_pedidosHasProdutos_produtos 
        FOREIGN KEY(i_id_produto) 
        REFERENCES produtos(i_id_produto)
);

-- ----------------------------------------------------------------------------
-- 7. TABELA DE AUDITORIA: BC_PRECOS_PRODUTOS
-- Destinada ao armazenamento histórico de variações de preços via Trigger.
-- ----------------------------------------------------------------------------
CREATE TABLE BC_precos_produtos(
    i_id_BC INT PRIMARY KEY AUTO_INCREMENT,
    i_id_produto INT NOT NULL,
    f_preco_antigo DECIMAL(10,2) NOT NULL,
    f_preco_novo DECIMAL(10,2) NOT NULL,
    d_data_alteracao DATETIME DEFAULT CURRENT_TIMESTAMP,
    v_usuario_alteracao VARCHAR(50)
);


