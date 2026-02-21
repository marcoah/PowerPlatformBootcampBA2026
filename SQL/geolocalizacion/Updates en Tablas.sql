USE geolocalizacion;
GO
-- Actualiza la Tabla Customers con la ciudad correspondiente según las coordenadas geográficas

-- Ver cuántos registros se actualizarían
SELECT 
    cu.CustomerID,
    cu.CustomerCity AS CiudadActual,
    ci.CityName AS CiudadNueva,
    cu.GeoLocation.STAsText() AS Coordenadas
FROM Customers cu
INNER JOIN Cities ci ON ci.GeoPolygon.STContains(geography::STGeomFromWKB(cu.GeoLocation.STAsBinary(), cu.GeoLocation.STSrid)) = 1
WHERE cu.CustomerCity != ci.CityName OR cu.CustomerCity IS NULL;

-- Ejecutar el UPDATE
UPDATE cu
SET cu.CustomerCity = ci.CityName
FROM Customers cu
INNER JOIN Cities ci ON ci.GeoPolygon.STContains(geography::STGeomFromWKB(cu.GeoLocation.STAsBinary(), cu.GeoLocation.STSrid)) = 1;

-- Para los registros que no se pudieron actualizar (sin ciudad encontrada), asignar un valor por defecto
UPDATE cu
SET cu.CustomerCity = ISNULL(ci.CityName, 'Ciudad No Registrada')
FROM Customers cu
LEFT JOIN Cities ci 
    ON ci.GeoPolygon.STContains(
        geography::STGeomFromWKB(cu.GeoLocation.STAsBinary(), cu.GeoLocation.STSrid)
    ) = 1;
