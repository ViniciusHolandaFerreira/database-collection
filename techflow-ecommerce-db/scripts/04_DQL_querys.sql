-- 1) A empresa que saber quais foram os 3 produtos mais vendidos no último mes


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
	
-- 2) Quais clientes não realizaram nenhuma compra nos últimos 6 meses 

SELECT
	c.v_nome_cliente
FROM clientes c
	WHERE c.i_id_cliente NOT IN(
		SELECT
			p.i_id_cliente
		FROM pedidos p
            WHERE p.d_data_pedido >= DATE_SUB(NOW(), INTERVAL 6 MONTH));

            /* EXERCÍCIO 04: Identifique os 3 produtos mais vendidos (em quantidade total) no último mês. O relatório deve 
exibir o nome do produto, sua categoria e a soma total de unidades vendidas, ordenados do maior para o menor */

SELECT
	PROD.v_nome_produto,
    PROD.v_categoria_produto,
	SUM(PHP.i_quantidade_pedidosHASProdutos) AS total_vendido
FROM pedidos_has_produtos PHP
	INNER JOIN produtos PROD ON PHP.i_id_produto = PROD.i_id_produto
    INNER JOIN pedidos PED on PHP.i_id_pedido = PED.i_id_pedido
    WHERE PED.d_data_pedido >= DATE_SUB(NOW(), INTERVAL 1 MONTH)
	GROUP BY PROD.v_nome_produto, PROD.v_categoria_produto
    ORDER BY total_vendido DESC
    LIMIT 3;

/* EXERCÍCIO 05 - Identifique os 5 clientes que possuem o maior valor total 
acumulado em compras em toda a história da loja (todos os registros feitos) */

SELECT
	clientes.v_nome_cliente,
    sum(pedidos.f_valorTotal_pedido) 
FROM pedidos
	INNER JOIN clientes ON pedidos.i_id_cliente = clientes.i_id_cliente
    GROUP BY clientes.v_nome_cliente
    ORDER BY sum(pedidos.f_valorTotal_pedido) DESC
    LIMIT 5;



/* EXERCÍCIO 07 - Identifique quais produtos do catálogo nunca foram
incluidos em nenhum pedido (útil pra limpeza de estoque) */

SELECT
	PROD.v_nome_produto
FROM produtos PROD
	WHERE PROD.i_id_produto NOT IN (
		SELECT
			PHP.i_id_produto
        FROM pedidos_has_produtos PHP
			WHERE PHP.i_id_produto IS NOT NULL
        );

/* EXERCÍCIO 08 - O setor de investimentos precisa limpar o estoque. Identifique
todos os produtos que não tiveram venda nos últimos 90 dias (3 meses). */


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
