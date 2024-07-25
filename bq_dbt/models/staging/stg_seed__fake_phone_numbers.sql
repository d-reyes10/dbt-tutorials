select 
    {{clean_phone_number('number')}} as clean_phone_number,
    imei,
    country
from {{ ref('faker')}}
