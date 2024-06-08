-- GIONS 

-- 1 Crea un guió que empleni la taula Classificació amb els partits que ja han finalitzat. 
-- Aquest guió ha de rebre com a paràmetre un id_equip.

DELIMITER //
CREATE PROCEDURE ActualizarClasificacion(IN equip_id SMALLINT UNSIGNED)
BEGIN

    DECLARE puntos, partidos_jugados, partidos_ganados, partidos_empatados, partidos_perdidos, goles_favor, goles_contra INT DEFAULT 0;

    DECLARE cur_local CURSOR FOR
    SELECT es.equip_local, es.equip_visitante, 
           SUM(CASE WHEN e.tipo = 'G' THEN 1 ELSE 0 END) AS goles_local,
           SUM(CASE WHEN e.tipo = 'G' THEN 1 ELSE 0 END) AS goles_visitante
    FROM Partit p
    LEFT JOIN Esdeveniments e ON p.partit_id = e.partit_id
    WHERE p.equip_local = equipoId AND p.estat = 'F'
    GROUP BY p.partit_id;

    DECLARE cur_visitante CURSOR FOR
    SELECT es.equip_local, es.equip_visitante, 
           SUM(CASE WHEN e.tipo = 'G' THEN 1 ELSE 0 END) AS goles_local,
           SUM(CASE WHEN e.tipo = 'G' THEN 1 ELSE 0 END) AS goles_visitante
    FROM Partit p
    LEFT JOIN Esdeveniments e ON p.partit_id = e.partit_id
    WHERE p.equip_visitante = equipoId AND p.estat = 'F'
    GROUP BY p.partit_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur_local;
    read_loop_local: LOOP
        FETCH cur_local INTO l_equipo_local, l_equipo_visitante, l_goles_local, l_goles_visitante;
        IF done THEN
            LEAVE read_loop_local;
        END IF;
        
        SET partidos_jugados = partidos_jugados + 1;
        SET goles_favor = goles_favor + l_goles_local;
        SET goles_contra = goles_contra + l_goles_visitante;

        IF l_goles_local > l_goles_visitante THEN
            SET partidos_ganados = partidos_ganados + 1;
            SET puntos = puntos + 3;
        ELSEIF l_goles_local = l_goles_visitante THEN
            SET partidos_empatados = partidos_empatados + 1;
            SET puntos = puntos + 1;
        ELSE
            SET partidos_perdidos = partidos_perdidos + 1;
        END IF;
    END LOOP;
    CLOSE cur_local;

    OPEN cur_visitante;
    read_loop_visitante: LOOP
        FETCH cur_visitante INTO v_equipo_local, v_equipo_visitante, v_goles_local, v_goles_visitante;
        IF done THEN
            LEAVE read_loop_visitante;
        END IF;
        
        SET partidos_jugados = partidos_jugados + 1;
        SET goles_favor = goles_favor + v_goles_visitante;
        SET goles_contra = goles_contra + v_goles_local;

        IF v_goles_visitante > v_goles_local THEN
            SET partidos_ganados = partidos_ganados + 1;
            SET puntos = puntos + 3;
        ELSEIF v_goles_visitante = v_goles_local THEN
            SET partidos_empatados = partidos_empatados + 1;
            SET puntos = puntos + 1;
        ELSE
            SET partidos_perdidos = partidos_perdidos + 1;
        END IF;
    END LOOP;
    CLOSE cur_visitante;

    INSERT INTO Clasificacio (pts, pj, pg, pe, pp, gf, gc, pen, ps)
    VALUES (puntos, partidos_jugados, partidos_ganados, partidos_empatados, partidos_perdidos, goles_favor, goles_contra, penaltis, 0)
    ON DUPLICATE KEY UPDATE
        pts = VALUES(pts),
        pj = VALUES(pj),
        pg = VALUES(pg),
        pe = VALUES(pe),
        pp = VALUES(pp),
        gf = VALUES(gf),
        gc = VALUES(gc),
        pen = VALUES(pen),
        ps = VALUES(ps);
END //

DELIMITER ;

CALL ActualizarClasificacion(@equip_id);


-- 2 Crea un guió que cada vegada que un partit finalitzi (s’actualitzi l’estat) 
-- ha d’actualitzar la taula Classificació.

DELIMITER //
CREATE TRIGGER ActualizarClasificacion
AFTER UPDATE ON Partit
FOR EACH ROW
BEGIN
    IF NEW.estat = 'F' THEN
        CALL ActualizarClasificacion(NEW.equip_local);
        CALL ActualizarClasificacion(NEW.equip_visitante);
    END IF;
END //

DELIMITER ;



-- 4 Crea un guió que ens digui el nom del jugador pitxixi

DELIMITER //
CREATE PROCEDURE nompitxixi ()
BEGIN
SELECT ju.nom, eq.equip_id, count(es.tipo) FROM esdeveniments es
JOIN jugadors ju USING (jugador_id)
JOIN equips eq ON eq.equip_id = ju.jugador_id
WHERE es.tipo IN ('G', 'P')
GROUP BY ju.nom, eq.equip_id
HAVING count(es.tipo) > 0
ORDER BY count(es.tipo) DESC
LIMIT 1;

END //
DELIMITER ;



-- 5 Crea un guió que donat un subcategoria_id, ens digui el nom del l’equip que ha guanyat 
-- la competició, és a dir, el que ha obtingut més punts.

DELIMITER //
CREATE PROCEDURE subcategoriaWin ()
BEGIN
SELECT e.nom AS equipo_ganador, c.pts
FROM Equips e
JOIN Clasificacio c ON e.equip_id = c.clasificacio_id
WHERE e.subcategoria_id = @subcategoria_id
ORDER BY c.pts DESC
LIMIT 1;

END //
DELIMITER ;



-- 6 Crea un altre guió que creguis que pugui ser útil en aquesta base de dades. 
-- Procura no coincidir amb els companys.
-- El gui que jo he fet, te ense;a un resum dels equips, te diu la cantidad de pertits jugats, perduts, empetats y guanyats

DELIMITER //
CREATE PROCEDURE resumenequipos()
BEGIN
SELECT 
    e.nom AS nombre_equipo,
    COUNT(CASE WHEN p.estat = 'F' THEN 1 END) AS partidos_jugados,
    COUNT(CASE WHEN p.estat = 'F' AND ((p.equip_local = e.equip_id AND e1.tipo = 'G') OR (p.equip_visitante = e.equip_id AND e1.tipo = 'P')) THEN 1 END) AS partidos_ganados,
    COUNT(CASE WHEN p.estat = 'F' AND e1.tipo = 'E' THEN 1 END) AS partidos_empatados,
    COUNT(CASE WHEN p.estat = 'F' AND ((p.equip_local = e.equip_id AND e1.tipo = 'P') OR (p.equip_visitante = e.equip_id AND e1.tipo = 'G')) THEN 1 END) AS partidos_perdidos
FROM 
    Equips e
LEFT JOIN 
    Partit p ON e.equip_id = p.equip_local OR e.equip_id = p.equip_visitante
LEFT JOIN 
    Esdeveniments e1 ON p.partit_id = e1.partit_id
WHERE 
    YEAR(p.fecha) = 2024
GROUP BY 
    e.equip_id;
END //

DELIMITER ;

