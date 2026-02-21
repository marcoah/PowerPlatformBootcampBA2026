-- Informacion de ciudades con polígonos geográficos
SELECT 
    ci.CityID,
    ci.CityName,
    ci.GeoPolygon AS PoligonoGrafico,
    ci.GeoPolygon.ToString() AS Poligono,
    ci.GeoPolygon.STArea() AS AreaM2,
    ci.GeoPolygon.STNumPoints() AS TotalPuntos
FROM Cities ci
ORDER BY ci.CityID;

