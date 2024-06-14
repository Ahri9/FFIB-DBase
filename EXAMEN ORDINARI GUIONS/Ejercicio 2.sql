-- 2 --------------------------------------------------------
DELIMITER //

CREATE PROCEDURE TargetaVermella(NomCategoria VARCHAR(20))
BEGIN

	DECLARE NomCategoria varchar(20);

	SELECT count(e_tipo) FROM esdeveniments e
    JOIN jugadors j USING (e_jugador_id)
    JOIN jugador_partit USING (j_jugador_id)
    JOIN equips eq USING (eq_equip_id)
    JOIN subcategoria s USING (subcategoria_id)
    JOIN categoria c USING (categoria_id)
    
    WHERE e_tipo = 'TV';
    SET NomCategoriac = c_nom;
	
END//

DELIMITER ;

CAll TargetaVarmella('Femeni');

