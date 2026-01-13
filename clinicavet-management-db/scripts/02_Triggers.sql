-- ----------------------------------------------------------------------------
-- 1. AUDITORIA CLÍNICA: RASTREABILIDADE DE PRONTUÁRIOS
-- Mantém o histórico de alterações nas anotações médicas para segurança jurídica.
-- ----------------------------------------------------------------------------

DELIMITER $$

CREATE TRIGGER TG_auditoria_prontuario_AFTER_UPDATE
AFTER UPDATE ON consulta
FOR EACH ROW
BEGIN
    -- Dispara a inserção apenas se houver alteração real no conteúdo das anotações
    IF (OLD.v_anotacao_consulta <> NEW.v_anotacao_consulta) THEN
        INSERT INTO BK_prontuario (
            i_id_consulta, 
            v_anotacoes_antigas, 
            v_anotacoes_novas
        ) VALUES (
            OLD.i_id_consulta, 
            OLD.v_anotacao_consulta, 
            NEW.v_anotacao_consulta
        );
    END IF;
END $$

DELIMITER ;