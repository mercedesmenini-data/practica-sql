-- Tabla de negocio 1: unidades y ventas por category
CREATE OR REPLACE TABLE `ae-lab-mercedes.business.sales_by_category` AS
SELECT
  category,
  SUM(quantity) AS units,
  ROUND(SUM(line_total), 2) AS sales
FROM `ae-lab-mercedes.intermediate.int_order_items_with_product`
GROUP BY category;

-- Tabla de negocio 2: orders y ventas por país y mes (solo orders completed con país conocido)
CREATE OR REPLACE TABLE `ae-lab-mercedes.business.sales_by_country_month` AS
SELECT
  c.country_code,
  COUNT(DISTINCT c.order_id) AS orders,
  ROUND(SUM(p.line_total), 2) AS sales,
  DATE_TRUNC(DATE(c.ordered_at), MONTH) AS fecha
FROM `ae-lab-mercedes.intermediate.int_orders_with_customer` c
JOIN `ae-lab-mercedes.intermediate.int_order_items_with_product` p
  ON c.order_id = p.order_id
WHERE c.status = 'completed'
  AND c.country_code IS NOT NULL
GROUP BY c.country_code, DATE_TRUNC(DATE(c.ordered_at), MONTH);
