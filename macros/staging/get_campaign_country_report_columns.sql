{% macro get_campaign_country_report_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "campaign_id", "datatype": dbt.type_int()},
    {"name": "clicks", "datatype": dbt.type_int()},
    {"name": "conversion", "datatype": dbt.type_int()},
    {"name": "conversion_rate", "datatype": dbt.type_float()},
    {"name": "cost_per_conversion", "datatype": dbt.type_float()},
    {"name": "country_code", "datatype": dbt.type_string()},
    {"name": "cpc", "datatype": dbt.type_float()},
    {"name": "cpm", "datatype": dbt.type_float()},
    {"name": "ctr", "datatype": dbt.type_float()},
    {"name": "impressions", "datatype": dbt.type_int()},
    {"name": "real_time_conversion", "datatype": dbt.type_int()},
    {"name": "spend", "datatype": dbt.type_float()},
    {"name": "stat_time_day", "datatype": "datetime"}
] %}
{{ tiktok_ads_add_pass_through_columns(base_columns=columns, pass_through_fields=var('tiktok_ads__campaign_country_report_passthrough_metrics')) }}

{{ return(columns) }}

{% endmacro %}