

-- (1) Contagem de Conteúdo: Conte o número de Filmes (Movies) vs Shows de TV (TV Shows). 

SELECT
	v_tipo_netflix,
	COUNT(v_tipo_netflix)
FROM netflix
	GROUP BY v_tipo_netflix

-- (2) Classificação Comum: Encontre a classificação (rating) mais comum para filmes e programas de TV. 

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

-- (3) Lançamentos por Ano: Liste todos os filmes lançados em um ano específico (ex: 2020). 

SELECT
	*
FROM netflix
	WHERE v_anoLanc_netflix = 2020

-- (4) Top Países: Encontre os 5 países com a maior quantidade de conteúdo na Netflix. 

SELECT
	TRIM(UNNEST(string_to_array(v_pais_netflix, ','))) AS pais,
	COUNT(v_id_netflix) AS total_conteudo
FROM netflix
	WHERE v_pais_netflix IS NOT NULL
	GROUP BY 1
	ORDER BY total_conteudo DESC
	LIMIT 5

-- (5) Maior Duração: Identifique o filme de maior duração (o mais longo). 

SELECT
	v_titulo_netflix,
	split_part(v_duracao_netflix, ' ', 1)::INT as duracao
FROM netflix
	WHERE v_tipo_netflix = 'Movie' AND 
	v_duracao_netflix IS NOT NULL
	ORDER BY duracao DESC
	LIMIT 1;
	
-- (6) Conteúdo Recente: Encontre todo o conteúdo que foi adicionado nos últimos 5 anos.

SELECT 
	*
FROM netflix
	WHERE TO_DATE(v_dataadd_netflix, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- (7) Busca por Diretor: Encontre todos os filmes/programas de TV dirigidos apenas por 'Rajiv Chilaka'.

SELECT
	*
FROM netflix
	WHERE v_diretor_netflix = 'Rajiv Chilaka';

-- (8) Séries Longas: Liste todos os programas de TV (TV Show) que possuem mais de 5 temporadas.

SELECT
	*
FROM netflix
	WHERE v_tipo_netflix = 'TV Show' AND
	split_part(v_duracao_netflix, ' ', 1)::INT > 5
	
-- (9) Contagem por Gênero: Conte o número de itens de conteúdo em cada gênero 

SELECT
	TRIM(UNNEST(string_to_array(v_genero_netflix, ','))) AS genero,
	COUNT(v_id_netflix) AS n_total
FROM netflix
	WHERE v_genero_netflix IS NOT NULL
	GROUP BY 1
	ORDER BY n_total DESC 


-- (10) Análise por País e Ano: Encontre o ano de lançamento e o número médio de conteúdo lançado na Índia em um determinado ano . Retorne o top 5 anos com a maior média de lançamentos 

SELECT
	v_anoLanc_netflix AS "ano_de_lancamento",
	COUNT(v_id_netflix) AS "qtd_lancamenetos",
	ROUND(COUNT(v_id_netflix)/
		(SELECT COUNT(*)::numeric FROM netflix WHERE v_pais_netflix ILIKE '%India%')::numeric * 100,2) AS media_percentual
FROM netflix 
	WHERE v_pais_netflix ILIKE '%India%'
	GROUP BY 1
	ORDER BY media_percentual DESC
	LIMIT 5

-- 11. Listar Documentários: Liste todos os filmes que são classificados como 'Documentaries'.

SELECT
	*
FROM netflix
	WHERE v_tipo_netflix = 'Movie' 
	AND v_genero_netflix ILIKE '%Documentaries%';

-- 12. Conteúdo sem Diretor: Encontre todo o conteúdo que não possui um diretor listado

SELECT
	*
FROM netflix
	WHERE v_diretor_netflix IS NULL
	OR v_diretor_netflix = '';

-- 13. Ator Específico (Salman Khan): Encontre em quantos filmes o ator 'Salman Khan' apareceu nos últimos 10 anos.

SELECT
	COUNT(*)
FROM netflix
	WHERE v_tipo_netflix = 'Movie' 
	AND v_elenco_netflix ILIKE '%Salman Khan%'
	AND v_anolanc_netflix >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;;

-- 14. Top 10 Atores da Índia: Encontre os 10 principais atores que apareceram no maior número de filmes produzidos na Índia

SELECT
	TRIM(UNNEST(string_to_array(v_elenco_netflix, ','))) AS Ator,
	COUNT(*) AS Qtd_filmes
FROM netflix
	WHERE v_tipo_netflix = 'Movie' 
	AND v_pais_netflix ILIKE '%India%'
	AND v_elenco_netflix IS NOT NULL
	GROUP BY 1
	ORDER BY Qtd_filmes DESC
	LIMIT 10;

-- 15. Categorização por Descrição (O Grande Final): Categorize o conteúdo com base na presença das palavras-chave 'kill' ou 'violence' no campo de descrição

SELECT 
    CASE 
        WHEN v_descricao_netflix ILIKE '%kill%' 
		OR v_descricao_netflix ILIKE '%violence%' THEN 'Bad Content'
        ELSE 'Good Content'
    END AS categoria,
    COUNT(*) AS total_por_categoria
FROM netflix
	GROUP BY categoria;
