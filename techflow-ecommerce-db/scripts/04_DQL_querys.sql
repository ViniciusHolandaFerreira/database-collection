
-- ----------------------------------------------------------------------------
-- (1) Ranking de Produtos Mais Vendidos (Mensal)
-- Problema de Negócio: Identificar os 3 produtos com maior giro no último mês 
-- para otimizar o estoque e estratégias de marketing.
-- ----------------------------------------------------------------------------

SELECT
    PROD.v_nome_produto AS Produto,
    SUM(PHP.i_quantidade_pedidosHASProdutos) AS QTD_vendida
FROM pedidos_has_produtos AS PHP
    INNER JOIN produtos PROD ON PHP.i_id_produto = PROD.i_id_produto
    INNER JOIN pedidos PED ON PHP.i_id_pedido = PED.i_id_pedido
    WHERE PED.d_data_pedido >= DATE_SUB(NOW(), INTERVAL 1 MONTH)
    GROUP BY PROD.v_nome_produto
    ORDER BY QTD_vendida DESC
    LIMIT 3;


-- ----------------------------------------------------------------------------
-- (2) Retenção de Clientes (Churn Analysis)
-- Problema de Negócio: Identificar clientes que não realizam compras há mais 
-- de 6 meses para direcionar campanhas de reativação.
-- ----------------------------------------------------------------------------

SELECT
    c.v_nome_cliente AS Cliente
FROM clientes c
WHERE c.i_id_cliente NOT IN (
    SELECT 
        p.i_id_cliente
    FROM pedidos p
        WHERE p.d_data_pedido >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
);

-- ----------------------------------------------------------------------------
-- (3) Performance de Vendas por Categoria
-- Problema de Negócio: Relatório detalhado dos produtos líderes de venda 
-- incluindo sua categoria, auxiliando na análise de mix de produtos.
-- ----------------------------------------------------------------------------

SELECT
    PROD.v_nome_produto,
    PROD.v_categoria_produto,
    SUM(PHP.i_quantidade_pedidosHASProdutos) AS total_vendido
FROM pedidos_has_produtos PHP
    INNER JOIN produtos PROD ON PHP.i_id_produto = PROD.i_id_produto
    INNER JOIN pedidos PED ON PHP.i_id_pedido = PED.i_id_pedido
    WHERE PED.d_data_pedido >= DATE_SUB(NOW(), INTERVAL 1 MONTH)
    GROUP BY PROD.v_nome_produto, PROD.v_categoria_produto
    ORDER BY total_vendido DESC
    LIMIT 3;

-- ----------------------------------------------------------------------------
-- (4) Análise de Clientes VIP (Lifetime Value)
-- Problema de Negócio: Identificar os 5 clientes com maior faturamento 
-- acumulado na história da empresa para programas de fidelidade.
-- ----------------------------------------------------------------------------

SELECT
    c.v_nome_cliente AS Cliente,
    SUM(p.f_valorTotal_pedido) AS Valor_Total_Acumulado
FROM pedidos p
    INNER JOIN clientes c ON p.i_id_cliente = c.i_id_cliente
    GROUP BY c.v_nome_cliente
    ORDER BY Valor_Total_Acumulado DESC
    LIMIT 5;

-- ----------------------------------------------------------------------------
-- (5) Gestão de Inventário: Produtos Sem Giro
-- Problema de Negócio: Identificar produtos do catálogo que nunca foram 
-- vendidos ou que estão sem saída há mais de 90 dias, visando a redução 
-- de custos de armazenamento.
-- ----------------------------------------------------------------------------

-- (5.1) Produtos que nunca foram incluídos em pedidos
SELECT
    v_nome_produto
FROM produtos
WHERE i_id_produto NOT IN (
    SELECT 
        i_id_produto 
    FROM pedidos_has_produtos 
        WHERE i_id_produto IS NOT NULL
);

-- (5.2) Produtos sem vendas nos últimos 90 dias
SELECT
    PROD.v_nome_produto
FROM produtos PROD
WHERE PROD.i_id_produto NOT IN (
    SELECT 
        PHP.i_id_produto
    FROM pedidos_has_produtos PHP
    INNER JOIN pedidos PED ON PHP.i_id_pedido = PED.i_id_pedido
    WHERE PED.d_data_pedido >= DATE_SUB(NOW(), INTERVAL 3 MONTH)
    AND PHP.i_id_produto IS NOT NULL
);

-- ----------------------------------------------------------------------------
-- (6) Relatório de Faturamento Mensal (Sazonalidade)
-- Problema de Negócio: Acompanhamento da saúde financeira mensal para 
-- análise de sazonalidade e crescimento ano a ano.
-- ----------------------------------------------------------------------------

SELECT
    YEAR(d_data_pedido) AS Ano,
    MONTH(d_data_pedido) AS Mes,
    SUM(f_valorTotal_pedido) AS Faturamento_Mensal
FROM pedidos
    GROUP BY Ano, Mes
    ORDER BY Ano DESC, Mes DESC;











