CREATE DATABASE FFIB;
use FFIB;

CREATE TABLE Arbitre (
    arbitre_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(20) NOT NULL,
    apellidos VARCHAR(25) NOT NULL
);

CREATE TABLE Club (
    club_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(50) NOT NULL UNIQUE,
    escut BLOB,
    illa VARCHAR(25) NOT NULL,
    municipi VARCHAR(25) NOT NULL,
    codi_postal VARCHAR(5) NOT NULL,
    web VARCHAR(64) NOT NULL,
    cantidad_equipos SMALLINT UNSIGNED,
    primera_equipacio VARCHAR(255),
    segona_equipacio VARCHAR(255)
);

CREATE TABLE Categoria (
    categoria_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    temporada VARCHAR(255),
    subcategoria_id TINYINT UNSIGNED
);

CREATE TABLE Subcategoria (
    subcategoria_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(20),
    categoria_id TINYINT UNSIGNED,
    FOREIGN KEY (categoria_id) REFERENCES Categoria(categoria_id)
);

CREATE TABLE Campo (
    campo_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    equip_id SMALLINT UNSIGNED NOT NULL,
    cesped ENUM('artificial', 'natural', 'tierra', 'parquet'),
    tipo ENUM('futbol 7', 'futbol 11', 'futbol sala'),
    nom VARCHAR(50) NOT NULL UNIQUE,
    localidad VARCHAR(50),
    codi_postal VARCHAR(5) NOT NULL,
    adressa VARCHAR(100),
    ubicacio POINT NOT NULL,
    s_antidopaje ENUM('S', 'N'),
    des_arbitral ENUM('S', 'N')
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
    nom VARCHAR(55) NOT NULL UNIQUE,
    subcategoria_id TINYINT UNSIGNED,
    club_id SMALLINT UNSIGNED,
    clasificacio_id SMALLINT UNSIGNED,
    camp_id SMALLINT UNSIGNED,
    FOREIGN KEY (subcategoria_id) REFERENCES Subcategoria(subcategoria_id),
    FOREIGN KEY (club_id) REFERENCES Club(club_id),
    FOREIGN KEY (clasificacio_id) REFERENCES Clasificacio(clasificacio_id),
    FOREIGN KEY (camp_id) REFERENCES Campo(campo_id)
);

CREATE TABLE Partit (
    partit_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    resultat ENUM ('G', 'P', 'E') NOT NULL,
    fecha DATE,
    equip_local SMALLINT UNSIGNED NOT NULL,
    equip_visitante SMALLINT UNSIGNED NOT NULL,
    camp_id SMALLINT UNSIGNED,
    FOREIGN KEY (equip_local) REFERENCES Equips(equip_id),
    FOREIGN KEY (equip_visitante) REFERENCES Equips(equip_id),
    FOREIGN KEY (camp_id) REFERENCES Campo(campo_id)
);

CREATE TABLE partit_arbit (
    arbit_parit_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	partit_id SMALLINT UNSIGNED,
    arbit_id SMALLINT UNSIGNED,
    tipo ENUM ('arbitro1', 'arbitro2', 'arbitro3')
);

CREATE TABLE Entrenadors (
    entrenador_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    equip_id SMALLINT UNSIGNED,
    nom VARCHAR(255) NOT NULL,
    FOREIGN KEY (equip_id) REFERENCES Equips(equip_id)
);

CREATE TABLE Jugadors (
    jugador_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(30) NOT NULL,
    apellidos VARCHAR(60) NOT NULL,
    edad TINYINT UNSIGNED,
    dorsal TINYINT UNSIGNED NOT NULL,
    posicion ENUM ('portero', 'defensa', 'centro', 'delantero') NOT NULL,
    equip_id SMALLINT UNSIGNED,
    esdeveniments_id SMALLINT UNSIGNED,
    partit_id SMALLINT UNSIGNED,
    FOREIGN KEY (equip_id) REFERENCES Equips(equip_id),
    FOREIGN KEY (partit_id) REFERENCES Partit(partit_id)
);

CREATE TABLE jugador_partit (
    jugador_partit_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	jugador_id SMALLINT UNSIGNED,
    partit_id SMALLINT UNSIGNED,
    estat ENUM ('titular', 'suplent'),
    FOREIGN KEY (jugador_id) REFERENCES Jugadors(jugador_id),
    FOREIGN KEY (partit_id) REFERENCES Partit(partit_id)
);

CREATE TABLE Esdeveniments (
    esdeveniment_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    tipo ENUM ('gol', 'penalti', 'gol en propia', 'canvi de jugadors', 'targeta groga', 'doble targeta groga', 'targeta vermella') NOT NULL,
    minut TINYINT UNSIGNED NOT NULL,
    partit_id SMALLINT UNSIGNED NOT NULL,
    jugador_id SMALLINT UNSIGNED NOT NULL,
    FOREIGN KEY (partit_id) REFERENCES Partit(partit_id),
    FOREIGN KEY (jugador_id) REFERENCES Jugadors(jugador_id)
);
