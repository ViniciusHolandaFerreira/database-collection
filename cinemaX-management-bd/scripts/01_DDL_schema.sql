-- ----------------------------------------------------------------------------
-- 1. CRIAÇÃO DO DATABASE E AMBIENTE
-- ----------------------------------------------------------------------------
-- CREATE DATABASE "Cinema"
--     WITH
--     OWNER = postgres
--     ENCODING = 'UTF8'
--     LC_COLLATE = 'Portuguese_Brazil.1252'
--     LC_CTYPE = 'Portuguese_Brazil.1252'
--     LOCALE_PROVIDER = 'libc'
--     TABLESPACE = pg_default
--     CONNECTION LIMIT = -1
--     IS_TEMPLATE = False;

-- ----------------------------------------------------------------------------
-- 2. LIMPEZA DE ESTRUTURAS EXISTENTES (Garante um ambiente limpo)
-- A ordem de DROP respeita as chaves estrangeiras para evitar erros.
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS Filmes_has_Premiacoes;
DROP TABLE IF EXISTS Alocacao;
DROP TABLE IF EXISTS Sessao;
DROP TABLE IF EXISTS Premiacoes;
DROP TABLE IF EXISTS Filmes;
DROP TABLE IF EXISTS Funcionario;
DROP TABLE IF EXISTS Funcao;
DROP TABLE IF EXISTS Salas;

-- ----------------------------------------------------------------------------
-- 3. TABELA DE SALAS
-- Armazena as salas físicas do cinema e suas capacidades.
-- ----------------------------------------------------------------------------
CREATE TABLE Salas (
    i_id_sala INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    v_nome_sala VARCHAR(255) NOT NULL,
    i_capacidade_sala INT NOT NULL
);

-- ----------------------------------------------------------------------------
-- 4. TABELA DE FUNÇÃO
-- Define os cargos ou funções que podem ser exercidos na empresa.
-- ----------------------------------------------------------------------------
CREATE TABLE Funcao (
    i_id_funcao INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    v_nome_funcao VARCHAR(255) NOT NULL
);

-- ----------------------------------------------------------------------------
-- 5. TABELA DE FUNCIONÁRIO
-- Armazena dados cadastrais, contratuais e financeiros dos colaboradores.
-- ----------------------------------------------------------------------------
CREATE TABLE Funcionario (
    i_id_funcionario INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    i_numeroCarteiraTrab_funcionario INT NOT NULL,
    d_dataAdmissao_funcionario DATE NOT NULL,
    v_nome_funcionario VARCHAR(255) NOT NULL,
    f_salario_funcionario DECIMAL(9,2) NOT NULL
);

-- ----------------------------------------------------------------------------
-- 6. TABELA DE FILMES
-- Catálogo completo contendo informações técnicas, sinopse e gênero.
-- ----------------------------------------------------------------------------
CREATE TABLE Filmes (
    i_id_filme INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    v_nomeBR_filme VARCHAR(255) NOT NULL,
    v_nomeEN_filme VARCHAR(255) NOT NULL,
    v_tipo_filme VARCHAR(255) NOT NULL,
    v_diretor_filme VARCHAR(255) NOT NULL,
    v_genero_filme VARCHAR(255) NOT NULL,
    v_sinopse_filme TEXT NOT NULL,
    d_ano_filme INT NOT NULL
);

-- ----------------------------------------------------------------------------
-- 7. TABELA DE PREMIAÇÕES
-- Registro de prêmios e festivais do setor cinematográfico por ano.
-- ----------------------------------------------------------------------------
CREATE TABLE Premiacoes (
    i_id_premiacoes INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    v_nome_premiacoes VARCHAR(255) NOT NULL,
    d_ano_premiacoes INT NOT NULL
);

-- ----------------------------------------------------------------------------
-- 8. TABELA DE SESSÃO
-- Organiza a grade de horários cruzando filmes e salas específicas.
-- ----------------------------------------------------------------------------
CREATE TABLE Sessao (
    i_id_sessao INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    d_horario_sessao TIMESTAMP NOT NULL,
    i_id_sala INT NOT NULL,
    i_id_filme INT NOT NULL,

    CONSTRAINT fk_Sessao_Sala
        FOREIGN KEY (i_id_sala)
        REFERENCES Salas(i_id_sala),

    CONSTRAINT fk_Sessao_Filmes
        FOREIGN KEY (i_id_filme)
        REFERENCES Filmes(i_id_filme)
);

-- ----------------------------------------------------------------------------
-- 9. TABELA DE ALOCAÇÃO
-- Gerencia a escala de funcionários e suas funções em cada sessão.
-- ----------------------------------------------------------------------------
CREATE TABLE Alocacao (
    i_id_alocacao INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    i_id_sessao INT NOT NULL,
    i_id_funcionario INT NOT NULL,
    i_id_funcao INT NOT NULL,

    CONSTRAINT fk_Alocacao_Sessao
        FOREIGN KEY (i_id_sessao)
        REFERENCES Sessao(i_id_sessao),

    CONSTRAINT fk_Alocacao_Funcionario
        FOREIGN KEY (i_id_funcionario)
        REFERENCES Funcionario(i_id_funcionario),

    CONSTRAINT fk_Alocacao_Funcao
        FOREIGN KEY (i_id_funcao)
        REFERENCES Funcao(i_id_funcao)
);

-- ----------------------------------------------------------------------------
-- 10. TABELA RELACIONAL: FILMES_HAS_PREMIACOES
-- Tabela intermediária para registrar os diversos prêmios ganhos por um filme.
-- ----------------------------------------------------------------------------
CREATE TABLE Filmes_has_Premiacoes (
    i_id_filme INT NOT NULL,
    i_id_premiacoes INT NOT NULL,

    PRIMARY KEY (i_id_filme, i_id_premiacoes),

    CONSTRAINT fk_FilmesHasPremiacoes_Filmes
        FOREIGN KEY (i_id_filme)
        REFERENCES Filmes(i_id_filme),

    CONSTRAINT fk_FilmesHasPremiacoes_Premiacoes
        FOREIGN KEY (i_id_premiacoes)
        REFERENCES Premiacoes(i_id_premiacoes)
);