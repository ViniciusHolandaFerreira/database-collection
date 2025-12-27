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