# NYC Taxi Trip Records — Análisis de Movilidad Urbana
**Curso:** Procesamiento de Datos Masivos en la Nube  
**Universidad:** ULACIT  
**Integrantes:** Gabriel Miranda · Jhon Wright  
**Año:** 2026

## Descripción
Análisis de 11.6 millones de viajes de taxis amarillos de Nueva York 
(Octubre, Noviembre y Diciembre 2025) usando Google Cloud Platform.

## Arquitectura
- **Ingesta:** Kaggle API + NYC TLC Open Data
- **Almacenamiento:** Google Cloud Storage (raw / processed / results)
- **Procesamiento:** BigQuery SQL
- **Base de datos:** BigQuery (taxi_analysis)
- **Visualización:** Google Colab + Matplotlib + Seaborn

## Preguntas Analíticas
1. ¿Cuáles son las horas del día con mayor demanda de taxis?
2. ¿Qué zonas de recogida concentran mayor número de viajes?
3. ¿Cuál es la relación entre distancia del viaje y propina promedio?

## Resultados
| Métrica | Valor |
|---|---|
| Registros procesados | 11,599,258 |
| Meses analizados | Oct, Nov, Dic 2025 |
| Tablas generadas | 7 |
| Gráficas producidas | 3 |

## Archivos
- `NYC_Taxi_Visualizaciones.ipynb` — Notebook con análisis y gráficas
- `grafica_demanda_hora.png` — Viajes por hora del día
- `grafica_top_zonas.png` — Top 10 zonas de recogida
- `grafica_propina_dist.png` — Propina promedio por distancia

## Dataset
- **Fuente:** NYC Taxi & Limousine Commission
- **Link:** https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page
- **Formato:** Parquet
- **Tamaño:** ~220 MB (3 meses)
