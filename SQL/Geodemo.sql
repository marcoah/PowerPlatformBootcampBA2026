CREATE DATABASE GeoDemo;
GO
USE GeoDemo;
GO

CREATE TABLE Ciudad (
    Id INT IDENTITY PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Ubicacion GEOGRAPHY NOT NULL
);

CREATE TABLE Zona (
    Id INT IDENTITY PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Area GEOGRAPHY NOT NULL
);

CREATE TABLE Ruta (
    Id INT IDENTITY PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Trayecto GEOGRAPHY NOT NULL
);

CREATE TABLE PuntoDeInteres (
    Id INT IDENTITY PRIMARY KEY,
    Nombre VARCHAR(150) NOT NULL,
    Categoria VARCHAR(50) NOT NULL,
    Ubicacion GEOGRAPHY NOT NULL
);

CREATE TABLE Cobertura (
    Id INT IDENTITY PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Centro GEOGRAPHY NOT NULL,
    Radio INT NOT NULL, -- metros
    Area GEOGRAPHY NOT NULL
);

INSERT INTO Ciudad (Nombre, Ubicacion)
VALUES
('Buenos Aires', geography::Point(-34.603722, -58.381592, 4326)),
('Cordoba',       geography::Point(-31.420083, -64.188776, 4326)),
('Rosario',       geography::Point(-32.944243, -60.650539, 4326));

INSERT INTO Zona (Nombre, Area)
VALUES
('Zona Centro BA',
 geography::STGeomFromText('POLYGON((
    -58.385 -34.595,
    -58.365 -34.595,
    -58.365 -34.605,
    -58.385 -34.605,
    -58.385 -34.595
 ))', 4326));

 INSERT INTO Ruta (Nombre, Trayecto)
VALUES
('Recorrido Rio de la Plata',
 geography::STGeomFromText('LINESTRING(
    -58.381592 -34.603722,
    -58.373161 -34.608418
 )', 4326));

 INSERT INTO PuntoDeInteres (Nombre, Categoria, Ubicacion)
VALUES
('Obelisco', 'Turismo', geography::Point(-34.603722, -58.381592, 4326)),
('Casa Rosada', 'Gobierno', geography::Point(-34.608418, -58.373161, 4326)),
('Teatro Colon', 'Cultura', geography::Point(-34.601938, -58.383244, 4326));

INSERT INTO Cobertura (Nombre, Centro, Radio, Area)
VALUES
('Cobertura Obelisco', 
 geography::Point(-34.603722, -58.381592, 4326),
 500,
 geography::Point(-34.603722, -58.381592, 4326).STBuffer(500));

-- Consultas tipicas para GIS
-- ¿Qué POIs estan dentro de la zona?
SELECT p.Nombre
FROM PuntoDeInteres p
JOIN Zona z ON z.Id = 1
WHERE z.Area.STContains(p.Ubicacion) = 1;

-- ¿Qué ciudades están a menos de 300 km de Buenos Aires?
DECLARE @ba GEOGRAPHY = (SELECT Ubicacion FROM Ciudad WHERE Nombre = 'Buenos Aires');

SELECT Nombre, Ubicacion.STDistance(@ba)/1000 AS DistanciaKm
FROM Ciudad
WHERE Ubicacion.STDistance(@ba) <= 300000;

-- ¿Qué POIs caen en la cobertura del Obelisco?
SELECT p.Nombre
FROM PuntoDeInteres p
JOIN Cobertura c ON c.Id = 1
WHERE c.Area.STIntersects(p.Ubicacion) = 1;

-- Rutas que cruzan zonas
SELECT r.Nombre
FROM Ruta r
JOIN Zona z ON z.Id = 1
WHERE r.Trayecto.STIntersects(z.Area) = 1;