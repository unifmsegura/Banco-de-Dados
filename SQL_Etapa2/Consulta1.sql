SELECT pr.nome  AS produto,
       pr.valor AS valor_reais
FROM   produtos            pr
JOIN   comercios_produtos  cp ON pr.id_produtos = cp.produtos_id
JOIN   comercios           co ON co.id_comercios = cp.comercios_id
JOIN   portugueses         po ON po.id_portugueses = co.portugueses_id
WHERE  po.nome = 'Marcos Santos'
ORDER  BY pr.valor DESC;
