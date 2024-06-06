-- arbitre
ALTER TABLE arbitre DROP COLUMN apellidos;
ALTER TABLE arbitre MODIFY COLUMN nom VARCHAR(50);

-- categoria
ALTER TABLE categoria ADD COLUMN nom VARCHAR(255);
ALTER TABLE categoria DROP COLUMN subcategoria_id;
ALTER TABLE subcategoria MODIFY COLUMN nom VARCHAR(50);

-- equips
ALTER TABLE Equips ADD COLUMN entrenador VARCHAR(100);
ALTER TABLE Equips DROP column clasificacio_id;
ALTER TABLE Equips MODIFY column nom VARCHAR(70) NOT NULL;
ALTER TABLE Equips DROP INDEX nom;

-- club
ALTER TABLE Club DROP COLUMN cantidad_equipos,
	DROP COLUMN primera_equipacio;
ALTER TABLE Club DROP COLUMN segona_equipacio;
ALTER TABLE Club ADD COLUMN equipacio VARCHAR(20);
ALTER TABLE Club MODIFY COLUMN web VARCHAR(255);
ALTER TABLE Club MODIFY COLUMN codi_postal VARCHAR(5);
ALTER TABLE Club ADD COLUMN direccio VARCHAR(255);
ALTER TABLE Club MODIFY COLUMN municipi VARCHAR(70);

-- campo
ALTER TABLE Campo DROP COLUMN equip_id;
ALTER TABLE Campo DROP COLUMN localidad;
ALTER TABLE Campo DROP COLUMN s_antidopaje;
ALTER TABLE Campo DROP COLUMN des_arbitral;
ALTER TABLE Campo MODIFY COLUMN servicios SET('Vallat', 'Sala antidopatge', 'Despatx Arbitral', 'Internet');
ALTER TABLE Campo MODIFY COLUMN cesped VARCHAR(50);
ALTER TABLE Campo MODIFY COLUMN ubicacio VARCHAR(200);
ALTER TABLE Campo MODIFY COLUMN cesped ENUM('Herba sintètica', 'Gespa natural', 'Terra/Terreny', 'Sorra', 'Mixt (híbrid)', 'Grava', 'Gespa Artificial');

-- jugadors
ALTER TABLE jugadors DROP COLUMN apellidos;
ALTER TABLE jugadors DROP COLUMN edad;
ALTER TABLE jugadors DROP COLUMN partit_id;
ALTER TABLE jugadors ADD COLUMN fecha_nacimiento DATE;
ALTER TABLE jugadors MODIFY COLUMN nom VARCHAR(100);
ALTER TABLE jugadors MODIFY COLUMN posicion ENUM ('portero', 'defensa', 'centro', 'delantero');
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

ALTER TABLE jugadors DROP FOREIGN KEY jugadors_ibfk_2;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- jugador_partit
ALTER TABLE jugador_partit MODIFY COLUMN estat ENUM ('1', '0');   


-- partit
ALTER TABLE partit ADD COLUMN hora TIME;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

ALTER TABLE partit DROP FOREIGN KEY partit_ibfk_3;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

ALTER TABLE partit DROP COLUMN camp_id;
ALTER TABLE partit ADD COLUMN estat ENUM('F', 'J', 'C');
ALTER TABLE partit DROP COLUMN resultat;
ALTER TABLE partit ADD COLUMN jornada TINYINT UNSIGNED;

ALTER TABLE partit_arbit DROP column arbit_parit_id;
ALTER TABLE partit_arbit ADD PRIMARY KEY (partit_id, arbit_id);
ALTER TABLE partit_arbit ADD FOREIGN KEY (partit_id) REFERENCES partit(partit_id),
	ADD FOREIGN KEY (arbit_id) REFERENCES arbitre(arbitre_id);
    
-- entrenadors

drop table entrenadors;

-- partit_arbit
ALTER TABLE partit_arbit CHANGE tipo principal boolean;

-- jugador_partit
ALTER TABLE jugador_partit DROP column jugador_partit_id;
ALTER TABLE jugador_partit ADD PRIMARY KEY (jugador_id, partit_id);
ALTER TABLE jugador_partit ADD FOREIGN KEY (partit_id) REFERENCES partit(partit_id),
	ADD FOREIGN KEY (jugador_id) REFERENCES jugadors(jugador_id);
    
    ALTER TABLE jugador_partit MODIFY COLUMN estat boolean;
    
-- esdeveniments

ALTER TABLE esdeveniments
ADD COLUMN jugador_canvi  SMALLINT UNSIGNED;
ALTER TABLE esdeveniments ADD CONSTRAINT fk_jugador_canvi FOREIGN KEY (jugador_canvi) REFERENCES jugadors(jugador_id);
ALTER TABLE esdeveniments MODIFY COLUMN tipo ENUM ('CV', 'G', 'P', 'PP', 'TG', 'DTG', 'TV') NOT NULL