### Vistas ###
# Crear una vista que me permita revisar el programa de data analyst
-- Explicamos el like y la funcion lower
DROP VIEW IF EXISTS view_data_analyst;
CREATE VIEW  view_data_analyst AS
SELECT 
	* # descripcion, inversion 
FROM programa
WHERE LOWER(descripcion) LIKE "%data analyst%";

select * from view_data_analyst;

# Crear una vista que me permita revisar el programa de data engineer
DROP VIEW IF EXISTS view_data_engineering;
CREATE VIEW view_data_engineering AS
SELECT descripcion, inversion FROM programa
WHERE LOWER(descripcion) LIKE "%data engineer%";

select * from view_data_engineering;

-- Para los alumnos
-- ejemplo 1) Una vista para obtener los detalles de los programas con su respectivo coordinador.
CREATE VIEW vista_programa_coordinador AS
SELECT p.codigo_programa, p.descripcion, p.inversion, p.horario_clases, c.nombres AS nombre_coordinador, c.direccion
FROM programa p
JOIN coordinador c ON p.codigo_coordinador = c.codigo_coordinador;

select * from vista_programa_coordinador;
-- ejemplo 2) Una vista para obtener la lista de estudiantes junto con sus programas matriculados.

CREATE VIEW vista_estudiantes_programas AS
SELECT e.dni_estudiante, e.nombre AS nombre_estudiante, e.telefono, p.descripcion AS programa, pe.fecha_matricula
FROM estudiante e
JOIN programa_estudiante pe ON e.dni_estudiante = pe.dni_estudiante
JOIN programa p ON pe.codigo_programa = p.codigo_programa;

SELECT * FROM vista_estudiantes_programas;


### Ejemplo de Procedimientos Almacenados
## Listas los programas que se desarrollan en un dia específico de la semana
DROP PROCEDURE IF EXISTS sp_programa_dia;
DELIMITER $$
CREATE PROCEDURE sp_programa_dia (IN dia_semana VARCHAR (50))
BEGIN 
	SELECT * FROM programa
	WHERE LOWER(horario_clases) LIKE CONCAT('%' ,LOWER(dia_semana) , '%');
END
$$

CALL sp_programa_dia("Lunes");

-- ejemplo 3) Procedimiento almacenado para eliminar un programa
-- IN: INT codigo_programa
-- CALL: eliminar_programa(id)
-- * ojo a las llaves foraneas que existe entre las diferentes tablas (primer las tablas principales y luego la original)
DROP PROCEDURE IF EXISTS sp_eliminar_programa;
DELIMITER $$
CREATE PROCEDURE sp_eliminar_programa (IN codigo_programa_in INT)
BEGIN
    DELETE FROM programa_tutor
    WHERE codigo_programa = codigo_programa_in;

    DELETE FROM programa_estudiante
    WHERE codigo_programa = codigo_programa_in;

    DELETE FROM programa
    WHERE codigo_programa = codigo_programa_in;
END
$$


call sp_eliminar_programa(7);

-- ejemplo 4) Procedimiento almacenado para para listar todos los programas de un estudiante por su dni
-- int dni_estudiante varchar(8)
-- CALL listar_programas_estudiante(dni_estudiante)
DROP PROCEDURE IF EXISTS listar_programas_estudiante;
DELIMITER $$
CREATE PROCEDURE listar_programas_estudiante(IN dni_estudiante VARCHAR(8))
BEGIN
    SELECT p.descripcion, pe.fecha_matricula
    FROM programa p
    JOIN programa_estudiante pe ON p.codigo_programa = pe.codigo_programa
    WHERE pe.dni_estudiante = dni_estudiante;
END 
$$

call listar_programas_estudiante('45645647');


## Funciones
## Funciones implícitas
# Funciones de texto
SELECT LOWER("Hola") AS minuscula;
SELECT UPPER("hola") AS mayuscula;
SELECT LENGTH("Hola amigos del DAP6") AS saludo;
SELECT CONCAT("hola ", "amigos ","del ","DAP6") AS saludo;

# Funciones de número
SELECT ROUND(2.45232234234,6) AS numero_redondeado
SELECT ABS(-1234) AS valor_absoluto
SELECT LOG(10,100) AS log_base10_100
SELECT PI() AS pi
SELECT SQRT(4) as raiz_cuatro

# Funciones de Fecha
SELECT CURRENT_DATE() AS fecha_actual;
SELECT CURRENT_TIME() AS fecha_actual;
SELECT ADDDATE("2023-06-27", INTERVAL 5 DAY) as fecha_en_5_dias;
SELECT ADDDATE("2023-06-27", INTERVAL 1 MONTH) as fecha_en_1_mes;
SELECT DATEDIFF("2023-06-27", "2023-06-21") as diferencia_fechas;

SELECT DAY("2023-06-27") as dia;
SELECT MONTH("2023-06-27") as dia;
SELECT YEAR("2023-06-27") as dia;

SELECT EXTRACT(MONTH FROM "2017-06-15");

## FUNCIONES EXPLÍCITAS
## Crear una funcion que retorne el precio promedio de un programa (DAP, DEP, DS)

 DELIMITER $$
 CREATE FUNCTION precio_promedio( programa VARCHAR (30))
 RETURNS DOUBLE
 DETERMINISTIC
 BEGIN 
	IF programa="DAP"
			THEN 
				SET  @precio_promedio:= (SELECT AVG(inversion) FROM programa
                WHERE LOWER(descripcion) LIKE  "%data analyst%");
	ELSEIF (programa="DEP")
			THEN 
				SET @precio_promedio:= (SELECT AVG(inversion) FROM programa
                WHERE LOWER(descripcion) LIKE  "%data engineer%");
	ELSEIF (programa="DSP")
			THEN 
				SET @precio_promedio:= (SELECT AVG(inversion) FROM programa
                WHERE LOWER(descripcion) LIKE "%data scientist%");
    	 END IF;
          RETURN (@precio_promedio);
  END;
 $$

select precio_promedio('DEP');


-- Ejemplo 6) 
## ETIQUETAR LOS PROGRAMAS DE ACUERDO A SU INVERSIÓN DE LA SIGUIENTE MANERA:
## SI EL PROGRAMA CUESTA MÁS DE 800, ETIQUETAR COMO PRECIO ALTO
## SI EL PROGRAMA CUESTA ENTRE 500 A 800, ETIQUETAR COMO PRECIO MEDIO
## SI EL PROGRAMA CUESTA MENOS QUE 500, ETIQUETAR COMO PRECIO BAJO

## CREAMOS UNA FUNCION DE ETIQUETADO
DROP FUNCTION IF EXISTS inversionCategoria;
DELIMITER $$
CREATE FUNCTION inversionCategoria(precio FLOAT)
RETURNS VARCHAR(30)
DETERMINISTIC
 BEGIN
	DECLARE categoria VARCHAR(30);
    
    IF precio >= 800 THEN SET categoria = "Precio Alto";
    ELSEIF (precio>=500 and precio <800 ) THEN SET categoria = "Precio Medio";
    ELSE SET categoria ="Precio bajo";
    END IF;
    
    RETURN categoria;
 END;
$$

select inversionCategoria(900);


CREATE DATABASE DB_LOGS;
USE DB_LOGS;

-- Creamos una tabla log_studiante
CREATE TABLE log_tutor
(
	id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
	accion VARCHAR (500) NOT NULL,
	fecha DATETIME DEFAULT CURRENT_TIMESTAMP
)

select * from academico_datapath.tutor;

USE ACADEMICO_DATAPATH;

DROP TRIGGER IF EXISTS log_tutor;
DELIMITER $$
CREATE TRIGGER log_tutor AFTER INSERT ON tutor
FOR EACH ROW
BEGIN
	INSERT INTO DB_LOGS. `log_tutor`(accion) VALUES (CONCAT("Se insertó un nuevo tutor a la base de datos, y se llama : ", NEW.nombre));
END
$$

DROP TRIGGER IF EXISTS log_tutor_delete;
DELIMITER $$
CREATE TRIGGER log_tutor_delete AFTER DELETE ON tutor
FOR EACH ROW
BEGIN
INSERT INTO DB_LOGS. `log_tutor`(accion) VALUES (CONCAT("Se eliminó un tutor de la base de datos, y se llama : ", OLD.nombre));
END
$$


select * from tutor;

insert into tutor 
values ( '48124812' , 'https://www.linkedin.com/in/Jeremy', 'Pepe Ramirez')


delete from tutor where dni_tutor='48124812';

select * from DB_LOGS.log_tutor;