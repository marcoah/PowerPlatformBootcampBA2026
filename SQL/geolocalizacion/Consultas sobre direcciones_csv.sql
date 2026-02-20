USE geolocalizacion;
GO

--ALTER TABLE direcciones_csv
--ALTER COLUMN latitud NUMERIC(14,8);

--ALTER TABLE direcciones_csv
--ALTER COLUMN longitud NUMERIC(14,8);

-- Agregar una nueva columna de tipo GEOGRAPHY
ALTER TABLE direcciones_csv
ADD ubicacion GEOGRAPHY;


-- 2. Poblar la columna con los valores existentes
UPDATE direcciones_csv
SET ubicacion = GEOGRAPHY::Point(latitud, longitud, 4326) WHERE latitud IS NOT NULL AND longitud IS NOT NULL;
-- 4326 = SRID para WGS 84, el sistema de referencia usado por GPS

-- 3. (Opcional) Eliminar las columnas antiguas si ya no las necesitas
-- ALTER TABLE direcciones_csv
-- DROP COLUMN latitud, longitud;

-- Ver puntos en WKT (Well Known Text)
SELECT
    latitud, longitud, ubicacion.ToString() AS ubicacion_wkt
FROM geolocalizacion.dbo.direcciones_csv;

-- Ver puntos en Spatial Results
SELECT
    ubicacion
FROM geolocalizacion.dbo.direcciones_csv
WHERE ubicacion IS NOT NULL;
