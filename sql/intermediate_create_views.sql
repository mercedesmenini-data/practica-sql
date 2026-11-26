-- Vista 1: cada order con el país de su customer
CREATE OR REPLACE VIEW `ae-lab-mercedes.intermediate.int_orders_with_customer` AS
SELECT
  o.order_id,
  o.customer_id,
  o.ordered_at,
  o.status,
  o.shipping_cost,
  c.country_code
FROM `ae-lab-mercedes.staging.stg_orders` o
LEFT JOIN `ae-lab-mercedes.staging.stg_customers` c
  ON o.customer_id = c.customer_id;

-- Vista 2: cada línea de compra con el nombre y la category de su producto
CREATE OR REPLACE VIEW `ae-lab-mercedes.intermediate.int_order_items_with_product` AS
SELECT
  oi.order_item_id,
  oi.order_id,
  oi.product_id,
  p.product_name,
  p.category,
  oi.quantity,
  oi.unit_price,
  oi.discount_pct,
  oi.line_total
FROM `ae-lab-mercedes.staging.stg_order_items` oi
LEFT JOIN `ae-lab-mercedes.staging.stg_products` p
  ON oi.product_id = p.product_id;
