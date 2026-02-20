import pandas as pd
from pathlib import Path
from geopy.geocoders import Nominatim
from geopy.extra.rate_limiter import RateLimiter


def geocodificar_clientes():
    # Rutas relativas al archivo actual
    # base_dir = Path(__file__).resolve().parent
    # input_csv = base_dir.parent / "data" / "clientes_direcciones.csv"
    # output_csv = base_dir / "clientes_georeferenciados.csv"

    base_dir = Path(r"C:\data")
    input_csv = base_dir / "clientes_direcciones.csv"
    output_csv = base_dir / "clientes_georeferenciados.csv"

    # Leer CSV
    df = pd.read_csv(input_csv)

    if "Direccion" not in df.columns:
        raise ValueError("La columna 'Direccion' no existe en el CSV")

    # Nominatim (Con verificacion de timeout y reintentos )
    from geopy.exc import GeocoderTimedOut, GeocoderUnavailable

    geolocator = Nominatim(
        user_agent="clientes_geocoder",
        timeout=10  # ⬅️ clave
    )

    geocode = RateLimiter(
        geolocator.geocode,
        min_delay_seconds=1,
        max_retries=3,
        error_wait_seconds=2,
        swallow_exceptions=True
    )

    resultados = []

    for idx, direccion in df["Direccion"].items():
        lat, lon = None, None

        if pd.notna(direccion):
            try:
                location = geocode(direccion)
                if location:
                    lat = location.latitude
                    lon = location.longitude
            except (GeocoderTimedOut, GeocoderUnavailable):
                lat, lon = None, None

        resultados.append({
            "ID": idx + 1,
            "Direccion": direccion,
            "Latitud": lat,
            "Longitud": lon
        })

    # Guardar salida
    pd.DataFrame(resultados).to_csv(output_csv, index=False, encoding="utf-8")

    print(f"✔ Archivo generado: {output_csv}")


if __name__ == "__main__":
    geocodificar_clientes()
