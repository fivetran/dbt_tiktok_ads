{% macro get_advertiser_columns() %}

{% set columns = [
    {"name": "address", "datatype": dbt.type_string()},
    {"name": "balance", "datatype": dbt.type_float()},
    {"name": "cellphone_number", "datatype": dbt.type_string()},
    {"name": "company", "datatype": dbt.type_string()},
    {"name": "contacter", "datatype": dbt.type_string()},
    {"name": "country", "datatype": dbt.type_string()},
    {"name": "currency", "datatype": dbt.type_string()},
    {"name": "description", "datatype": dbt.type_string()},
    {"name": "email", "datatype": dbt.type_string()},
    {"name": "id", "datatype": dbt.type_numeric()},
    {"name": "industry", "datatype": dbt.type_string()},
    {"name": "language", "datatype": dbt.type_string()},
    {"name": "name", "datatype": dbt.type_string()},
    {"name": "phone_number", "datatype": dbt.type_string()},
    {"name": "telephone", "datatype": dbt.type_string()},
    {"name": "telephone_number", "datatype": dbt.type_string()},
    {"name": "timezone", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}