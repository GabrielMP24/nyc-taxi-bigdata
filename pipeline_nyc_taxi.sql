-- ============================================================
-- PIPELINE NYC YELLOW TAXI 2025
-- Proyecto: nyctaxi-project-494018
-- Dataset: taxi_analysis
-- Bucket: gs://proyecto-taxis-nyc-gamp/
-- ============================================================


-- ============================================================
-- PASO 1: LIMPIEZA Y TRANSFORMACIÓN
-- Une los tres meses, limpia datos inválidos y agrega columnas
-- ============================================================

CREATE OR REPLACE TABLE taxi_analysis.yellow_trips_clean AS
SELECT
  VendorID,
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  passenger_count,
  trip_distance,
  RatecodeID,
  store_and_fwd_flag,
  PULocationID,
  DOLocationID,
  payment_type,
  fare_amount,
  extra,
  mta_tax,
  tip_amount,
  tolls_amount,
  improvement_surcharge,
  total_amount,
  congestion_surcharge,
  Airport_fee,

  -- Columnas calculadas
  TIMESTAMP_DIFF(tpep_dropoff_datetime, tpep_pickup_datetime, MINUTE) AS duracion_minutos,
  EXTRACT(HOUR FROM tpep_pickup_datetime)                             AS pickup_hour,
  DATE(tpep_pickup_datetime)                                          AS pickup_date,
  EXTRACT(DAYOFWEEK FROM tpep_pickup_datetime)                        AS dia_semana,

  -- Método de pago en texto
  CASE
    WHEN payment_type = 1 THEN 'Tarjeta'
    WHEN payment_type = 2 THEN 'Efectivo'
    WHEN payment_type = 3 THEN 'Sin cargo'
    ELSE 'Disputa'
  END AS payment_name,

  -- Clasificación de distancia por rangos
  CASE
    WHEN trip_distance < 2 THEN '0-2 mi'
    WHEN trip_distance < 4 THEN '2-4 mi'
    WHEN trip_distance < 6 THEN '4-6 mi'
    ELSE '6+ mi'
  END AS distance_range

FROM (
  SELECT * FROM taxi_analysis.yellow_trips_oct  UNION ALL
  SELECT * FROM taxi_analysis.yellow_trips_nov  UNION ALL
  SELECT * FROM taxi_analysis.yellow_trips_dic
)

-- Filtros de limpieza: elimina registros inválidos
WHERE trip_distance > 0
  AND fare_amount > 0
  AND total_amount > 0
  AND tpep_pickup_datetime IS NOT NULL
  AND tpep_dropoff_datetime IS NOT NULL
  AND TIMESTAMP_DIFF(tpep_dropoff_datetime, tpep_pickup_datetime, MINUTE) BETWEEN 1 AND 1440;


-- ============================================================
-- VERIFICACIÓN: contar registros limpios
-- ============================================================

SELECT COUNT(*) AS total_registros_limpios
FROM `nyctaxi-project-494018.taxi_analysis.yellow_trips_clean`;


-- ============================================================
-- PASO 2A: AGREGACIÓN — Viajes por hora del día
-- Responde P1: ¿En qué horas hay más demanda de taxis?
-- ============================================================

CREATE OR REPLACE TABLE taxi_analysis.trips_by_hour AS
SELECT
  pickup_hour,
  COUNT(*) AS total_viajes
FROM taxi_analysis.yellow_trips_clean
GROUP BY pickup_hour
ORDER BY pickup_hour;


-- ============================================================
-- PASO 2B: AGREGACIÓN — Top 10 zonas de recogida
-- Responde P2: ¿Qué zonas concentran más viajes?
-- ============================================================

CREATE OR REPLACE TABLE taxi_analysis.trips_by_zone AS
SELECT
  PULocationID,
  COUNT(*) AS total_viajes
FROM taxi_analysis.yellow_trips_clean
GROUP BY PULocationID
ORDER BY total_viajes DESC
LIMIT 10;


-- ============================================================
-- PASO 2C: AGREGACIÓN — Propina promedio por distancia
-- Responde P3: ¿Cómo varía la propina según la distancia?
-- ============================================================

CREATE OR REPLACE TABLE taxi_analysis.tip_by_distance AS
SELECT
  distance_range,
  ROUND(AVG(tip_amount), 2) AS propina_promedio,
  COUNT(*)                  AS total_viajes
FROM taxi_analysis.yellow_trips_clean
GROUP BY distance_range
ORDER BY distance_range;


-- ============================================================
-- CONSULTAS DE VERIFICACIÓN FINAL
-- Ejecutar para confirmar que las tablas se crearon bien
-- ============================================================

-- Verificar trips_by_hour
SELECT * FROM taxi_analysis.trips_by_hour
ORDER BY pickup_hour;

-- Verificar trips_by_zone
SELECT * FROM taxi_analysis.trips_by_zone
ORDER BY total_viajes DESC;

-- Verificar tip_by_distance
SELECT * FROM taxi_analysis.tip_by_distance
ORDER BY distance_range;
