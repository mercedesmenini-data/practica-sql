-- ============================================================
-- Nivel 1: chequeos básicos sobre la capa staging
-- Proyecto: ae-lab-mercedes
-- ============================================================


-- ------------------------------------------------------------
-- Ejercicio 1: pagos por método de pago
-- Esperado: 4 filas (credit_card, debit_card, mercadopago, transfer)
-- ------------------------------------------------------------
SELECT
  payment_method,
  COUNT(*) AS pagos
FROM `ae-lab-mercedes.staging.stg_payments`
GROUP BY payment_method
ORDER BY pagos DESC;


-- ------------------------------------------------------------
-- Ejercicio 2: productos por categoría
-- Esperado: 4 categorías, todas con la misma grafía
-- ------------------------------------------------------------
SELECT
  category,
  COUNT(*) AS productos
FROM `ae-lab-mercedes.staging.stg_products`
GROUP BY category
ORDER BY productos DESC;


-- ------------------------------------------------------------
-- Ejercicio 3: productos con y sin costo
-- Esperado: ~4 sin costo, ~144 con costo (total 148)
-- ------------------------------------------------------------

-- Versión A: COUNTIF (una fila, una columna por caso)
SELECT
  COUNTIF(unit_cost IS NULL)     AS sin_costo,
  COUNTIF(unit_cost IS NOT NULL) AS con_costo
FROM `ae-lab-mercedes.staging.stg_products`;

-- Versión B: COUNT(*) - COUNT(columna)  (COUNT(columna) ignora los NULL)
SELECT
  COUNT(*) - COUNT(unit_cost) AS sin_costo,
  COUNT(unit_cost)            AS con_costo
FROM `ae-lab-mercedes.staging.stg_products`;

-- Versión C: CASE WHEN etiqueta cada fila y GROUP BY las cuenta (una fila por caso)
SELECT
  CASE
    WHEN unit_cost IS NULL THEN 'sin_costo'
    ELSE 'con_costo'
  END AS estado_costo,
  COUNT(*) AS productos
FROM `ae-lab-mercedes.staging.stg_products`
GROUP BY estado_costo;


-- ------------------------------------------------------------
-- Ejercicio 4: porcentaje de productos activos
-- Esperado: ~75 %
-- ------------------------------------------------------------
SELECT
  COUNTIF(is_active) AS activos,
  COUNT(*)           AS total,
  ROUND(SAFE_DIVIDE(COUNTIF(is_active), COUNT(*)) * 100, 1) AS pct_activos
FROM `ae-lab-mercedes.staging.stg_products`;

-- Desafío extra: porcentaje de productos activos por categoría
SELECT
  category,
  COUNTIF(is_active) AS activos,
  COUNT(*)           AS total,
  ROUND(SAFE_DIVIDE(COUNTIF(is_active), COUNT(*)) * 100, 1) AS pct_activos
FROM `ae-lab-mercedes.staging.stg_products`
GROUP BY category
ORDER BY pct_activos DESC;
