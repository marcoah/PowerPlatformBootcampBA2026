USE geolocalizacion;
GO

--Validaciones
SELECT COUNT(*) AS TotalCustomers FROM Customers;

SELECT COUNT(*) AS WithNullCity 
FROM Customers
WHERE CustomerCity IS NULL
   --OR CustomerProvince IS NULL
   --OR CustomerCountry IS NULL;

--Consulta 1: Obtener la cantidad de clientes por ciudad (Geoespacial)
SELECT 
    CustomerCity,
    COUNT(CustomerID) AS TotalClientes
FROM Customers
GROUP BY CustomerCity
ORDER BY CustomerCity, TotalClientes DESC;

--Consulta 2: Obtener la cantidad de clientes por ciudad (Geoespacial)
SELECT 
    ci.CityID,
    ci.CityName,
    COUNT(DISTINCT cu.CustomerID) AS TotalClientes
FROM Cities ci
LEFT JOIN Customers cu ON ci.GeoPolygon.STContains(geography::STGeomFromWKB(cu.GeoLocation.STAsBinary(), cu.GeoLocation.STSrid)) = 1
GROUP BY ci.CityID, ci.CityName
ORDER BY TotalClientes DESC;

-- Consulta 3: Obtener clientes sin ciudad asignada
SELECT 
    COUNT(CustomerID) AS ClientesSinCiudad
FROM Customers cu
WHERE NOT EXISTS (
    SELECT 1 
    FROM Cities ci 
    WHERE ci.GeoPolygon.STContains(
        geography::STGeomFromWKB(cu.GeoLocation.STAsBinary(), cu.GeoLocation.STSrid)
    ) = 1
);

-- Consulta 4: Obtener clientes con ciudad asignada pero sin correspondencia geoespacial
SELECT 
    COUNT(CustomerID) AS ClientesConCiudadSinCorrespondencia
FROM Customers cu
WHERE cu.CustomerCity IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 
    FROM Cities ci 
    WHERE ci.GeoPolygon.STContains(
        geography::STGeomFromWKB(cu.GeoLocation.STAsBinary(), cu.GeoLocation.STSrid)
    ) = 1
  );