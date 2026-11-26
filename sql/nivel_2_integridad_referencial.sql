-- Ejercicio 5: pedidos huérfanos
-- Esperado: ~150 (resultado obtenido: 144)
SELECT COUNT(DISTINCT order_id) AS pedidos_huerfanos
FROM `ae-lab-mercedes.staging.stg_orders` o
LEFT JOIN `ae-lab-mercedes.staging.stg_customers` c
  ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Ejercicio 6: pagos sin pedido
-- Esperado: 0
SELECT COUNT(*) AS pagos_sin_pedido
FROM `ae-lab-mercedes.staging.stg_payments` p
LEFT JOIN `ae-lab-mercedes.staging.stg_orders` o
  ON p.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Ejercicio 7: pedidos no cancelados sin pago
-- Esperado: 0 filas
SELECT o.order_id
FROM `ae-lab-mercedes.staging.stg_orders` o
LEFT JOIN `ae-lab-mercedes.staging.stg_payments` p
  ON o.order_id = p.order_id
WHERE o.status != 'cancelled'
  AND p.payment_id IS NULL;

-- Ejercicio 8: customers que nunca hicieron una order
-- Esperado: 2 filas (customer_id 1089 y 2023)
SELECT c.customer_id
FROM `ae-lab-mercedes.staging.stg_customers` c
LEFT JOIN `ae-lab-mercedes.staging.stg_orders` o
  ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL
ORDER BY c.customer_id;
