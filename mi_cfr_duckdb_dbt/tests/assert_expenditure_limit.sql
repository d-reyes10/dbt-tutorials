SELECT
    1
FROM {{ ref('stg_expenditures')}}
WHERE expenditure_amount < 0