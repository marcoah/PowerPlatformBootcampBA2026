-- Distancia entre dos puntos (en metros)
DECLARE @p1 geography = geography::Point(-34.603722, -58.381592, 4326); -- Obelisco
DECLARE @p2 geography = geography::Point(-34.608418, -58.373161, 4326); -- Plaza de Mayo

SELECT @p1.STDistance(@p2) AS DistanciaEnMetros;

-- Crear un buffer (zona de cobertura)
-- Ejemplo: radio de 500 m alrededor de un punto.

DECLARE @p3 geography = geography::Point(-34.603722, -58.381592, 4326);

SELECT @p3.STBuffer(500) AS Zona;

-- Saber si un punto cae dentro de un pol�gono
DECLARE @poligono geography = geography::STGeomFromText(
    'POLYGON((
        -58.39 -34.60,
        -58.37 -34.60,
        -58.37 -34.61,
        -58.39 -34.61,
        -58.39 -34.60
    ))', 4326
);

DECLARE @pto geography = geography::Point(-34.605, -58.38, 4326);

SELECT @poligono.STContains(@pto) AS EstaDentro;

-- Intersección entre dos pol�gonos

DECLARE @a geography = geography::STGeomFromText(
    'POLYGON((0 0, 0 1, 1 1, 1 0, 0 0))', 4326
);

DECLARE @b geography = geography::STGeomFromText(
    'POLYGON((0.5 0.5, 0.5 1.5, 1.5 1.5, 1.5 0.5, 0.5 0.5))', 4326
);

SELECT @a.STIntersection(@b) AS AreaIntersectada;


-- Calcular el �rea de un pol�gono (m�)
DECLARE @poly geography = geography::STGeomFromText(
    'POLYGON((
        -58.39 -34.60,
        -58.37 -34.60,
        -58.37 -34.61,
        -58.39 -34.61,
        -58.39 -34.60
    ))', 4326
);

SELECT @poly.STArea() AS AreaMetros2;

-- Uni�n de dos geograf�as (STUnion)

DECLARE @aa geography = geography::Point(-34.60, -58.38, 4326).STBuffer(300);
DECLARE @bb geography = geography::Point(-34.61, -58.38, 4326).STBuffer(300);

SELECT @aa.STUnion(@bb) AS UnionGeografica;


-- L�nea entre dos puntos + longitud

DECLARE @linea geography = geography::STGeomFromText(
    'LINESTRING(
        -58.38 -34.60,
        -58.39 -34.61
    )', 4326
);

SELECT
    @linea AS Linea,
    @linea.STLength() AS LongitudEnMetros;
