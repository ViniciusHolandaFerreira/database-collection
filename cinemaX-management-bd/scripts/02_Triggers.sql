
-- ----------------------------------------------------------------------------
-- 1. SEGURANÇA OPERACIONAL: VALIDAÇÃO DE LOTAÇÃO MÁXIMA
-- Impede a venda de ingressos caso a capacidade física da sala seja atingida.
-- ----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_verificar_lotacao()
RETURNS TRIGGER AS $$
DECLARE
    v_capacidade_total INT;
    v_ingressos_vendidos INT;
BEGIN
    -- Busca a capacidade nominal da sala vinculada à sessão solicitada
    SELECT Salas.i_capacidade_sala INTO v_capacidade_total
    FROM Sessao
    INNER JOIN Salas ON Salas.i_id_sala = Sessao.i_id_sala
    WHERE Sessao.i_id_sessao = NEW.i_id_sessao;

    -- Contabiliza ingressos já persistidos para esta sessão específica
    SELECT COUNT(i_id_sessao) INTO v_ingressos_vendidos
    FROM Ingresso 
    WHERE i_id_sessao = NEW.i_id_sessao;

    -- Validação: Bloqueia a inserção caso não haja disponibilidade
    IF v_ingressos_vendidos >= v_capacidade_total THEN
        RAISE EXCEPTION 'Erro CinemaX: Sessão lotada! A capacidade máxima de % lugares foi atingida.', v_capacidade_total;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Gatilho acionado antes da inserção para garantir a integridade da ocupação
CREATE TRIGGER tg_valida_lotacao_ingresso
BEFORE INSERT ON Ingresso
FOR EACH ROW
EXECUTE FUNCTION fn_verificar_lotacao();


-- ----------------------------------------------------------------------------
-- 2. AUDITORIA FINANCEIRA: RASTREABILIDADE DE PREÇOS
-- Registra o histórico de alterações nos valores de ingressos para segurança.
-- ----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_salvar_valor()
RETURNS TRIGGER AS $$
BEGIN
    -- Dispara a gravação do log apenas se houver variação real no preço nominal
    IF (OLD.f_valor_ingresso <> NEW.f_valor_ingresso) THEN
        INSERT INTO BC_valor_ingresso (
            i_id_ingresso,
            f_valorAntigo_BC_valor_ingresso,
            f_valorNovo_BC_valor_ingresso
        ) VALUES (
            OLD.i_id_ingresso,
            OLD.f_valor_ingresso,
            NEW.f_valor_ingresso
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Gatilho de auditoria disparado após a atualização confirmada do registro
CREATE TRIGGER tg_salva_valor_ingresso
AFTER UPDATE ON Ingresso 
FOR EACH ROW
EXECUTE FUNCTION fn_salvar_valor();