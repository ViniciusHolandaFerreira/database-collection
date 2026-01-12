
-- ----------------------------------------------------------------------------
-- DML - POPULAÇÃO DO BANCO DE DADOS (MASSA DE TESTES)
-- Este script realiza a carga inicial dos dados, respeitando rigorosamente a 
-- hierarquia das chaves estrangeiras (Integridade Referencial).
-- Os dados inseridos permitem validar o funcionamento das regras de negócio,
-- como o rodízio de funções e o controle de lotação das salas.
-- ----------------------------------------------------------------------------

INSERT INTO Salas (v_nome_sala, i_capacity_sala) VALUES 
('Sala 01 - IMAX', 5), 
('Sala 02 - 4DX', 50),
('Sala 03 - VIP', 20);

INSERT INTO Filmes (v_nomeBR_filme, v_nomeEN_filme, v_tipo_filme, v_diretor_filme, v_genero_filme, v_sinopse_filme, d_ano_filme) VALUES 
('Interestelar', 'Interstellar', 'Longo', 'Christopher Nolan', 'Ficção Científica', 'Exploradores viajam pelo espaço para salvar a humanidade.', 2014),
('Oppenheimer', 'Oppenheimer', 'Longo', 'Christopher Nolan', 'Drama/História', 'A história do pai da bomba atômica.', 2023),
('Duna: Parte 2', 'Dune: Part Two', 'Longo', 'Denis Villeneuve', 'Ação/Sci-Fi', 'Paul Atreides se une aos Fremen para buscar vingança.', 2024);

INSERT INTO Funcao (v_nome_funcao) VALUES 
('Bilheteiro'),
('Segurança'),
('Gerente'),
('Atendente de Pipoca');

INSERT INTO Premiacoes (v_nome_premiacoes, d_ano_premiacoes) VALUES 
('Oscar - Melhor Trilha Sonora', 2015),
('Oscar - Melhor Filme', 2024),
('Globo de Ouro - Melhor Direção', 2024);

INSERT INTO Filmes_has_Premiacoes (i_id_filme, i_id_premiacoes) VALUES 
(1, 1), 
(2, 2), 
(2, 3);

INSERT INTO Funcionario (i_numeroCarteiraTrab_funcionario, d_dataAdmissao_funcionario, v_nome_funcionario, f_salario_funcionario) VALUES 
(12345, '2022-01-15', 'Ana Silva', 2500.00),
(67890, '2023-05-10', 'Bruno Costa', 2800.00),
(11223, '2021-11-20', 'Carla Souza', 4500.00);

INSERT INTO Sessao (d_horario_sessao, i_id_sala, i_id_filme) VALUES 
('2026-02-01 16:00:00', 1, 1),
('2026-02-01 19:30:00', 1, 2), 
('2026-02-01 21:00:00', 2, 3); 

INSERT INTO Alocacao (i_id_sessao, i_id_funcionario, i_id_funcao) VALUES 
(1, 1, 1),
(1, 2, 2),
(2, 1, 4); 

INSERT INTO Espectador (v_nome_espectador, v_CPF_espectador, v_email_espectador) VALUES 
('João Pedro', '111.222.333-44', 'joao@email.com'),
('Maria Oliveira', '555.666.777-88', 'maria@email.com'),
('Lucas Mendes', '999.888.777-66', 'lucas@email.com');

INSERT INTO Ingresso (f_valor_ingresso, v_tipo_ingresso, v_assento_ingresso, i_id_espectador, i_id_sessao) VALUES 
(35.00, 'normal', 'A12', 1, 1),
(70.00, 'vip', 'B05', 2, 1),
(35.00, 'normal', 'A13', 3, 1);

-- ----------------------------------------------------------------------------
-- SUITE DE TESTES: VALIDAÇÃO DE TRIGGERS E REGRAS DE NEGÓCIO
-- ----------------------------------------------------------------------------

/* TESTE 01: Validação de Lotação Máxima (Fail-Safe)
   Cenário: A 'Sala 01' possui capacidade para 5 pessoas. Já existem 3 ingressos.
   A tentativa de inserir mais 3 registros deve acionar a Exception da Trigger,
   garantindo que o limite físico da sala seja respeitado.
*/
INSERT INTO Ingresso (f_valor_ingresso, v_tipo_ingresso, v_assento_ingresso, i_id_espectador, i_id_sessao) VALUES 
(35.00, 'normal', 'A14', 1, 1),
(35.00, 'normal', 'A15', 2, 1),
(35.00, 'normal', 'A16', 3, 1); 

/* TESTE 02: Auditoria e Rastreabilidade Financeira
   Ação: Alteração de valor em registro existente para validar a Trigger de Log.
*/
UPDATE Ingresso SET f_valor_ingresso = 40.00 WHERE i_id_ingresso = 1;

/* VERIFICAÇÃO DE RESULTADOS
   Consulta à tabela de auditoria para confirmar a persistência do histórico.
*/
SELECT * FROM BC_valor_ingresso;