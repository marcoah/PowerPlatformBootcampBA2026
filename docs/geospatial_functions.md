# Funciones Geográficas en Microsoft SQL Server 2025

## Tipo de Datos: GEOGRAPHY y GEOMETRY

| Función                | Descripción                                                               |
| ---------------------- | ------------------------------------------------------------------------- |
| `STGeomFromText()`     | Crea una geometría a partir de una representación Well-Known Text (WKT)   |
| `STGeomFromWKB()`      | Crea una geometría a partir de una representación Well-Known Binary (WKB) |
| `STPointFromText()`    | Crea un punto a partir de texto WKT                                       |
| `STLineFromText()`     | Crea una línea a partir de texto WKT                                      |
| `STPolyFromText()`     | Crea un polígono a partir de texto WKT                                    |
| `STGeomCollFromText()` | Crea una colección de geometrías a partir de texto WKT                    |
| `Parse()`              | Convierte una cadena WKT en un objeto geography o geometry                |
| `Point()`              | Crea un punto geography a partir de latitud, longitud y SRID              |

## Métodos de Análisis Espacial

| Función          | Descripción                                                  |
| ---------------- | ------------------------------------------------------------ |
| `STContains()`   | Determina si una geometría contiene completamente a otra     |
| `STIntersects()` | Determina si dos geometrías se intersectan                   |
| `STOverlaps()`   | Determina si dos geometrías se superponen                    |
| `STTouches()`    | Determina si dos geometrías se tocan en sus bordes           |
| `STWithin()`     | Determina si una geometría está completamente dentro de otra |
| `STCrosses()`    | Determina si dos geometrías se cruzan                        |
| `STDisjoint()`   | Determina si dos geometrías no tienen puntos en común        |
| `STEquals()`     | Determina si dos geometrías son espacialmente iguales        |
| `STRelate()`     | Evalúa la relación espacial usando el modelo DE-9IM          |

## Métodos de Medición

| Función         | Descripción                                                 |
| --------------- | ----------------------------------------------------------- |
| `STDistance()`  | Calcula la distancia más corta entre dos geometrías         |
| `STLength()`    | Calcula la longitud de una línea o perímetro de un polígono |
| `STArea()`      | Calcula el área de un polígono                              |
| `STPerimeter()` | Calcula el perímetro de un polígono (solo geometry)         |

## Métodos de Información

| Función             | Descripción                                                          |
| ------------------- | -------------------------------------------------------------------- |
| `STGeometryType()`  | Devuelve el tipo de geometría (Point, LineString, Polygon, etc.)     |
| `STDimension()`     | Devuelve la dimensión de la geometría (0=punto, 1=línea, 2=polígono) |
| `STNumPoints()`     | Devuelve el número de puntos en la geometría                         |
| `STNumGeometries()` | Devuelve el número de geometrías en una colección                    |
| `STGeometryN()`     | Devuelve una geometría específica de una colección                   |
| `STPointN()`        | Devuelve un punto específico de una línea                            |
| `STStartPoint()`    | Devuelve el primer punto de una línea                                |
| `STEndPoint()`      | Devuelve el último punto de una línea                                |
| `STIsClosed()`      | Determina si el inicio y fin de una línea coinciden                  |
| `STIsRing()`        | Determina si una línea es cerrada y simple                           |
| `STIsEmpty()`       | Determina si una geometría está vacía                                |
| `STIsSimple()`      | Determina si una geometría es simple (sin auto-intersecciones)       |
| `STIsValid()`       | Determina si una geometría es válida según OGC                       |
| `STSrid()`          | Devuelve el identificador del sistema de referencia espacial         |

## Métodos de Transformación

| Función                 | Descripción                                                   |
| ----------------------- | ------------------------------------------------------------- |
| `STBuffer()`            | Crea un área de influencia alrededor de una geometría         |
| `STConvexHull()`        | Devuelve el polígono convexo mínimo que contiene la geometría |
| `STIntersection()`      | Devuelve la intersección entre dos geometrías                 |
| `STUnion()`             | Devuelve la unión de dos geometrías                           |
| `STDifference()`        | Devuelve la diferencia entre dos geometrías                   |
| `STSymDifference()`     | Devuelve la diferencia simétrica entre dos geometrías         |
| `Reduce()`              | Simplifica una geometría usando el algoritmo Douglas-Peucker  |
| `STEnvelope()`          | Devuelve el rectángulo delimitador mínimo                     |
| `BufferWithTolerance()` | Crea un buffer con tolerancia especificada                    |

## Métodos de Componentes

| Función               | Descripción                                             |
| --------------------- | ------------------------------------------------------- |
| `STCentroid()`        | Devuelve el centroide geométrico de un polígono         |
| `STPointOnSurface()`  | Devuelve un punto garantizado dentro de un polígono     |
| `STBoundary()`        | Devuelve el límite de una geometría                     |
| `STExteriorRing()`    | Devuelve el anillo exterior de un polígono              |
| `STInteriorRingN()`   | Devuelve un anillo interior específico de un polígono   |
| `STNumInteriorRing()` | Devuelve el número de anillos interiores en un polígono |

## Métodos de Conversión

| Función        | Descripción                                                   |
| -------------- | ------------------------------------------------------------- |
| `STAsText()`   | Convierte una geometría a formato Well-Known Text (WKT)       |
| `STAsBinary()` | Convierte una geometría a formato Well-Known Binary (WKB)     |
| `ToString()`   | Devuelve una representación en texto de la geometría          |
| `AsTextZM()`   | Convierte geometría a WKT incluyendo valores Z y M            |
| `AsGml()`      | Convierte geometría a formato GML (Geography Markup Language) |

## Métodos de Validación y Corrección

| Función             | Descripción                                                               |
| ------------------- | ------------------------------------------------------------------------- |
| `IsValidDetailed()` | Proporciona información detallada sobre por qué una geometría es inválida |
| `MakeValid()`       | Intenta corregir una geometría inválida                                   |
| `ReorientObject()`  | Reorienta los anillos de un polígono según la regla de la mano derecha    |

## Métodos Específicos de GEOGRAPHY

| Función      | Descripción                                                  |
| ------------ | ------------------------------------------------------------ |
| `Lat`        | Devuelve la latitud de un punto geography                    |
| `Long`       | Devuelve la longitud de un punto geography                   |
| `NumRings()` | Devuelve el número total de anillos en un polígono geography |
| `RingN()`    | Devuelve un anillo específico de un polígono geography       |

## Métodos de Coordenadas (GEOMETRY)

| Función | Descripción                                           |
| ------- | ----------------------------------------------------- |
| `STX`   | Devuelve la coordenada X de un punto                  |
| `STY`   | Devuelve la coordenada Y de un punto                  |
| `Z`     | Devuelve el valor Z (elevación) de un punto si existe |
| `M`     | Devuelve el valor M (medida) de un punto si existe    |

## Funciones de Agregación

| Función                 | Descripción                                               |
| ----------------------- | --------------------------------------------------------- |
| `UnionAggregate()`      | Realiza la unión de múltiples geometrías en un GROUP BY   |
| `CollectionAggregate()` | Crea una colección de geometrías en un GROUP BY           |
| `ConvexHullAggregate()` | Calcula el polígono convexo de múltiples geometrías       |
| `EnvelopeAggregate()`   | Calcula el rectángulo delimitador de múltiples geometrías |

## Notas Importantes

- Las funciones `ST*` son métodos de instancia que se invocan sobre objetos geography o geometry
- GEOGRAPHY usa coordenadas de latitud/longitud en una superficie elipsoidal (tierra redonda)
- GEOMETRY usa coordenadas cartesianas en un plano euclidiano
- El SRID (Spatial Reference ID) por defecto para GEOGRAPHY es 4326 (WGS84)
- Siempre valida geometrías con `STIsValid()` antes de operaciones complejas
- Usa `ReorientObject()` para corregir orientación de anillos en polígonos
