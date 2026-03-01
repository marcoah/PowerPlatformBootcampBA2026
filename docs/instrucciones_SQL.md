# Instrucciones para la Creación de la Base de Datos

## Requisitos Previos

- SQL Server 2019 o superior instalado
- Permisos de administrador en el sistema
- SQL Server Management Studio (SSMS) o Azure Data Studio

## Pasos de Instalación

### 1. Copiar los Archivos de Datos

Copiar todo el contenido de la carpeta `data` a la ubicación `C:\data` en el servidor:

```bash
# Desde la línea de comandos (CMD) con permisos de administrador
xcopy /E /I /Y ".\data" "C:\data"
```

O manualmente:

1. Crear la carpeta `C:\data` si no existe
2. Copiar todos los archivos desde la carpeta `data` del proyecto a `C:\data`

### 2. Ejecutar el Script de Creación

1. Abrir **SQL Server Management Studio (SSMS)** o **Azure Data Studio**
2. Conectarse al servidor SQL Server
3. Abrir el archivo de script ubicado en la carpeta `SQL`
4. Ejecutar el script completo presionando **F5** o haciendo clic en el botón **Ejecutar**

```sql
-- El script se encuentra en:
-- SQL\crear_base_datos.sql
```

### 3. Verificar la Instalación

Una vez ejecutado el script, verificar que la base de datos se haya creado correctamente:

```sql
-- Verificar que la base de datos existe
SELECT name FROM sys.databases WHERE name = 'geolocalizacion';

-- Verificar las tablas creadas
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

-- Verificar que hay datos en las tablas principales
SELECT COUNT(*) AS TotalClientes FROM Customers;
SELECT COUNT(*) AS TotalOrdenes FROM Orders;
SELECT COUNT(*) AS TotalCiudades FROM Cities;
```

## Estructura de Carpetas

```
PowerPlatformBootcampBA2026/
│
├── data/                    # Archivos de datos a copiar
│   ├── datos_salud.csv
│   └── clientes_direcciones.csv
│
└── SQL/                     # Scripts SQL
    ├── consultas/
    │   ├── A. Codigo de prueba.sql
    │   ├── B. Consultas sobre direcciones_csv.sql
    │   ├── C. Consultas sobre customers.sql
    │   ├── D. Consultas de Ventas.sql
    │   ├── E. Consultas sobre ciudades.sql
    │   └── F. Updates en Tablas.sql
    ├── estructura/
    │   ├── 0. Crear direcciones.sql
    │   ├── 1. Crear BD geolocalizacion.sql
    │   ├── 2. Generar tablas geograficas.sql
    │   ├── 3. Generar estructura.sql
    │   ├── 4. Generar valores.sql
    │   └── 5. Generar vistas.sql
    └── crear_base_datos.sql

```

## Solución de Problemas

### Error: Acceso denegado a C:\data

- Ejecutar el comando `xcopy` como Administrador
- Verificar permisos de escritura en la unidad C:

### Error: No se puede abrir el archivo de datos

- Verificar que los archivos estén en `C:\data`
- Verificar que SQL Server tenga permisos de lectura sobre `C:\data`
- Ejecutar como administrador:

  ```sql
  -- Dar permisos a SQL Server sobre la carpeta
  EXEC xp_cmdshell 'icacls C:\data /grant "NT Service\MSSQLSERVER":(OI)(CI)F /T'
  ```

### Error: La base de datos ya existe

- Eliminar la base de datos existente antes de ejecutar el script:

  ```sql
  DROP DATABASE IF EXISTS NombreBaseDatos;
  ```

### Error en funciones geoespaciales

- Verificar que las extensiones espaciales estén habilitadas
- Para funciones `geography`, no se requiere instalación adicional en SQL Server 2019+

## ⚠️ Problema Común: Orientación de Polígonos

Cuando importas polígonos desde fuentes externas (OpenStreetMap, GeoJSON, etc.), los anillos pueden estar invertidos. En `GEOGRAPHY`, esto causa que el polígono represente "todo el mundo EXCEPTO esa área", haciendo que `STContains()` devuelva `1` para todos los puntos.

### El problema del anillo invertido

En SQL Server (y en el estándar OGC), los polígonos deben seguir reglas estrictas sobre la orientación de sus anillos:

- Anillo exterior: debe ir en sentido antihorario (counter-clockwise)
- Anillos interiores (huecos): deben ir en sentido horario (clockwise)

Si los anillos están invertidos, SQL Server puede rechazar la geometría como inválida, interpretar mal qué es el exterior y qué son huecos y lo peor es que puede causar errores en operaciones espaciales.

### Solución

```sql
-- Reorientar todos los polígonos después de importar
UPDATE Cities
SET GeoPolygon = GeoPolygon.ReorientObject();
```

### Verificar orientación

```sql
-- Si STArea() devuelve un valor muy grande (>50% de la tierra), está invertido
SELECT
    CityName,
    GeoPolygon.STArea() AS Area,
    GeoPolygon.STIsValid() AS EsValido
FROM Cities;
```

## Notas Adicionales

- El script crea automáticamente la base de datos y todas las tablas necesarias
- Los índices espaciales se crean automáticamente para optimizar consultas geoespaciales
- Se recomienda hacer un backup después de la instalación inicial
- La carpeta `C:\data` puede eliminarse después de completar la importación de datos

## Backup Inicial (Recomendado)

Después de crear la base de datos, realizar un backup:

```sql
BACKUP DATABASE geolocalizacion
TO DISK = 'C:\Backups\geolocalizacion_Inicial.bak'
WITH FORMAT,
     MEDIANAME = 'SQLServerBackups',
     NAME = 'Backup inicial de geolocalizacion';
```

## Soporte

Para problemas o consultas adicionales, revisar:

- [Funciones Geoespaciales](funciones_geograficas_sqlserver.md)
- Documentación oficial de SQL Server: [https://docs.microsoft.com/sql-server](https://docs.microsoft.com/sql-server)
