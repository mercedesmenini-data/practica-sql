# practica-sql

Proyecto de práctica de SQL y modelado de datos en **BigQuery**, con un dataset sintético de una tienda online (customers, products, orders, order_items y payments).

El objetivo es practicar SQL para entrevistas y aprender a construir un flujo de datos por capas, como en analytics engineering.

## Capas del modelo

| Capa | Dataset | Qué contiene |
|---|---|---|
| raw | `raw` | Datos tal como llegan, con errores y duplicados (a propósito) |
| staging | `staging` | Vistas `stg_...`: limpieza, tipos y deduplicación |
| intermediate | `intermediate` | Vistas `int_...`: JOINs reutilizables |
| business | `business` | Tablas finales listas para consumir |

## Estructura del repositorio

- `tienda_raw/`: los CSV con los datos de ejemplo.
- `sql/staging_create_views.sql`: vistas de staging.
- `sql/intermediate_create_views.sql`: vistas de intermediate.
- `sql/business_create_tables.sql`: tablas de business (`sales_by_category` y `sales_by_country_month`).
- `sql/nivel_1_chequeos_staging.sql` y `sql/nivel_2_integridad_referencial.sql`: ejercicios de verificación de datos.

## Cómo reproducirlo

1. Crear un proyecto en BigQuery y los datasets `raw`, `staging`, `intermediate` y `business`.
2. Cargar los CSV de `tienda_raw/` en `raw`.
3. Ejecutar en orden: staging, intermediate y business.

## Temas practicados

JOINs (incluyendo anti-joins), agregaciones con `GROUP BY` y `HAVING`, `CASE`, funciones de fecha, CTE, funciones ventana (`ROW_NUMBER`, `LAG`, acumulados) y `QUALIFY`.
