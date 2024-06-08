-- La aplicacio Workbench em dona el error que diu 'No connection esteblished' es el mateix que em pesaba a clase, pero ara pasa al meu ordinador persional, 
-- no ho se solucionar, per tant, et fare la actividad aquesta com si fos un 'manual', per culpa del error, tampoc he pogut comprobar alguns guions, 
-- intentare explicarte el millor posible el procediment de fer les copies de seguridad

-- 1 Còpia de seguretat de l’estructura de la base de dades

-- Per fer una copia de seguridad unicament de la estructura de la base de dades
-- se ha de escriure el seguent a mysqldump:

mysqldump -u Jordi -p FFIB --no-data > CSEstructura_FFIB.sql

-u Jordi // indica el nom del usuari
-p FFIB // indica el nom de la base de dades la cual vols fer la copia de seguridad
--no-data // indica que no vols copiar les dades, nomes la estructura
> CSEstructura_FFIB.sql // indica l''arxiu on es guardara la copia de seguridad

-- 2 Còpia de seguretat de totes les dades de la base de dades (només informació)

mysqldump -u Jordi -p FFIB > CopiaSeguridad.sql


-- 3 Còpia de seguretat de les dades de les taules que es modificaran setmanalment, 
-- a mesura que anem posant la informació dels partits que es juguen.

-- comande per fer una copia de seguridad dunicament de la taula parit i que se guardi a un archiu indicat
mysqldump -u Jordi -p FFIB Partit > CopiaSeguridadPartidos.sql

-- comanda la cual el que fa es programar que faci una copia de seguridad automaticament una vegada a la semana de la ataula partit
-- i que la guardi al archiu CopiaSeguridadPartidos.sql
0 0 * * 1 mysqldump -u nombre_usuario -p nombre_base_de_datos Partit > /ruta/del/archivo/backup_partits.sql
