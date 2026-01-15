-- QUESTÕES (QUERYS)
-- (1) Contagem de Conteúdo: Conte o número de Filmes (Movies) vs Shows de TV (TV Shows). -- ok

SELECT
	v_tipo_netflix,
	COUNT(v_tipo_netflix)
FROM netflix
	GROUP BY v_tipo_netflix

-- (2) Classificação Comum: Encontre a classificação (rating) mais comum para filmes e programas de TV. -ok 
 -- aprender funções de janela


(SELECT
	v_tipo_netflix,
	v_avaliacao_netflix
FROM netflix
	WHERE v_tipo_netflix = 'Movie'
	GROUP BY v_avaliacao_netflix, v_tipo_netflix
	ORDER BY COUNT(v_avaliacao_netflix) DESC
	LIMIT 1)
UNION ALL
(SELECT
	v_tipo_netflix,
	v_avaliacao_netflix
FROM netflix
	WHERE v_tipo_netflix = 'TV Show'
	GROUP BY v_avaliacao_netflix, v_tipo_netflix
	ORDER BY COUNT(v_avaliacao_netflix) DESC
	LIMIT 1)




-- (3) Lançamentos por Ano: Liste todos os filmes lançados em um ano específico (ex: 2020). -- ok

SELECT
	*
FROM netflix
	WHERE v_anoLanc_netflix = 2020

-- (4) Top Países: Encontre os 5 países com a maior quantidade de conteúdo na Netflix. -- ok
	-- função UNNSET, strirng_to_string e TRIM
SELECT
	TRIM(UNNEST(string_to_array(v_pais_netflix, ','))) AS pais,
	COUNT(v_id_netflix) AS total_conteudo
FROM netflix
	GROUP BY pais
	ORDER BY total_conteudo DESC
	LIMIT 5

-- (5) Maior Duração: Identifique o filme de maior duração (o mais longo). -- ok
	-- função split_part 
	-- conversão de tipo ::INT

SELECT
	v_titulo_netflix,
	split_part(v_duracao_netflix, ' ', 1)::INT as duracao
FROM netflix
	WHERE v_tipo_netflix = 'Movie' AND 
	v_duracao_netflix IS NOT NULL
	ORDER BY duracao DESC
	LIMIT 1;
	
-- (6) Conteúdo Recente: Encontre todo o conteúdo que foi adicionado nos últimos 5 anos. ( -- ok
-- Dica: Lembre-se que hoje é 15 de Janeiro de 2026).

SELECT 
	*
FROM netflix
	WHERE TO_DATE(v_dataadd_netflix, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';


-- (7) Busca por Diretor: Encontre todos os filmes/programas de TV dirigidos apenas por 'Rajiv Chilaka'.

SELECT
	*
FROM netflix
	WHERE v_diretor_netflix = 'Rajiv Chilaka';

-- (8) Séries Longas: Liste todos os programas de TV (TV Show) que possuem mais de 5 temporadas. -- ok

SELECT
	*
FROM netflix
	WHERE v_tipo_netflix = 'TV Show' AND
	split_part(v_duracao_netflix, ' ', 1)::INT > 5
	

-- (9) Contagem por Gênero: Conte o número de itens de conteúdo em cada gênero --ok 

SELECT
	TRIM(UNNEST(string_to_array(v_genero_netflix, ','))) AS pais,
	COUNT(v_id_netflix) AS n_total
FROM netflix
	GROUP BY pais
	ORDER BY n_total DESC 


-- (10) Análise por País e Ano: Encontre o ano de lançamento e o número médio de conteúdo lançado 
-- na Índia em um determinado ano . Retorne o top 5 anos com a maior média de lançamentos 




SELECT
	v_anoLanc_netflix AS "ano_de_lancamento",
	COUNT(v_id_netflix) AS "qtd_lancamenetos",
	ROUND(COUNT(v_id_netflix)/
		(SELECT COUNT(*) FROM netflix WHERE v_pais_netflix ILIKE '%India%')::numeric * 100,2) AS media_percentual
FROM netflix 
	WHERE v_pais_netflix ILIKE '%India%'
	GROUP BY v_anoLanc_netflix
	ORDER BY media_percentual DESC
	LIMIT 5

