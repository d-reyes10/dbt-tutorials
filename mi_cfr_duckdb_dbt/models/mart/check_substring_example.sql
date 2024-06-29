{{ config(materialized='external', location='../data/mart/check_substring_example.parquet', format='parquet') }}

SELECT 
    check_substring('goodbye', 'hello world') AS 'check_substring_check'