import pandas as pd
from pathlib import Path
from geopy.geocoders import Nominatim
from geopy.extra.rate_limiter import RateLimiter
from geopy.exc import GeocoderTimedOut, GeocoderUnavailable


def geocodificar_clientes_v2():
    # base_dir = Path(__file__).resolve().parent
    # input_csv = base_dir.parent / "data" / "clientes_direcciones.csv"
    # output_csv = base_dir / "clientes_georeferenciados.csv"

    base_dir = Path(r"C:\data")
    input_csv = base_dir / "clientes_direcciones.csv"
    output_csv = base_dir / "clientes_georeferenciados.csv"

    # Nominatim bien alimentado
    geolocator = Nominatim(
        user_agent="clientes_geocoder",
        timeout=10
    )

    geocode = RateLimiter(
        geolocator.geocode,
        min_delay_seconds=1,
        max_retries=3,
        error_wait_seconds=2,
        swallow_exceptions=True
    )

    # ─────────────────────────────────────────────
    # MODO REPROCESO
    # ─────────────────────────────────────────────
    if output_csv.exists():
        df = pd.read_csv(output_csv)

        pendientes = df[
            df["Latitud"].isna() | df["Longitud"].isna()
        ]

        print(f"🔁 Reprocesando {len(pendientes)} direcciones pendientes")

    else:
        df_input = pd.read_csv(input_csv)

        if "Direccion" not in df_input.columns:
            raise ValueError("La columna 'Direccion' no existe en el CSV")

        df = pd.DataFrame({
            "ID": range(1, len(df_input) + 1),
            "Direccion": df_input["Direccion"],
            "Latitud": None,
            "Longitud": None
        })

        pendientes = df.copy()
        print(f"🆕 Procesando {len(pendientes)} direcciones")

    # ─────────────────────────────────────────────
    # GEOCODIFICACIÓN SELECTIVA
    # ─────────────────────────────────────────────
    for idx, row in pendientes.iterrows():
        direccion = row["Direccion"]

        try:
            location = geocode(direccion)
            if location:
                df.at[idx, "Latitud"] = location.latitude
                df.at[idx, "Longitud"] = location.longitude
                print(f"✔ {direccion}")
            else:
                print(f"✖ No encontrada: {direccion}")

        except (GeocoderTimedOut, GeocoderUnavailable):
            print(f"⏱ Timeout: {direccion}")

    # Guardar resultados
    df.to_csv(output_csv, index=False, encoding="utf-8")
    print(f"\n✅ Archivo actualizado: {output_csv}")


if __name__ == "__main__":
    geocodificar_clientes_v2()
