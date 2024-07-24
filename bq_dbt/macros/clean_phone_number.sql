{% macro clean_phone_number(column_name) %}
nullif(right(regexp_replace(cast({{ column_name }} as string), r'[^0-9]', ''), 10),'')
{% endmacro %}