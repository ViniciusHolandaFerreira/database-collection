
-- ----------------------------------------------------------------------------
-- 1. GESTÃO FINANCEIRA: ATUALIZAÇÃO DO TOTAL DO PEDIDO
-- Mantém o campo f_valorTotal_pedido atualizado em tempo real.
-- ----------------------------------------------------------------------------

DELIMITER $$

-- # Atualiza total após inserir novo item
CREATE TRIGGER TG_calcularTotal_INSERT
AFTER INSERT ON pedidos_has_produtos
FOR EACH ROW
BEGIN 
    UPDATE pedidos 
    SET f_valorTotal_pedido = (
        SELECT COALESCE(SUM(i_quantidade_pedidosHasProdutos * f_precoVenda_pedidosHasProdutos), 0)
        FROM pedidos_has_produtos
        WHERE i_id_pedido = NEW.i_id_pedido
    )
    WHERE i_id_pedido = NEW.i_id_pedido;
END $$

-- # Atualiza total após remover um item
CREATE TRIGGER TG_calcularTotal_DELETE
AFTER DELETE ON pedidos_has_produtos
FOR EACH ROW
BEGIN
    UPDATE pedidos 
    SET f_valorTotal_pedido = (
        SELECT COALESCE(SUM(i_quantidade_pedidosHasProdutos * f_precoVenda_pedidosHasProdutos), 0)
        FROM pedidos_has_produtos
        WHERE i_id_pedido = OLD.i_id_pedido
    )
    WHERE i_id_pedido = OLD.i_id_pedido;
END $$

-- # Atualiza total após alterar quantidade ou preço de um item
CREATE TRIGGER TG_calcularTotal_UPDATE
AFTER UPDATE ON pedidos_has_produtos
FOR EACH ROW
BEGIN
    UPDATE pedidos 
    SET f_valorTotal_pedido = (
        SELECT COALESCE(SUM(i_quantidade_pedidosHasProdutos * f_precoVenda_pedidosHasProdutos), 0)
        FROM pedidos_has_produtos
        WHERE i_id_pedido = NEW.i_id_pedido
    )
    WHERE i_id_pedido = NEW.i_id_pedido;
END $$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- 2. GESTÃO DE INVENTÁRIO: CONTROLE DE ESTOQUE AUTOMATIZADO
-- Gerencia a entrada e saída física dos produtos no armazém.
-- ----------------------------------------------------------------------------

DELIMITER $$

-- # Baixa de estoque após venda confirmada
CREATE TRIGGER TG_controlarEstoque_INSERT
AFTER INSERT ON pedidos_has_produtos
FOR EACH ROW
BEGIN 
    UPDATE produtos 
    SET i_estoque_produto = i_estoque_produto - NEW.i_quantidade_pedidosHasProdutos
    WHERE i_id_produto = NEW.i_id_produto; 
END $$

-- # Reposição de estoque após remoção de item do pedido
CREATE TRIGGER TG_controlarEstoque_DELETE
AFTER DELETE ON pedidos_has_produtos
FOR EACH ROW
BEGIN 
    UPDATE produtos 
    SET i_estoque_produto = i_estoque_produto + OLD.i_quantidade_pedidosHasProdutos
    WHERE i_id_produto = OLD.i_id_produto; 
END $$

-- # Ajuste de estoque para alterações de quantidade no pedido
CREATE TRIGGER TG_controlarEstoque_UPDATE
AFTER UPDATE ON pedidos_has_produtos
FOR EACH ROW
BEGIN 
    UPDATE produtos 
    SET i_estoque_produto = (i_estoque_produto + OLD.i_quantidade_pedidosHasProdutos) - NEW.i_quantidade_pedidosHasProdutos
    WHERE i_id_produto = NEW.i_id_produto; 
END $$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- 3. AUDITORIA: HISTÓRICO DE PREÇOS
-- Rastreia alterações de preços para análise de mercado e segurança.
-- ----------------------------------------------------------------------------

DELIMITER $$

CREATE TRIGGER TG_SalvarPrecosProdutos_UPDATE
AFTER UPDATE ON produtos
FOR EACH ROW
BEGIN
    -- Dispara apenas se o preço unitário sofrer alteração
    IF (OLD.f_precoUnitario_produto != NEW.f_precoUnitario_produto) THEN
        INSERT INTO BC_precos_produtos (
            i_id_produto, 
            f_preco_antigo,
            f_preco_novo,
            v_usuario_alteracao
        )
        VALUES (
            OLD.i_id_produto, 
            OLD.f_precoUnitario_produto, 
            NEW.f_precoUnitario_produto,
            USER() 
        ); 
    END IF;
END $$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- 4. SEGURANÇA: VALIDAÇÃO DE ESTOQUE DISPONÍVEL (FAIL-SAFE)
-- Impede a venda se a quantidade solicitada for maior que o estoque.
-- ----------------------------------------------------------------------------

DELIMITER $$

CREATE TRIGGER TG_FaltaDEestoque_INSERT
BEFORE INSERT ON pedidos_has_produtos
FOR EACH ROW
BEGIN
    DECLARE v_estoque_atual INT;

    SET v_estoque_atual = (
        SELECT i_estoque_produto 
        FROM produtos
        WHERE i_id_produto = NEW.i_id_produto
    );

    IF (NEW.i_quantidade_pedidosHasProdutos > v_estoque_atual) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro TechFlow: Estoque insuficiente para realizar esta venda.';
    END IF;
END $$

DELIMITER ;