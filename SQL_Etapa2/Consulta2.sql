SELECT co.nome                    AS colonia,
       SUM(cp.quantidade)         AS total_pau_brasil
FROM   colonias             co
JOIN   portugueses          po ON po.colonias_id   = co.id_colonias
JOIN   comercios            cm ON cm.portugueses_id = po.id_portugueses
JOIN   comercios_produtos   cp ON cp.comercios_id  = cm.id_comercios
JOIN   produtos             pr ON pr.id_produtos   = cp.produtos_id
WHERE  pr.nome = 'Pau-Brasil'
GROUP  BY co.nome
HAVING SUM(cp.quantidade) > 0
ORDER  BY total_pau_brasil DESC;
