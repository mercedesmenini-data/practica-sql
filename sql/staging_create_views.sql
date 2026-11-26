-- ============================================================
-- Capa staging: vistas limpias sobre las tablas de raw
-- Proyecto: ae-lab-mercedes
-- Orden de ejecución: cualquiera (las vistas no dependen entre sí)
-- ============================================================


-- ------------------------------------------------------------
-- stg_orders
-- - Deja una sola fila por pedido (la versión más reciente según updated_at)
-- - Normaliza el estado a minúsculas
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW `ae-lab-mercedes.staging.stg_orders` AS
SELECT
  order_id,
  customer_id,
  SAFE_CAST(order_ts AS TIMESTAMP)   AS ordered_at,
  LOWER(TRIM(status))                AS status,
  shipping_cost,
  SAFE_CAST(updated_at AS TIMESTAMP) AS updated_at
FROM `ae-lab-mercedes.raw.orders`
WHERE TRUE
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY order_id
  ORDER BY SAFE_CAST(updated_at AS TIMESTAMP) DESC
) = 1;


-- ------------------------------------------------------------
-- stg_customers
-- - Limpia espacios y pasa el email a minúsculas (vacío -> NULL)
-- - Unifica el país en un código (AR, UY, CL, MX, CO)
-- - Elimina clientes duplicados por email (se queda con el customer_id más bajo)
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW `ae-lab-mercedes.staging.stg_customers` AS
SELECT
  customer_id,
  TRIM(first_name) AS first_name,
  TRIM(last_name)  AS last_name,
  NULLIF(LOWER(TRIM(email)), '') AS email,
  CASE LOWER(TRIM(country))
    WHEN 'ar' THEN 'AR' WHEN 'argentina' THEN 'AR'
    WHEN 'uy' THEN 'UY' WHEN 'uruguay'   THEN 'UY'
    WHEN 'cl' THEN 'CL' WHEN 'chile'     THEN 'CL'
    WHEN 'mx' THEN 'MX' WHEN 'méxico'    THEN 'MX'
    WHEN 'co' THEN 'CO' WHEN 'colombia'  THEN 'CO'
  END AS country_code,
  city,
  SAFE_CAST(created_at AS TIMESTAMP) AS created_at
FROM `ae-lab-mercedes.raw.customers`
WHERE TRUE
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY COALESCE(NULLIF(LOWER(TRIM(email)), ''), CAST(customer_id AS STRING))
  ORDER BY customer_id
) = 1;


-- ------------------------------------------------------------
-- stg_products
-- - Categoría con formato título (Electrónica, Hogar...)
-- - Precio y costo como NUMERIC; unit_cost vacío queda NULL
-- - is_active como booleano
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW `ae-lab-mercedes.staging.stg_products` AS
SELECT
  product_id,
  TRIM(product_name)                    AS product_name,
  INITCAP(LOWER(TRIM(category)))        AS category,
  TRIM(subcategory)                     AS subcategory,
  SAFE_CAST(list_price AS NUMERIC)      AS list_price,
  SAFE_CAST(unit_cost AS NUMERIC)       AS unit_cost,
  SAFE_CAST(is_active AS BOOL)          AS is_active
FROM `ae-lab-mercedes.raw.products`;


-- ------------------------------------------------------------
-- stg_order_items
-- - Agrega line_total = cantidad * precio * (1 - descuento), redondeado a 2 decimales
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW `ae-lab-mercedes.staging.stg_order_items` AS
SELECT
  order_item_id,
  order_id,
  product_id,
  quantity,
  SAFE_CAST(unit_price AS NUMERIC)     AS unit_price,
  discount_pct,
  ROUND(quantity * unit_price * (1 - discount_pct), 2) AS line_total
FROM `ae-lab-mercedes.raw.order_items`;


-- ------------------------------------------------------------
-- stg_payments
-- - Unifica el método de pago (Credit Card -> credit_card)
-- - Convierte amount_cents (centavos) a unidades
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW `ae-lab-mercedes.staging.stg_payments` AS
SELECT
  payment_id,
  order_id,
  LOWER(REPLACE(TRIM(payment_method), ' ', '_')) AS payment_method,
  SAFE_DIVIDE(amount_cents, 100)                 AS amount,
  SAFE_CAST(paid_at AS TIMESTAMP)                AS paid_at
FROM `ae-lab-mercedes.raw.payments`;
