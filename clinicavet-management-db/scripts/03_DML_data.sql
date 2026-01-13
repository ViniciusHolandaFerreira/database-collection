-- ----------------------------------------------------------------------------
-- DML - POPULAÇÃO DO BANCO DE DADOS (MASSA DE TESTES)
-- Este script realiza a carga inicial dos dados, respeitando rigorosamente a 
-- hierarquia das chaves estrangeiras (Integridade Referencial).
-- Os dados inseridos permitem validar o funcionamento das regras de negócio,
-- como a integridade dos prontuários, especialidades veterinárias e o 
-- monitoramento de histórico médico através de triggers de auditoria.
-- ----------------------------------------------------------------------------

INSERT INTO cliente (v_nome_cliente, v_cpf_cliente) VALUES 
('Ana Maria Braga', '11122233344'), ('Bruno Gagliasso', '22233344455'),
('Camila Pitanga', '33344455566'), ('Diego Hipolito', '44455566677'),
('Elena de Troia', '55566677788'), ('Fabio Assuncao', '66677788899'),
('Gisele Bundchen', '77788899900'), ('Helio de la Pena', '88899900011');

INSERT INTO especie (v_nome_especie) VALUES ('Canina'), ('Felina'), ('Ave'), ('Repteis');

INSERT INTO raca (v_nome_raca, i_id_especie) VALUES 
('Poodle', 1), ('Labrador', 1), ('Bulldog', 1), ('Pinscher', 1),
('Siamês', 2), ('Maine Coon', 2), ('Angorá', 2),
('Calopsita', 3), ('Papagaio', 3),
('Iguana Verde', 4), ('Jabuti', 4);

INSERT INTO animal (v_nome_animal, v_dsc_animal, d_datansc_animal, i_id_cliente, i_id_raca) VALUES 
('Max', 'Muito agitado e brincalhão', '2018-05-12', 1, 2),
('Mel', 'Pequena, late muito', '2020-11-01', 1, 4),
('Frajola', 'Gato preto e branco, calmo', '2019-01-20', 2, 5),
('Bidu', 'Pelagem azulada (fantasia)', '2021-03-15', 3, 1),
('Zeca', 'Ave muito barulhenta', '2022-06-30', 4, 9),
('Dino', 'Lento mas saudável', '2015-08-10', 5, 11),
('Kyra', 'Fêmea dócil', '2020-02-14', 6, 6),
('Bob', 'Porte grande, protetor', '2017-09-22', 7, 2);

INSERT INTO especialidade (v_nome_especialidade) VALUES 
('Clínica Geral'), ('Ortopedia'), ('Oftalmologia'), ('Oncologia'), ('Exóticos');

INSERT INTO veterinario (v_nome_veterinario, v_cfmv_veterinario) VALUES 
('Dr. Jefferson Arena', 'CRMV-SP0001'), ('Dra. Simone Silva', 'CRMV-RJ9999'),
('Dr. Marcos Pontes', 'CRMV-MG5555'), ('Dra. Julia Roberts', 'CRMV-RS7777');

INSERT INTO veterinario_has_especialidade (i_id_veterinario, i_id_especialidade) VALUES 
(1, 1), (1, 2), (2, 1), (2, 3), (3, 4), (4, 1), (4, 5);

INSERT INTO medicamento (v_nome_medicamento, v_dsc_medicamento, d_valor_medicamento) VALUES 
('Vermífugo Plus', 'Dose única para vermes', 35.00),
('Antibiótico X', 'Infecções gerais', 120.00),
('Pomada Cicatriz', 'Uso tópico', 25.50),
('Suplemento Vit', 'Para filhotes', 45.00);

INSERT INTO exame (v_nome_exame, v_dsc_exame, d_valor_exame) VALUES 
('Hemograma', 'Sangue completo', 55.00),
('Ultrassom', 'Abdominal total', 180.00),
('Raio-X', 'Membro posterior', 130.00),
('Eletrocardiograma', 'Risco cirúrgico', 210.00);

INSERT INTO consulta (d_data_consulta, v_anotacao_consulta, i_id_animal, i_id_veterinario) VALUES 
('2025-12-01 09:00:00', 'Vacinação de rotina e check-up.', 1, 1),
('2025-12-05 14:00:00', 'Animal mancando da pata traseira esquerda.', 1, 1),
('2025-12-10 10:30:00', 'Olhos avermelhados e secreção.', 3, 2),
('2025-12-15 16:45:00', 'Verificação de parasitas em iguana.', 6, 4),
('2026-01-02 08:00:00', 'Animal ingeriu objeto estranho.', 8, 3),
('2026-01-10 11:15:00', 'Retorno para avaliação de cirurgia.', 1, 1);

INSERT INTO consulta_has_medicamento (i_id_consulta, i_id_medicamento, i_qtd_CHM) VALUES 
(1, 1, 1), (2, 3, 1), (3, 2, 1), (5, 2, 2);

INSERT INTO consulta_has_exame (i_id_consulta, i_id_exame, i_qtd_CHE) VALUES 
(2, 3, 1), (5, 1, 1), (5, 2, 1), (6, 4, 1);

-- ----------------------------------------------------------------------------
-- VALIDAÇÃO DA TRIGGER DE AUDITORIA
-- Teste de eficácia do gatilho TG_auditoria_prontuario_AFTER_UPDATE
-- ----------------------------------------------------------------------------

UPDATE consulta 
SET v_anotacao_consulta = 'Atualização: Suspeita de fratura descartada após Raio-X. Repouso sugerido.'
WHERE i_id_consulta = 2;

-- Verificação da persistência do log
SELECT * FROM BK_prontuario;