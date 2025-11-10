WITH media AS (
  SELECT AVG(qtd) AS media
  FROM (
        SELECT indigenas_id, COUNT(*) AS qtd
        FROM   indigenas_idiomas
        GROUP  BY indigenas_id
  ) x)
SELECT ind.nome
FROM   indigenas           ind
JOIN   indigenas_idiomas   idi ON idi.indigenas_id = ind.id_indigenas
JOIN   comercios           cm  ON cm.indigenas_id  = ind.id_indigenas
JOIN   comercios_produtos  cp  ON cp.comercios_id  = cm.id_comercios
JOIN   produtos            pr  ON pr.id_produtos   = cp.produtos_id
WHERE  pr.nome = 'Ouro'
GROUP  BY ind.id_indigenas, ind.nome
HAVING COUNT(idi.idioma) >= (SELECT media FROM media);
