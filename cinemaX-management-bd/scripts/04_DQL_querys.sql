
-- ----------------------------------------------------------------------------
-- (1) Faturamento de Bilheteria (Últimas 24 Horas)
-- Problema de Negócio: Monitorar o desempenho financeiro imediato de cada filme 
-- para auxiliar a gerência na tomada de decisão sobre continuidade em cartaz.
-- ----------------------------------------------------------------------------
SELECT 
    f.v_nomeBR_filme AS "Filme",
    SUM(i.f_valor_ingresso) AS "Receita Bruta"
FROM Ingresso i
    INNER JOIN Sessao s ON i.i_id_sessao = s.i_id_sessao
    INNER JOIN Filmes f ON s.i_id_filme = f.i_id_filme
    WHERE i.d_dataEmissao_ingresso >= NOW() - INTERVAL '24 HOURS'
    GROUP BY f.v_nomeBR_filme
    ORDER BY "Receita Bruta" DESC;

-- ----------------------------------------------------------------------------
-- (2) Escala Operacional de Funcionários
-- Problema de Negócio: Garantir que todos os postos de trabalho estejam cobertos, 
-- identificando quem trabalha em qual sessão e qual a função desempenhada.
-- ----------------------------------------------------------------------------
SELECT 
    func.v_nome_funcionario AS "Colaborador",
    fun.v_nome_funcao AS "Cargo",
    s.d_horario_sessao AS "Início da Sessão"
FROM Alocacao a
    INNER JOIN Funcionario func ON a.i_id_funcionario = func.i_id_funcionario
    INNER JOIN Funcao fun ON a.i_id_funcao = fun.i_id_funcao
    INNER JOIN Sessao s ON a.i_id_sessao = s.i_id_sessao
    ORDER BY s.d_horario_sessao ASC;

-- ----------------------------------------------------------------------------
-- (3) Ranking de Prestígio (Marketing)
-- Problema de Negócio: Identificar quais filmes possuem o maior número de 
-- premiações vinculadas para direcionar investimentos em campanhas publicitárias.
-- ----------------------------------------------------------------------------
SELECT 
    f.v_nomeBR_filme AS "Filme",
    COUNT(fhp.i_id_premiacoes) AS "Total de Premiações"
FROM Filmes f
    LEFT JOIN Filmes_has_Premiacoes fhp ON f.i_id_filme = fhp.i_id_filme
    GROUP BY f.v_nomeBR_filme
    ORDER BY "Total de Premiações" DESC;

-- ----------------------------------------------------------------------------
-- (4) Planejamento de Ocupação e Grade de Exibição
-- Problema de Negócio: Visualizar a distribuição de títulos por sala e 
-- verificar a capacidade física disponível para organização das sessões.
-- ----------------------------------------------------------------------------
SELECT 
    f.v_nomeBR_filme AS "Filme",
    f.v_genero_filme AS "Gênero",
    sa.v_nome_sala AS "Sala",
    sa.i_capacidade_sala AS "Capacidade Máxima"
FROM Sessao s
    INNER JOIN Filmes f ON s.i_id_filme = f.i_id_filme
    INNER JOIN Salas sa ON s.i_id_sala = sa.i_id_sala
    ORDER BY sa.v_nome_sala;