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
