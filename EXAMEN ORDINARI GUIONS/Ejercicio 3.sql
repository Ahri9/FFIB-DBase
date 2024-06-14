-- 3 -----------------------------------------------------------
DELIMITER //
    
CREATE TRIGGER Canvi
BEFORE UPDATE ON esdevenimets
FOR EACH ROW

	CREATE FUNCTION Suplets(EStat INT)
    returns int
    begin 
    
	SELECT e_jugador_canvi FROM esdeveniments e
	JOIN jugadors j USING (jugador_id)
    JOIN jugador_partit jp USING (jugador_id)
    where jp_estat = 0;
    
    IF jp_estat = 1 THEN 
    ALTER TABLE jugador_partit MODIFY COLUMN jp_estat = 0
    
    THEN IF jp_estat = NULL THEN
    ALTER TABLE jugador_partit MODIFY COLUMN jp_estat = 0
    
END //
DELIMITER ;
