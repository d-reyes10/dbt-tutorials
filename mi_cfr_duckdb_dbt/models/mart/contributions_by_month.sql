{{ config(materialized='external', location='../data/mart/contributions_by_month.parquet', format='parquet') }}

WITH output AS (
    SELECT 
        donation_received_year,
        donation_received_month,
        ROUND(SUM(contribution_amount)/1000000,2) AS total_contributions
    FROM {{ ref("stg_contributions")}}
    WHERE donation_received_year=2022
    GROUP BY ALL
)
SELECT * FROM output