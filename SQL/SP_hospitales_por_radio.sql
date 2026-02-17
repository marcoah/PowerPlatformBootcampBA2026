CREATE PROCEDURE dbo.sp_hospitales_por_radio
(
    @latitud  FLOAT,
    @longitud FLOAT,
    @radio_m  INT = 5000 -- metros
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @punto geography =
        geography::Point(@latitud, @longitud, 4326);

    SELECT
        h.*,
        h.posicion.STDistance(@punto) AS distancia_metros
    FROM dbo.hospitales h
    WHERE h.posicion IS NOT NULL
        AND h.posicion.STIntersects(
              @punto.STBuffer(@radio_m)
          ) = 1
        AND h.amenity = 'clinic'
    ORDER BY distancia_metros;
END;
GO
