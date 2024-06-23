{{ config(materialized='external', location='../data/mart/expenditures_by_month.parquet', format='parquet') }}

WITH output AS (
    SELECT 
        expenditure_year,
        expenditure_month,
        ROUND(SUM(expenditure_amount)/1000000,2) AS total_expenditures
    FROM {{ ref("stg_expenditures")}}
    WHERE expenditure_year=2022
    GROUP BY ALL
)
SELECT * FROM output