{% macro get_ad_group_history_columns() %}

{% set columns = [
    {"name": "action_days", "datatype": dbt.type_numeric()},
    {"name": "adgroup_id", "datatype": dbt.type_numeric()},
    {"name": "adgroup_name", "datatype": dbt.type_string()},
    {"name": "advertiser_id", "datatype": dbt.type_numeric()},
    {"name": "audience_type", "datatype": dbt.type_string()},
    {"name": "budget", "datatype": dbt.type_float()},
    {"name": "campaign_id", "datatype": dbt.type_numeric()},
    {"name": "category", "datatype": dbt.type_numeric()},
    {"name": "display_name", "datatype": dbt.type_string()},
    {"name": "frequency", "datatype": dbt.type_numeric()},
    {"name": "frequency_schedule", "datatype": dbt.type_numeric()},
    {"name": "gender", "datatype": dbt.type_string()},
    {"name": "landing_page_url", "datatype": dbt.type_string()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()},
    {"name": "interest_category_v_2", "datatype": dbt.type_string()},
    {"name": "action_categories", "datatype": dbt.type_string()},
    {"name": "age_groups", "datatype": dbt.type_string()},
    {"name": "languages", "datatype": dbt.type_string()}

] %}

{{ return(columns) }}

{% endmacro %}