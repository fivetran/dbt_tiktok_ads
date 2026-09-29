{% macro get_creative_history_columns() %}

{% set columns = [
    {"name": "creative_id", "datatype": dbt.type_numeric()},
    {"name": "modify_time", "datatype": dbt.type_timestamp()},
    {"name": "smart_plus_ad_id", "datatype": dbt.type_numeric()},
    {"name": "advertiser_id", "datatype": dbt.type_numeric()},
    {"name": "adgroup_id", "datatype": dbt.type_numeric()},
    {"name": "campaign_id", "datatype": dbt.type_numeric()},
    {"name": "video_id", "datatype": dbt.type_string()},
    {"name": "create_time", "datatype": dbt.type_timestamp()},
    {"name": "creative_name", "datatype": dbt.type_string()},
    {"name": "campaign_name", "datatype": dbt.type_string()},
    {"name": "adgroup_name", "datatype": dbt.type_string()},
    {"name": "identity_id", "datatype": dbt.type_string()},
    {"name": "identity_type", "datatype": dbt.type_string()},
    {"name": "campaign_automation_type", "datatype": dbt.type_string()},
    {"name": "ad_text", "datatype": dbt.type_string()},
    {"name": "secondary_status", "datatype": dbt.type_string()},
    {"name": "operation_status", "datatype": dbt.type_string()},
    {"name": "image_ids", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
