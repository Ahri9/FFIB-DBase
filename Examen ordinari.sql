create database llibres;
use llibres;

CREATE TABLE usuaris (
usuari_id SMALLINT AUTO_INCREMENT PRIMARY KEY,
nom VARCHAR(50),
adreça VARCHAR(100),
telefon VARCHAR(9),
email VARCHAR(40),
data_naixament DATETIME);

CREATE TABLE autors (
autor_id INT AUTO_INCREMENT PRIMARY KEY,
nom VARCHAR(70),
data_naixament DATETIME);

CREATE TABLE llibres (
ISBN TINYINT AUTO_INCREMENT primary key,
titol VARCHAR(50),
any_publicacio date,
num_exemplars MEDIUMINT,
autor_id INT,
FOREIGN KEY (autor_id) REFERENCES autors(autor_id));

CREATE TABLE categorias (
categoria_id SMALLINT AUTO_INCREMENT PRIMARY KEY,
nom VARCHAR (50),
llibres_id TINYINT,
FOREIGN KEY (llibres_id) REFERENCES llibres(ISBN));

CREATE TABLE prestec (
data_inici DATETIME,
data_fi DATETIME,
multa SMALLINT,
usuari_id SMALLINT,
llibre_id TINYINT,
FOREIGN KEY (usuari_id) REFERENCES usuaris(usuari_id),
FOREIGN KEY (llibre_id) REFERENCES llibres(ISBN));