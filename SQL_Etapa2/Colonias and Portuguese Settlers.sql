-- 2.1  colonias
INSERT INTO colonias (nome, regiao, populacao)
VALUES
  ('São Vicente','Sudeste',1200),
  ('Pernambuco' ,'Nordeste',2300),
  ('Bahia'      ,'Nordeste',2100),
  ('Rio de Janeiro','Sudeste',1800),
  ('Maranhão'   ,'Norte',900)
ON CONFLICT (nome) DO NOTHING;

-- 2.2  portugueses
INSERT INTO portugueses (nome,cargo,colonias_id) VALUES
  ('João Álvares','comerciante',1),
  ('Marcos Santos','governador',2),
  ('Pedro Leitão','comerciante',3),
  ('Carlos Paiva','capitão',2),
  ('Antônio Dias','padre',4);

-- 2.3  indigenas + idiomas
INSERT INTO indigenas (nome,tribo) VALUES
  ('Aruá','Tupinambá'),
  ('Caeté','Yanomami'),
  ('Piraí','Tupiniquim'),
  ('Irapuã','Potiguara'),
  ('Anahí','Tremembé');

-- evita erro de duplicidade
INSERT INTO indigenas_idiomas (indigenas_id, idioma) VALUES
  (1,'Português'),
  (2,'Tupi'),
  (3,'Guarani'),
  (4,'Tupi'),
  (5,'Tupi')
ON CONFLICT (indigenas_id, idioma) DO NOTHING;

-- 2.4  subclasses exclusivas — id_indigenas é PK + FK
/* Caçadores */
INSERT INTO cacadores (id_indigenas, tipo_de_caca, ferramentas) VALUES
  (1, 'Capivara', 'arco e flecha')
ON CONFLICT (id_indigenas) DO NOTHING;   

/* Pescadores */
INSERT INTO pescadores (id_indigenas, quantidade_peixes, tecnica) VALUES
  (3, 300, 'rede de cerco'),
  (4, 120, 'arpão')
ON CONFLICT (id_indigenas) DO NOTHING;

/* Artesãos */
INSERT INTO artesoes (id_indigenas, tipo_de_artesanato, materiais) VALUES
  (2, 'Cerâmica', 'barro vermelho'),
  (5, 'Cestaria', 'fibra de tucum')
ON CONFLICT (id_indigenas) DO NOTHING;


-- 2.5  produtos  (nome é UNIQUE)
INSERT INTO produtos (nome, tipo, valor) VALUES
  ('Pau-Brasil',           'madeira',   500.00),
  ('Ouro',                 'mineral',  1200.00),
  ('Açúcar',               'agrícola',  150.00),
  ('Tabaco',               'agrícola',   90.00),
  ('Artesanato Potiguara', 'artístico', 300.00)
ON CONFLICT (nome) DO NOTHING;


-- 2.6  embarcações  (nome é UNIQUE)
INSERT INTO embarcacoes (nome, capacidade, porto_origem_cidade, porto_origem_regiao) VALUES
  ('Caravela Santa Luzia',  80, 'Lisboa',          'Portugal'),
  ('Galeão Atlântico',     120, 'Porto',           'Portugal'),
  ('Navio-Mercante Luz',    60, 'Salvador',        'Bahia'),
  ('Caravela do Sul',       75, 'Rio de Janeiro',  'Sudeste'),
  ('Barca Esperança',       40, 'Olinda',          'Nordeste')
ON CONFLICT (nome) DO NOTHING;


-- 2.7  maos_de_obra REGRA: (tipo, funcao, portugueses_id) é única para evitar repetição
-- 1º crie um índice/constraint para usar no ON CONFLICT
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'maos_de_obra_unique_func'
  ) THEN
    ALTER TABLE maos_de_obra
      ADD CONSTRAINT maos_de_obra_unique_func
      UNIQUE (tipo, funcao, portugueses_id);
  END IF;
END $$;

INSERT INTO maos_de_obra (tipo, funcao, portugueses_id) VALUES
  ('escravizada','carregador',1),
  ('livre',      'marinheiro',3),
  ('escravizada','cortador',  2),
  ('livre',      'guia',      1),
  ('escravizada','artesão',   2)
ON CONFLICT (tipo, funcao, portugueses_id) DO NOTHING;

-- 2.8  comercios Regra natural = (data_troca, portugueses_id, COALESCE(indigenas_id,0))
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'comercios_unq'
  ) THEN
    ALTER TABLE comercios
      ADD CONSTRAINT comercios_unq
      UNIQUE (data_troca, portugueses_id, indigenas_id);
  END IF;
END $$;

INSERT INTO comercios (data_troca, portugueses_id, indigenas_id) VALUES
  ('1555-05-12',1,1),
  ('1556-07-03',2,2),
  ('1557-01-22',3,3),
  ('1558-04-18',4,NULL),        -- sem indígena principal
  ('1559-09-10',1,5)
ON CONFLICT (data_troca, portugueses_id, indigenas_id) DO NOTHING;

-- 2.9  tabelas‐ponte N:M PK composta já evita duplicatas; basta ON CONFLICT DO NOTHING
INSERT INTO comercios_produtos (comercios_id, produtos_id, quantidade) VALUES
  (1,1,30),(1,5,10),
  (2,2,5),
  (3,3,50),(3,4,25),
  (4,1,40),
  (5,5,15),
  (3,2,10)
ON CONFLICT (comercios_id, produtos_id) DO NOTHING;

INSERT INTO comercios_embarcacoes (comercios_id, embarcacoes_id) VALUES
  (1,1),(1,3),
  (2,2),
  (3,3),(3,4),
  (5,5)
ON CONFLICT (comercios_id, embarcacoes_id) DO NOTHING;

INSERT INTO comercios_maos_de_obra (comercios_id, maos_de_obra_id) VALUES
  (1,1),(1,2),
  (2,3),
  (3,2),(3,4),
  (5,5)
ON CONFLICT (comercios_id, maos_de_obra_id) DO NOTHING;

