--PACK V3

--CRIAÇÃO TABELA TGRUPO_FAMILIAR

CREATE TABLE TGRUPO_FAMILIAR (
    ID_GRUPO_FAMILIAR  INTEGER NOT NULL,
    DESCRICAO          VARCHAR(150),
    CEP                VARCHAR(9),
    LOGRADOURO         VARCHAR(50),
    BAIRRO             VARCHAR(50),
    ENDERECO           VARCHAR(80),
    NRO                INTEGER,
    COMPLEMENTO        VARCHAR(50),
    CIDADE             INTEGER
);

COMMIT WORK;

ALTER TABLE TGRUPO_FAMILIAR ADD CONSTRAINT PK_GRUPO_FAMILIAR PRIMARY KEY (ID_GRUPO_FAMILIAR);

COMMIT WORK;

ALTER TABLE TGRUPO_FAMILIAR ADD CONSTRAINT FK_GRUPO_FAMILIAR_CIDADE FOREIGN KEY (CIDADE) REFERENCES TCIDADE (ID_CIDADE);

COMMIT WORK;

--CRIAÇÃO DO GENERATOR TGRUPO_FAMILIAR
CREATE GENERATOR GEN_TGRUPO_FAMILIAR_ID;
SET GENERATOR GEN_TGRUPO_FAMILIAR_ID TO 0;

COMMIT WORK;

--INTERAÇÃO TABELA PACIENTE
ALTER TABLE TPACIENTE
ADD GRUPO_FAMILIAR SMALLINT;

COMMIT WORK;

ALTER TABLE TPACIENTE ADD CONSTRAINT FK_PACIENTE_GRUPO_FAMILIAR FOREIGN KEY (GRUPO_FAMILIAR) REFERENCES TGRUPO_FAMILIAR (ID_GRUPO_FAMILIAR);

COMMIT WORK;

--CRIAÇÃO TABELA TEVENTO
CREATE TABLE TEVENTO (
    ID_EVENTO         INTEGER NOT NULL,
    PACIENTE          INTEGER,
    TIPO_EVENTO       CHAR(1),
    DATA_EVENTO       DATE,
    PROBLEMA          VARCHAR(300),
    FLAG_TRAT_OUTROS  CHAR(1),
    DESC_TRAT_OUTROS  VARCHAR(300),
    ULT_TRAT_ESP      DATE,
    FLAG_CIR_ESP      CHAR(1),
    DESC_CIR_ESP      VARCHAR(300),
    ULT_CIR_ESP       DATE
);

COMMIT WORK;

ALTER TABLE TEVENTO ADD CONSTRAINT PK_ID_EVENTO PRIMARY KEY (ID_EVENTO);

COMMIT WORK;

ALTER TABLE TEVENTO ADD CONSTRAINT FK_EVENTO_PACIENTE FOREIGN KEY (PACIENTE) REFERENCES TPACIENTE (ID_PACIENTE);

COMMIT WORK;

--CRIAÇÃO DO GENERATOR TGRUPO_FAMILIAR
CREATE GENERATOR GEN_TEVENTO_ID;
SET GENERATOR GEN_TEVENTO_ID TO 0;

COMMIT WORK;

 
ALTER TABLE TEVENTO ALTER PROBLEMA TYPE VARCHAR(500);



