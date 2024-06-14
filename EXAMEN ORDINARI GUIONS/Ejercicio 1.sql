-- 1 ----------------------------------------------------
DELIMITER //

CREATE FUNCTION NoConvocats(NomEquip varchar(30))
returns INT
begin

	SELECT count(*) from jugadors j
    JOIN jugador_partit jp using (jugador_id)
    JOIN equip e using (equip_id)
    WHERE jp_estat = 0;
    SET NomEquip = e_nom;
    END //
    
    DELIMITER ;
    SELECT NoConvocats('Inter Manacor');
    