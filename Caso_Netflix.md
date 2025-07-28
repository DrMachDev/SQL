# 🎬 Caso Netflix – Proyecto de Base de Datos

Este proyecto simula el modelamiento y diseño de una base de datos transaccional para una plataforma similar a Netflix. Incluye todas las fases: requisitos, diseño conceptual, diseño lógico y diseño físico.

---

📌 1. Requisitos y Análisis 

El primer paso fue identificar los requisitos funcionales y no funcionales del sistema, así como los principales actores y entidades del negocio.

<details>
<summary>📷 Ver imagen del caso Netflix (haz clic para desplegar)</summary>

![Requisitos - Task Netflix](https://raw.githubusercontent.com/DiegoRoyGulytMamaniChura/Notes-DB/main/task_netflix.PNG)

*Figura 1: Caso Netflix*

</details>

---

    
## 🧠 2. Diseño Conceptual

En esta fase se representaron las entidades, atributos y relaciones mediante un modelo **Entidad-Relación (E-R)**. También se aplicó la **normalización** para evitar redundancias. Puedes usar páginas como **dbdiagram.io** o **Draw.io**.

### 📌 Elementos del diseño conceptual:

- Modelo Entidad-Relación (E-R)
- Reglas de negocio
- Normalización hasta 3FN
- Identificación de claves primarias y foráneas
  
<details>
<summary>📷 Ver imagen del diseño conceptual (haz clic para desplegar)</summary>
    
![Diseño Conceptual](https://raw.githubusercontent.com/DiegoRoyGulytMamaniChura/Notes-DB/main/conceptual_design.PNG)
    
*Figura 2: Modelo Entidad-Relación del caso Netflix (draw.io)*

</details>

---

## 🧮 3. Diseño Lógico

En esta etapa se transformó el modelo conceptual a un modelo relacional, definiendo tablas, tipos de datos, claves primarias y foráneas.

<details>
<summary>📷 Ver imagen del diseño lógico (haz clic para desplegar)</summary>  
    
![Diseño Lógico](https://raw.githubusercontent.com/DiegoRoyGulytMamaniChura/Notes-DB/main/logical_design.PNG)

*Figura 3: Modelo Entidad-Relación del caso Netflix (MySQL Workbench)*

</details>

---

## 🧾 4. Diseño Físico

> 📌 En esta sección se incluirá el script SQL completo con la creación de tablas, constraints, inserciones de datos y relaciones. *(Próximamente)*

Puedes ver el script SQL completo de creación de tablas y relaciones en el archivo [`schema.sql`](https://github.com/DiegoRoyGulytMamaniChura/Notes-DB/blob/main/scripts/schema.sql), ubicado en la carpeta `scripts/` del repositorio.


---

## 📚 Contenido Relacionado

- `conceptual_design.PNG`: Modelo E-R
- `logical_design.PNG`: Modelo relacional
- `task_netflix.PNG`: Requisitos del sistema

---

## 🧑‍💻 Autor

**DrMach**  
Estudiante e interesado en bases de datos, análisis de datos y modelamiento de sistemas.



## Blocks of code


<details>
<summary>Ver código SQL (haz clic para desplegar)</summary>
    
```
CREATE DATABASE IF NOT EXISTS db_movie_netflix_transact_2;
USE db_movie_netflix_transact_2;

CREATE TABLE Movie (
    id VARCHAR(8),
    movieTitle VARCHAR(100) NOT NULL,
    releaseDate DATE NOT NULL,
    originalLanguage VARCHAR(100),
    link VARCHAR(100),
    CONSTRAINT pk_movie PRIMARY KEY (id)
);

INSERT INTO Movie (id, movieTitle, releaseDate, originalLanguage, link) VALUES
('M00123', 'Inception', '2010-07-16', 'English', 'www.inception.com'),
('M00457', 'Parasite', '2019-05-30', 'Korean', 'www.parasite-movie.com'),
('M00987', 'Amélie', '2001-04-25', 'French', 'www.amelie.com'),
('M00542', 'Spirited Away', '2001-07-20', 'Japanese', 'www.ghibli.jp'),
('M00733', 'The Godfather', '1972-03-24', 'English', 'www.godfather.com');

CREATE TABLE Person (
    id VARCHAR(8),
    name VARCHAR(100) NOT NULL,
    birthday DATE NOT NULL,
    CONSTRAINT pk_person PRIMARY KEY (id)
);

INSERT INTO Person (id, name, birthday) VALUES
('P10001', 'Alice Johnson', '1990-04-12'),
('P10002', 'Bob Smith', '1985-09-23'),
('P10003', 'Clara Mendes', '1992-01-15'),
('P10004', 'David Lee', '1988-06-30'),
('P10005', 'Emma Davis', '1995-03-08');

CREATE TABLE Participant (
    personID VARCHAR(8),
    movieID VARCHAR(8),
    participantRole VARCHAR(30),
    CONSTRAINT pk_participant PRIMARY KEY (personID, movieID),
    CONSTRAINT fk_participant_person FOREIGN KEY (personID) REFERENCES Person(id),
    CONSTRAINT fk_participant_movie FOREIGN KEY (movieID) REFERENCES Movie(id)
);

SELECT * FROM Movie;
SELECT * FROM Person;

INSERT INTO Participant (personID, movieID, participantRole) VALUES
('P10001', 'M00123', 'author'),
('P10002', 'M00457', 'director'),
('P10003', 'M00987', 'author'),
('P10004', 'M00987', 'author'),
('P10005', 'M00987', 'director');

CREATE TABLE Genre (
    id VARCHAR(8),
    name VARCHAR(100) NOT NULL,
    CONSTRAINT pk_genre PRIMARY KEY (id)
);

INSERT INTO Genre (id, name) VALUES
('G001', 'Action'),
('G002', 'Adventure'),
('G003', 'Animation'),
('G004', 'Biography'),
('G005', 'Comedy'),
('G006', 'Crime'),
('G007', 'Documentary'),
('G008', 'Drama'),
('G009', 'Family'),
('G010', 'Fantasy'),
('G011', 'History'),
('G012', 'Horror'),
('G013', 'Musical');

CREATE TABLE Movie_Genre (
    movieID VARCHAR(8),
    genreID VARCHAR(8),
    CONSTRAINT pk_movie_genre PRIMARY KEY (movieID, genreID),
    CONSTRAINT fk_mg_movie FOREIGN KEY (movieID) REFERENCES Movie(id),
    CONSTRAINT fk_mg_genre FOREIGN KEY (genreID) REFERENCES Genre(id)
);

INSERT INTO Movie_Genre (movieID, genreID) VALUES
('M00123', 'G001'), -- Inception - Action
('M00457', 'G008'), -- Parasite - Drama
('M00987', 'G005'), -- Amélie - Comedy
('M00542', 'G003'), -- Spirited Away - Animation
('M00733', 'G006'); -- The Godfather - Crime
```

