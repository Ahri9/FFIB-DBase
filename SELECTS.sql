-- Llistat de partits i nom d’equip que tenen un nombre inferior de 11 convocats
SELECT count(jp.partit_id), eq.nom FROM jugador_partit jp
JOIN jugadors jug USING (jugador_id)
JOIN equips eq USING (equip_id)
GROUP BY jp.partit_id, eq.equip_id
HAVING count(jp.partit_id) < 11;
-- aquest select no te un resultat com ha tal, per que doni un resultat, se hauria de cambiar el jugador amb id 13 a id 126


-- Nom i equip del jugador pitxitxi, és a dir, jugador amb més gols a la lliga.
SELECT ju.nom, eq.equip_id, count(es.tipo) FROM esdeveniments es
JOIN jugadors ju USING (jugador_id)
JOIN equips eq ON eq.equip_id = ju.jugador_id
WHERE es.tipo IN ('G', 'P')
GROUP BY ju.nom, eq.equip_id
HAVING count(es.tipo) > 0
ORDER BY count(es.tipo) DESC
LIMIT 1;


-- Nom del club i nom de l’equip que ha jugat més partit.
SELECT eq.nom, cl.nom, count(p.partit_id) FROM equips eq
JOIN club cl USING (club_id)
JOIN partit p ON equip_id = equip_local OR equip_id = equip_visitante
GROUP BY cl.nom, eq.nom
ORDER BY count(p.partit_id) DESC
LIMIT 1;


-- Nom dels camps que tenen Despatx Arbitral
SELECT nom, servicios FROM campo 
WHERE servicios LIKE '%Despatx Arbitral%';


-- Nom de l’àrbitre que ha arbitrat més partits com a principal.
SELECT ar.nom, COUNT(ap.arbit_id) FROM partit_arbit ap 
JOIN arbitre ar ON ap.arbit_id = ar.arbitre_id 
WHERE ap.principal = 1 
GROUP BY ar.nom 
ORDER BY COUNT(ap.arbit_id) DESC 
LIMIT 1;
