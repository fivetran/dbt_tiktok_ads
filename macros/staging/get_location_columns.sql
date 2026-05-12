{% macro get_location_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "advertiser_id", "datatype": dbt.type_int()},
    {"name": "area_type", "datatype": dbt.type_string()},
    {"name": "country_code", "datatype": dbt.type_string()},
    {"name": "parent_id", "datatype": dbt.type_string()},
    {"name": "region_id", "datatype": dbt.type_string()},
    {"name": "region_level", "datatype": dbt.type_string()},
    {"name": "region_name", "datatype": dbt.type_string()},
    {"name": "support_below_18", "datatype": dbt.type_boolean()} 
] %}

{{ return(columns) }}

{% endmacro %} 
