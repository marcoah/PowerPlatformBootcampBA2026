# Geocodificación de direcciones con Nominatim (Python)

Este script permite leer un archivo CSV con direcciones, geocodificarlas usando **Nominatim (OpenStreetMap)** y generar un nuevo CSV con latitud y longitud, respetando la estructura del repositorio.

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

## ⚠️ Consideraciones importantes

- Nominatim **no está pensado para uso productivo intensivo**.
- Para grandes volúmenes:
  - usar un proveedor pago
  - o montar una instancia propia de Nominatim

---

## 📄 Licencia

Uso libre. Mapas felices, desarrolladores también.
