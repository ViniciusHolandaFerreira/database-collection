CREATE TABLE Salas (
    i_id_sala INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    v_nome_sala VARCHAR(255) NOT NULL,
    i_capacidade_sala INT NOT NULL
);

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

CREATE TABLE Premiacoes (
    i_id_premiacoes INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    v_nome_premiacoes VARCHAR(255) NOT NULL,
    d_ano_premiacoes INT NOT NULL
);

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

CREATE TABLE Funcao (
    i_id_funcao INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    v_nome_funcao VARCHAR(255) NOT NULL
);

CREATE TABLE Funcionario (
    i_id_funcionario INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    i_numeroCarteiraTrab_funcionario INT UNIQUE NOT NULL,
    d_dataAdmissao_funcionario DATE NOT NULL,
    v_nome_funcionario VARCHAR(255) NOT NULL,
    f_salario_funcionario DECIMAL(9,2) NOT NULL
);

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

CREATE TABLE Espectador (
    i_id_espectador INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    v_nome_espectador VARCHAR(255) NOT NULL,
    v_CPF_espectador VARCHAR(14) UNIQUE NOT NULL,
    v_email_espectador VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE Ingresso (
    i_id_ingresso INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    f_valor_ingresso DECIMAL(9,2) NOT NULL,
    v_tipo_ingresso VARCHAR(255) NOT NULL,
    d_dataEmissao_ingresso TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    v_assento_ingresso VARCHAR(255) NOT NULL,
    i_id_espectador INT NOT NULL,
    i_id_sessao INT NOT NULL,
    CONSTRAINT chk_tipo_ingresso 
        CHECK (v_tipo_ingresso IN ('normal', 'vip', '3d', '4dx')),
    CONSTRAINT fk_Ingresso_Espectador 
        FOREIGN KEY (i_id_espectador) 
        REFERENCES Espectador(i_id_espectador),
    CONSTRAINT fk_Ingresso_Sessao 
        FOREIGN KEY (i_id_sessao) 
        REFERENCES Sessao(i_id_sessao)
);

CREATE TABLE BC_valor_ingresso(
	i_id_BC_valor_ingresso  INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	i_id_ingresso INT NOT NULL,
	f_valorAntigo_BC_valor_ingresso DECIMAL(9,2) NOT NULL, 
	f_valorNovo_BC_valor_ingresso DECIMAL(9,2) NOT NULL,
	d_dataAlteracao_BC_valor_ingresso TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP

);