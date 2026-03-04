# Geocodificación de direcciones con Nominatim (Python)

Este script permite leer un archivo CSV con direcciones, geocodificarlas usando **Nominatim (OpenStreetMap)** y generar un nuevo CSV con latitud y longitud, respetando la estructura del repositorio.

En la seccion de SQL Server hay codigo para generar una base de datos llamada geolocalizacion que contiene informacion de ventas para una distribuidora ficticia de productos farmaceuticos que vende directamente a clientes que son hospitales, clinica y farmacias en toda Argentina y con diferentes problemas en el
maestro de Clientes.

---

## 📂 Estructura del repositorio

```text
proyecto/
├── data/
│   └── clientes_direcciones.csv
│   └── datos_salud.csv
├── SQL/
│   └── [Ver instrucciones para SQL Server](docs/instrucciones_SQL.md)
├── python/
│   ├── geocodificar_clientes.py
└── README.md
```

- **data/**: contiene el CSV original con direcciones sin geocodificar y el archivo base para la creacion de BD en SQL Server
- **SQL/**: scripts SQL (no usados por este proceso)
- **python/**: código Python para generar archivo csv georeferenciado

---

## Pasos de Instalación de Archivos de datos

Copiar todo el contenido de la carpeta `data` a la ubicación `C:\data` en el servidor:

```bash
# Desde la línea de comandos (CMD) con permisos de administrador
xcopy /E /I /Y ".\data" "C:\data"
```

O manualmente:

1. Crear la carpeta `C:\data` si no existe
2. Copiar todos los archivos desde la carpeta `data` del proyecto a `C:\data`

---

## 📌 Funcionalidad

El codigo esta dividido en dos secciones: Python y SQL (para MS SQL Server)

## Seccion Python

- Lee `data/clientes_direcciones.csv`
- Usa la columna **Direccion**
- Geocodifica con Nominatim (1 request/segundo)
- Genera `python/clientes_georeferenciados.csv`

Columnas de salida:

- `ID`
- `Direccion`
- `Latitud`
- `Longitud`

Las direcciones que no puedan resolverse quedan con valores `null`.

---

## 🧰 Requisitos

- Python 3.8 o superior
- Dependencias:

```bash
pip install -r requirements.txt
```

---

## ▶️ Ejecución desde la terminal

Desde la raíz del proyecto:

python -m venv venv

```bash
python python/geocodificar_clientes.py
```

Al finalizar se generará:

```text
python/clientes_georeferenciados.csv
```

---

## 🧠 Detalles técnicos

- Se usa un `user_agent` obligatorio para cumplir con las políticas de Nominatim.
- Se aplica **rate limit** para evitar bloqueos.
- El script es tolerante a errores y no se detiene ante direcciones inválidas.

---

## Seccion MS SQL Server

### Instrucciones para crear BD en SQL Server

Para ver las instrucciones especificas para el entorno de SQL Server puedes ver el documento [Ver instrucciones para SQL Server](docs/instrucciones_SQL.md)

### Funciones Geo-espaciales

Para ver las funciones geoespaciales puedes ver el documento [Ver funciones](docs/geospatial_functions.md)

## ⚠️ Consideraciones importantes

- Nominatim **no está pensado para uso productivo intensivo**.
- Para grandes volúmenes:
  - usar un proveedor pago
  - o montar una instancia propia de Nominatim

---

## 📄 Licencia

Uso libre. Mapas felices, desarrolladores también.

---

## Autor

Este repositorio ha sido creado por [Marco Hernandez](https://www.linkedin.com/in/marcoah17/) como parte de la charla **Cómo aprovechar las funciones geográficas de SQL Server en soluciones reales de negocio** para el **POWER PLATFORM BOOTCAMP BUENOS AIRES 2026**.
