
-- ----------------------------------------------------------------------------
-- (1) Performance por Espécie (Análise Semestral)
-- Problema de Negócio: Identificar quais categorias de animais geram maior
-- faturamento para priorizar investimentos em equipamentos e marketing.
-- ----------------------------------------------------------------------------

SELECT
    especie.v_nome_especie AS Especie,
    SUM(DISTINCT medicamento.d_valor_medicamento * CHM.i_qtd_CHM) + 
    SUM(DISTINCT exame.d_valor_exame * CHE.i_qtd_CHE) AS faturamento_total
FROM consulta
    INNER JOIN animal ON consulta.i_id_animal = animal.i_id_animal
    INNER JOIN raca ON animal.i_id_raca = raca.i_id_raca
    INNER JOIN especie ON raca.i_id_especie = especie.i_id_especie
    LEFT JOIN consulta_has_medicamento CHM ON consulta.i_id_consulta = CHM.i_id_consulta
    LEFT JOIN consulta_has_exame CHE ON consulta.i_id_consulta = CHE.i_id_consulta
    LEFT JOIN medicamento ON CHM.i_id_medicamento = medicamento.i_id_medicamento
    LEFT JOIN exame ON CHE.i_id_exame = exame.i_id_exame
WHERE consulta.d_data_consulta >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
GROUP BY especie.i_id_especie;

-- ----------------------------------------------------------------------------
-- (2) Auditoria Médica: Adesão ao Protocolo 'Hemograma'
-- Problema de Negócio: Listar clientes cujos animais nunca realizaram exames
-- básicos (Hemograma Completo), visando campanhas de check-up preventivo.
-- ----------------------------------------------------------------------------

SELECT
    cliente.v_nome_cliente AS Cliente,
    cliente.v_cpf_cliente AS CPF
FROM cliente
WHERE cliente.i_id_cliente NOT IN (
    SELECT cliente.i_id_cliente
    FROM cliente
        INNER JOIN animal ON cliente.i_id_cliente = animal.i_id_cliente
        INNER JOIN consulta ON animal.i_id_animal = consulta.i_id_animal 
        INNER JOIN consulta_has_exame CHE ON consulta.i_id_consulta = CHE.i_id_consulta
        INNER JOIN exame ON CHE.i_id_exame = exame.i_id_exame
    WHERE exame.v_nome_exame = "Hemograma Completo"
);

-- ----------------------------------------------------------------------------
-- (3) Identificação de Clientes VIP (Fidelidade Multidono)
-- Problema de Negócio: Identificar proprietários com mais de um animal para
-- aplicação de descontos progressivos por volume de pets.
-- ----------------------------------------------------------------------------

SELECT
    cliente.v_nome_cliente AS Cliente,
    COUNT(consulta.i_id_consulta) AS Qtd_Consultas
FROM consulta
    INNER JOIN animal ON consulta.i_id_animal = animal.i_id_animal
    INNER JOIN cliente ON animal.i_id_cliente = cliente.i_id_cliente
WHERE cliente.i_id_cliente IN (
    SELECT cliente.i_id_cliente
    FROM cliente
        INNER JOIN animal ON cliente.i_id_cliente = animal.i_id_cliente
    GROUP BY cliente.i_id_cliente
    HAVING COUNT(DISTINCT animal.i_id_animal) > 1
)
GROUP BY cliente.v_nome_cliente;

-- ----------------------------------------------------------------------------
-- (4) Cálculo de Ticket Médio (Foco em Farmácia)
-- Problema de Negócio: Analisar a média de gastos em consultas que geraram
-- prescrições de medicamentos para otimização do estoque interno.
-- ----------------------------------------------------------------------------

SELECT
     ROUND(AVG(total_consulta), 2) AS Ticket_Medio
FROM (
    SELECT
        consulta.i_id_consulta,
        SUM(DISTINCT medicamento.d_valor_medicamento * CHM.i_qtd_CHM) + 
        SUM(DISTINCT exame.d_valor_exame * CHE.i_qtd_CHE) AS total_consulta
    FROM consulta
        INNER JOIN consulta_has_medicamento CHM ON consulta.i_id_consulta = CHM.i_id_consulta
        INNER JOIN medicamento ON CHM.i_id_medicamento = medicamento.i_id_medicamento
        LEFT JOIN consulta_has_exame CHE ON consulta.i_id_consulta = CHE.i_id_consulta
        LEFT JOIN exame ON CHE.i_id_exame = exame.i_id_exame
    WHERE CHM.i_qtd_CHM >= 1
    GROUP BY consulta.i_id_consulta
) AS sub;

-- ----------------------------------------------------------------------------
-- (5) Integridade de Dados: Rastreio de Edições em Prontuários
-- Problema de Negócio: Monitorar anotações de consulta editadas múltiplas
-- vezes no mesmo dia para evitar inconsistências em diagnósticos.
-- ----------------------------------------------------------------------------

SELECT
    v_anotacao_consulta AS Prontuario_Atual
FROM consulta
WHERE i_id_consulta IN (
    SELECT i_id_consulta
    FROM bk_prontuario
    GROUP BY i_id_consulta, DATE(d_data_alteracao)
    HAVING COUNT(i_id_consulta) > 1 
);

-- ----------------------------------------------------------------------------
-- (6) Análise de Perfil Médico (Multi-Especialistas)
-- Problema de Negócio: Identificar veterinários capacitados em mais de uma 
-- área para otimização da escala de plantões especializados.
-- ----------------------------------------------------------------------------

SELECT
    v.v_nome_veterinario AS Veterinario,
    e.v_nome_especialidade AS Especialidade
FROM veterinario_has_especialidade VHE
    INNER JOIN veterinario v ON VHE.i_id_veterinario = v.i_id_veterinario
    INNER JOIN especialidade e ON VHE.i_id_especialidade = e.i_id_especialidade
WHERE VHE.i_id_veterinario IN (
    SELECT i_id_veterinario
    FROM veterinario_has_especialidade
    GROUP BY i_id_veterinario
    HAVING COUNT(i_id_veterinario) > 1
);

-- ----------------------------------------------------------------------------
-- (7) Produto Curva A: Maior Receita Acumulada
-- Problema de Negócio: Descobrir o medicamento líder em faturamento histórico
-- para negociações de volume junto aos fornecedores.
-- ----------------------------------------------------------------------------

SELECT
    m.v_nome_medicamento AS Medicamento,
    SUM(CHM.i_qtd_CHM * m.d_valor_medicamento) AS Receita_Acumulada
FROM consulta_has_medicamento CHM
    INNER JOIN medicamento m ON CHM.i_id_medicamento = m.i_id_medicamento
GROUP BY m.i_id_medicamento
ORDER BY Receita_Acumulada DESC
LIMIT 1;

-- ----------------------------------------------------------------------------
-- (8) Auditoria de Compliance: Atendimento vs Perfil Médico
-- Problema de Negócio: Detectar atendimentos realizados por médicos que não
-- possuem a especialidade 'Clínica Geral' registrada em seu currículo.
-- ----------------------------------------------------------------------------

SELECT
    sub.v_nome_veterinario AS Veterinario,
    sub.v_nome_animal AS Paciente,
    sub.v_nome_especie AS Especie,
    sub.valor_total AS Valor_Consulta
FROM (
    SELECT
        v.i_id_veterinario,
        v.v_nome_veterinario,
        a.v_nome_animal,
        e.v_nome_especie,
        SUM((COALESCE(CHM.i_qtd_CHM, 0) * COALESCE(m.d_valor_medicamento, 0)) + 
            (COALESCE(CHE.i_qtd_CHE, 0) * COALESCE(ex.d_valor_exame, 0))) AS valor_total
    FROM consulta c
        INNER JOIN veterinario v ON c.i_id_veterinario = v.i_id_veterinario
        INNER JOIN animal a ON c.i_id_animal = a.i_id_animal
        INNER JOIN raca r ON a.i_id_raca = r.i_id_raca
        INNER JOIN especie e ON r.i_id_especie = e.i_id_especie
        LEFT JOIN consulta_has_medicamento CHM ON c.i_id_consulta = CHM.i_id_consulta
        LEFT JOIN medicamento m ON CHM.i_id_medicamento = m.i_id_medicamento
        LEFT JOIN consulta_has_exame CHE ON c.i_id_consulta = CHE.i_id_consulta
        LEFT JOIN exame ex ON CHE.i_id_exame = ex.i_id_exame
    GROUP BY c.i_id_consulta, v.i_id_veterinario, a.v_nome_animal, e.v_nome_especie
) sub
WHERE NOT EXISTS (
    SELECT 1 FROM veterinario_has_especialidade VHE2
    INNER JOIN especialidade e2 ON VHE2.i_id_especialidade = e2.i_id_especialidade
    WHERE VHE2.i_id_veterinario = sub.i_id_veterinario 
    AND e2.v_nome_especialidade = 'Clínica Geral'
);

-- ----------------------------------------------------------------------------
-- (9) Sazonalidade de Retorno: Raça Labrador
-- Problema de Negócio: Calcular o intervalo médio de dias para o retorno 
-- de animais da raça Labrador para previsão de agenda.
-- ----------------------------------------------------------------------------

SELECT
    ROUND((DATEDIFF(MAX(c.d_data_consulta), MIN(c.d_data_consulta)) / (COUNT(*) - 1)),0) AS Media_Dias_Retorno
FROM consulta c
WHERE c.i_id_animal IN (
    SELECT a.i_id_animal
    FROM animal a
    INNER JOIN raca r ON a.i_id_raca = r.i_id_raca
    WHERE r.v_nome_raca = 'Labrador'
)
GROUP BY c.i_id_animal
HAVING COUNT(c.i_id_animal) > 1;

-- ----------------------------------------------------------------------------
-- (10) Relatório Executivo: Lifetime Value (LTV) > 200,00
-- Problema de Negócio: Consolidar faturamento total por cliente para 
-- identificar proprietários de alto valor acumulado.
-- ----------------------------------------------------------------------------

-- OPÇÃO A: Solução via Subqueries Aninhadas (Foco em granularidade de Consulta)
SELECT
    cl.v_nome_cliente AS Proprietario,
    a.v_nome_animal AS Paciente,
    sub1.vt AS Gasto_Total_Acumulado
FROM cliente cl
    INNER JOIN animal a ON cl.i_id_cliente = a.i_id_cliente
    INNER JOIN (
        SELECT
            c_int.i_id_cliente,
            SUM(valor_total) AS vt
        FROM cliente c_int
            INNER JOIN animal a_int ON c_int.i_id_cliente = a_int.i_id_cliente
            INNER JOIN consulta cons ON a_int.i_id_animal = cons.i_id_animal
            INNER JOIN (
                SELECT
                    consulta.i_id_consulta,
                    SUM((COALESCE(CHM.i_qtd_CHM, 0) * COALESCE(m.d_valor_medicamento, 0)) + 
                        (COALESCE(CHE.i_qtd_CHE, 0) * COALESCE(ex.d_valor_exame, 0))) AS valor_total
                FROM consulta   
                    LEFT JOIN consulta_has_medicamento CHM ON consulta.i_id_consulta = CHM.i_id_consulta
                    LEFT JOIN medicamento m ON CHM.i_id_medicamento = m.i_id_medicamento
                    LEFT JOIN consulta_has_exame CHE ON consulta.i_id_consulta = CHE.i_id_consulta
                    LEFT JOIN exame ex ON CHE.i_id_exame = ex.i_id_exame
                GROUP BY consulta.i_id_consulta
            ) sub2 ON cons.i_id_consulta = sub2.i_id_consulta
        GROUP BY c_int.i_id_cliente
        HAVING SUM(valor_total) > 200
    ) sub1 ON cl.i_id_cliente = sub1.i_id_cliente;


-- OPÇÃO B: Solução via Tabela Derivada (Foco em Performance de Agrupamento)
SELECT 
    cl.v_nome_cliente AS Proprietario,
    a.v_nome_animal AS Paciente,
    ResumoFinanceiro.total_acumulado_cliente AS Gasto_Total_Acumulado
FROM cliente cl
    INNER JOIN animal a ON cl.i_id_cliente = a.i_id_cliente
    INNER JOIN (
        SELECT 
            c_int.i_id_cliente,
            SUM(COALESCE(CHM.i_qtd_CHM * m.d_valor_medicamento, 0) + 
                COALESCE(CHE.i_qtd_CHE * e.d_valor_exame, 0)) AS total_acumulado_cliente
        FROM cliente c_int
            INNER JOIN animal a_int ON c_int.i_id_cliente = a_int.i_id_cliente
            INNER JOIN consulta cons ON a_int.i_id_animal = cons.i_id_animal
            LEFT JOIN consulta_has_medicamento CHM ON cons.i_id_consulta = CHM.i_id_consulta
            LEFT JOIN medicamento m ON CHM.i_id_medicamento = m.i_id_medicamento
            LEFT JOIN consulta_has_exame CHE ON cons.i_id_consulta = CHE.i_id_consulta
            LEFT JOIN exame e ON CHE.i_id_exame = e.i_id_exame
        GROUP BY c_int.i_id_cliente
        HAVING total_acumulado_cliente > 200
) AS ResumoFinanceiro ON cl.i_id_cliente = ResumoFinanceiro.i_id_cliente;