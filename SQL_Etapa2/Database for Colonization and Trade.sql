-- 1.1  ENTIDADES FORTES

CREATE TABLE colonias (
    id_colonias         SERIAL PRIMARY KEY,
    nome                TEXT        NOT NULL UNIQUE,
    regiao              TEXT        NOT NULL,
    populacao           INT         CHECK (populacao >= 0)
);

CREATE TABLE portugueses (
    id_portugueses      SERIAL PRIMARY KEY,
    nome                TEXT        NOT NULL,
    cargo               TEXT        NOT NULL,
    colonias_id         INT         NOT NULL
        REFERENCES colonias(id_colonias)
        ON DELETE RESTRICT
);

CREATE TABLE indigenas (
    id_indigenas        SERIAL PRIMARY KEY,
    nome                TEXT        NOT NULL,
    tribo               TEXT        NOT NULL
);
-- atributo multivalorado idioma
CREATE TABLE indigenas_idiomas (
    indigenas_id        INT NOT NULL
        REFERENCES indigenas(id_indigenas) ON DELETE CASCADE,
    idioma              TEXT NOT NULL,
    PRIMARY KEY (indigenas_id, idioma)
);

CREATE TABLE produtos (
    id_produtos         SERIAL PRIMARY KEY,
    nome                TEXT NOT NULL UNIQUE,
    tipo                TEXT NOT NULL,
    valor               NUMERIC(12,2) CHECK (valor >= 0)
);

CREATE TABLE embarcacoes (
    id_embarcacoes          SERIAL PRIMARY KEY,
    nome                    TEXT NOT NULL UNIQUE,
    capacidade              INT  CHECK (capacidade > 0),
    porto_origem_cidade     TEXT NOT NULL,
    porto_origem_regiao     TEXT NOT NULL
);

CREATE TABLE maos_de_obra (
    id_maos_de_obra     SERIAL PRIMARY KEY,
    tipo                TEXT NOT NULL CHECK (tipo IN ('escravizada','livre')),
    funcao              TEXT NOT NULL,
    portugueses_id      INT NOT NULL
        REFERENCES portugueses(id_portugueses)
        ON DELETE CASCADE
);


-- 1.2  COMERCIO (entidade‐fraca independente)

CREATE TABLE comercios (
    id_comercios        SERIAL PRIMARY KEY,
    data_troca          DATE  NOT NULL,
    portugueses_id      INT   NOT NULL
        REFERENCES portugueses(id_portugueses)
        ON DELETE CASCADE,
    indigenas_id        INT
        REFERENCES indigenas(id_indigenas)
);


-- 1.3  TABELAS ASSOCIATIVAS N:M

-- comércio x produto (atrib. quantidade)
CREATE TABLE comercios_produtos (
    comercios_id    INT NOT NULL
        REFERENCES comercios(id_comercios) ON DELETE CASCADE,
    produtos_id     INT NOT NULL
        REFERENCES produtos(id_produtos)   ON DELETE RESTRICT,
    quantidade      INT NOT NULL CHECK (quantidade > 0),
    PRIMARY KEY (comercios_id, produtos_id)
);

-- comércio x embarcação
CREATE TABLE comercios_embarcacoes (
    comercios_id    INT NOT NULL
        REFERENCES comercios(id_comercios) ON DELETE CASCADE,
    embarcacoes_id  INT NOT NULL
        REFERENCES embarcacoes(id_embarcacoes) ON DELETE RESTRICT,
    PRIMARY KEY (comercios_id, embarcacoes_id)
);

-- comércio x mão de obra
CREATE TABLE comercios_maos_de_obra (
    comercios_id        INT NOT NULL
        REFERENCES comercios(id_comercios) ON DELETE CASCADE,
    maos_de_obra_id     INT NOT NULL
        REFERENCES maos_de_obra(id_maos_de_obra) ON DELETE CASCADE,
    PRIMARY KEY (comercios_id, maos_de_obra_id)
);


-- 1.4  ESPECIALIZAÇÃO TOTAL EXCLUSIVA (tabela-por-subclasse)

CREATE TABLE cacadores (
    id_indigenas        INT PRIMARY KEY
        REFERENCES indigenas(id_indigenas) ON DELETE CASCADE,
    tipo_de_caca        TEXT NOT NULL,
    ferramentas         TEXT NOT NULL
);

CREATE TABLE pescadores (
    id_indigenas        INT PRIMARY KEY
        REFERENCES indigenas(id_indigenas) ON DELETE CASCADE,
    quantidade_peixes   INT  CHECK (quantidade_peixes>=0),
    tecnica             TEXT NOT NULL
);

CREATE TABLE artesoes (
    id_indigenas        INT PRIMARY KEY
        REFERENCES indigenas(id_indigenas) ON DELETE CASCADE,
    tipo_de_artesanato  TEXT NOT NULL,
    materiais           TEXT NOT NULL
);
