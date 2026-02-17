SELECT *
FROM dbo.fn_hospitales_por_radio(
    -31.53941,
    -68.52132,
    5000
)
ORDER BY distancia_metros;
