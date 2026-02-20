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
├── SQL/
│   └── *.sql
├── python/
│   ├── geocodificar_clientes.py
│   └── clientes_georeferenciados.csv
└── README.md
```

- **data/**: contiene el CSV original con direcciones sin geocodificar
- **SQL/**: scripts SQL (no usados por este proceso)
- **python/**: código Python y salida geocodificada

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

### Funciones Geo-espaciales

Para ver las funciones geoespaciales puedes ver el documento [Ver funciones](docs/geospatial_functions.md)

### El problema del anillo invertido

En SQL Server (y en el estándar OGC), los polígonos deben seguir reglas estrictas sobre la orientación de sus anillos:

Anillo exterior: debe ir en sentido antihorario (counter-clockwise)
Anillos interiores (huecos): deben ir en sentido horario (clockwise)

Si los anillos están invertidos, SQL Server puede rechazar la geometría como inválida, interpretar mal qué es el exterior y qué son huecos y lo peor
es que puede causar errores en operaciones espaciales.

Solucion:

### Solución

```sql
UPDATE Cities
SET GeoPolygon = GeoPolygon.ReorientObject();
```

## ⚠️ Consideraciones importantes

- Nominatim **no está pensado para uso productivo intensivo**.
- Para grandes volúmenes:
  - usar un proveedor pago
  - o montar una instancia propia de Nominatim

---

## 📄 Licencia

Uso libre. Mapas felices, desarrolladores también.
