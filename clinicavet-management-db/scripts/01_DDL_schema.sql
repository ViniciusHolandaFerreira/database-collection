CREATE DATABASE IF NOT EXISTS ClinicaVeterinaria;
USE ClinicaVeterinaria;

CREATE TABLE cliente(
    i_id_cliente INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    v_nome_cliente VARCHAR(100) NOT NULL,
    v_cpf_cliente VARCHAR(11) NOT NULL
);

CREATE TABLE especie(
    i_id_especie INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    v_nome_especie VARCHAR(100) NOT NULL
);

CREATE TABLE raca(
    i_id_raca INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    v_nome_raca VARCHAR(100) NOT NULL,
    i_id_especie INT NOT NULL,
    CONSTRAINT fk_raca_especie 
        FOREIGN KEY(i_id_especie) 
        REFERENCES especie(i_id_especie)
);

CREATE TABLE animal(
    i_id_animal INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    v_nome_animal VARCHAR(100) NOT NULL,
    v_dsc_animal LONGTEXT NOT NULL,
    d_datansc_animal DATETIME NOT NULL,
    i_id_cliente INT NOT NULL,
    i_id_raca INT NOT NULL,
    CONSTRAINT fk_animal_cliente
        FOREIGN KEY (i_id_cliente)
        REFERENCES cliente(i_id_cliente),
    CONSTRAINT fk_animal_raca
        FOREIGN KEY(i_id_raca)
        REFERENCES raca(i_id_raca)
);

CREATE TABLE medicamento(
    i_id_medicamento INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    v_nome_medicamento VARCHAR(100) NOT NULL,
    v_dsc_medicamento LONGTEXT NOT NULL,
    d_valor_medicamento DECIMAL(9,2) NOT NULL
);

CREATE TABLE exame(
    i_id_exame INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    v_nome_exame VARCHAR(100) NOT NULL,
    v_dsc_exame LONGTEXT NOT NULL,
    d_valor_exame DECIMAL(9,2) NOT NULL
);

CREATE TABLE especialidade(
    i_id_especialidade INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    v_nome_especialidade VARCHAR(100) NOT NULL
);

CREATE TABLE veterinario(
    i_id_veterinario INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    v_nome_veterinario VARCHAR(100) NOT NULL,
    v_cfmv_veterinario VARCHAR(20) NOT NULL
);

CREATE TABLE veterinario_has_especialidade(
    i_id_veterinario INT NOT NULL,
    i_id_especialidade INT NOT NULL,
    PRIMARY KEY (i_id_veterinario, i_id_especialidade),
    CONSTRAINT fk_VHE_veterinario
        FOREIGN KEY (i_id_veterinario)
        REFERENCES veterinario(i_id_veterinario),
    CONSTRAINT fk_VHE_especialidade
        FOREIGN KEY (i_id_especialidade)
        REFERENCES especialidade(i_id_especialidade)
);

CREATE TABLE consulta(
    i_id_consulta INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    d_data_consulta DATETIME NOT NULL,
    v_anotacao_consulta LONGTEXT NOT NULL,
    i_id_animal INT NOT NULL,
    i_id_veterinario INT NOT NULL,
    CONSTRAINT fk_consulta_animal
        FOREIGN KEY (i_id_animal)
        REFERENCES animal(i_id_animal),
    CONSTRAINT fk_consulta_veterinario
        FOREIGN KEY (i_id_veterinario)
        REFERENCES veterinario(i_id_veterinario)
);

CREATE TABLE consulta_has_medicamento(
    i_id_consulta INT NOT NULL,
    i_id_medicamento INT NOT NULL,
    i_qtd_CHM INT NOT NULL,
    PRIMARY KEY (i_id_consulta, i_id_medicamento),
    CONSTRAINT fk_CHM_consulta
        FOREIGN KEY (i_id_consulta)
        REFERENCES consulta(i_id_consulta),
    CONSTRAINT fk_CHM_medicamento
        FOREIGN KEY (i_id_medicamento)
        REFERENCES medicamento(i_id_medicamento)
);

CREATE TABLE consulta_has_exame(
    i_id_consulta INT NOT NULL,
    i_id_exame INT NOT NULL,
    i_qtd_CHE INT NOT NULL,
    PRIMARY KEY (i_id_consulta, i_id_exame),
    CONSTRAINT fk_CHE_consulta
        FOREIGN KEY (i_id_consulta)
        REFERENCES consulta(i_id_consulta),
    CONSTRAINT fk_CHE_exame
        FOREIGN KEY (i_id_exame)
        REFERENCES exame(i_id_exame)
);

CREATE TABLE BK_prontuario(
    i_id_BK_prontuario INT PRIMARY KEY AUTO_INCREMENT,
    i_id_consulta INT NOT NULL,
    v_anotacoes_antigas LONGTEXT,
    v_anotacoes_novas LONGTEXT,
    d_data_alteracao DATETIME DEFAULT CURRENT_TIMESTAMP
);