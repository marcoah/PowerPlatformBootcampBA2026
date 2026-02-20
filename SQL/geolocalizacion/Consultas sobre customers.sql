USE geolocalizacion;
GO

--Validaciones
SELECT COUNT(*) AS TotalCustomers FROM Customers;

SELECT COUNT(*) AS WithNullCoords 
FROM Customers
WHERE CustomerCity IS NULL
   --OR CustomerProvince IS NULL
   --OR CustomerCountry IS NULL;

--Consulta 1: Obtener la cantidad de clientes por ciudad (Geoespacial)
SELECT 
    CustomerProvince,
    CustomerCity,
    COUNT(CustomerID) AS TotalClientes
FROM Customers
WHERE CustomerCity IS NOT NULL
GROUP BY CustomerProvince, CustomerCity
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