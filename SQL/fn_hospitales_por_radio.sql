CREATE FUNCTION dbo.fn_hospitales_por_radio
(
    @latitud  FLOAT,
    @longitud FLOAT,
    @radio_m  INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        h.*,
        h.posicion.STDistance(
            geography::Point(@latitud, @longitud, 4326)
        ) AS distancia_metros
    FROM dbo.hospitales h
    WHERE h.posicion IS NOT NULL
      AND h.posicion.STIntersects(
            geography::Point(@latitud, @longitud, 4326)
                .STBuffer(@radio_m)
          ) = 1
        AND amenity='clinic'
);
GO