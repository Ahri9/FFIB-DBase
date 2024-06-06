create database FFIB2;
use ffib2;

CREATE TABLE Arbitre (
    arbitre_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(70) NOT NULL
);

CREATE TABLE Club (
    club_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(70) NOT NULL,
    escut BLOB,
    illa VARCHAR(25) NOT NULL,
    municipi VARCHAR(30) NOT NULL,
    codi_postal VARCHAR(5),
    web VARCHAR(64),
    equipacio VARCHAR(20),
    direccio VARCHAR(150)
);

CREATE TABLE Categoria (
    categoria_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100)
);

CREATE TABLE Subcategoria (
    subcategoria_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(70),
    categoria_id TINYINT UNSIGNED,
    FOREIGN KEY (categoria_id) REFERENCES Categoria(categoria_id)
);

CREATE TABLE Campo (
    campo_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    cesped ENUM('Gespa artificial', 'Herba sintètica', 'Gespa natural', 'Terra/Terreny', 'Sorra', 'Mixt (híbrid)', 'Grava'),
    tipo ENUM('futbol 7', 'futbol 11', 'futbol sala'),
    nom VARCHAR(50) NOT NULL UNIQUE,
    codi_postal VARCHAR(5),
    adressa VARCHAR(100),
    ubicacio POINT,
	servicios VARCHAR(70)
);

CREATE TABLE Clasificacio (
    clasificacio_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    pts TINYINT UNSIGNED,
    pj TINYINT UNSIGNED,
    pg TINYINT UNSIGNED,
    pe TINYINT UNSIGNED,
    pp TINYINT UNSIGNED,
    gf TINYINT UNSIGNED,
    gc TINYINT UNSIGNED,
    pen TINYINT UNSIGNED,
    ps TINYINT UNSIGNED
);

CREATE TABLE Equips (
    equip_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(55) NOT NULL,
    subcategoria_id TINYINT UNSIGNED,
    club_id SMALLINT UNSIGNED,
    camp_id SMALLINT UNSIGNED,
    entrenador VARCHAR(100),
    FOREIGN KEY (subcategoria_id) REFERENCES Subcategoria(subcategoria_id),
    FOREIGN KEY (club_id) REFERENCES Club(club_id),
    FOREIGN KEY (camp_id) REFERENCES Campo(campo_id)
);

CREATE TABLE Partit (
    partit_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    estat ENUM ('F', 'C', 'J') NOT NULL,
    jornada TINYINT UNSIGNED,
    fecha DATE,
    hora TIME,
    equip_local SMALLINT UNSIGNED NOT NULL,
    equip_visitante SMALLINT UNSIGNED NOT NULL,
    FOREIGN KEY (equip_local) REFERENCES Equips(equip_id),
    FOREIGN KEY (equip_visitante) REFERENCES Equips(equip_id)
);

CREATE TABLE partit_arbit (
	partit_id SMALLINT UNSIGNED,
    arbit_id SMALLINT UNSIGNED,
    principal boolean
);

CREATE TABLE Jugadors (
    jugador_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(70) NOT NULL,
    fecha_nacimiento DATE,
    dorsal TINYINT UNSIGNED NOT NULL,
    posicion VARCHAR (20),
    equip_id SMALLINT UNSIGNED,
    esdeveniments TINYINT UNSIGNED,
    FOREIGN KEY (equip_id) REFERENCES Equips(equip_id)
);

CREATE TABLE jugador_partit (
	jugador_id SMALLINT UNSIGNED,
    partit_id SMALLINT UNSIGNED,
    estat boolean,
    FOREIGN KEY (jugador_id) REFERENCES Jugadors(jugador_id),
    FOREIGN KEY (partit_id) REFERENCES Partit(partit_id)
);

CREATE TABLE Esdeveniments (
    esdeveniment_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    tipo ENUM ('CV', 'G', 'P', 'PP', 'TG', 'DTG', 'TV') NOT NULL,
    minut TINYINT UNSIGNED NOT NULL,
    partit_id SMALLINT UNSIGNED NOT NULL,
    jugador_id SMALLINT UNSIGNED NOT NULL,
    jugador_canvi SMALLINT UNSIGNED,
    FOREIGN KEY (partit_id) REFERENCES Partit(partit_id),
    FOREIGN KEY (jugador_id) REFERENCES Jugadors(jugador_id),
    FOREIGN KEY (jugador_canvi) REFERENCES Jugadors(jugador_id)
);