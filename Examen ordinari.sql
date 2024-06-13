create database llibres;
use llibres;

CREATE TABLE categorias (
categoria_id SMALLINT AUTO_INCREMENT PRIMARY KEY,
nom VARCHAR (50));

CREATE TABLE llibres (
ISBN VARCHAR(13) primary key,
titol VARCHAR(50),
any_publicacio date,
num_exemplars MEDIUMINT);

CREATE TABLE prestec (
data_inici DATETIME,
data_fi DATETIME,
multa SMALLINT);

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