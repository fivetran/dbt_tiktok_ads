{% macro get_campaign_report_hourly_columns() %}

{% set columns = [
    {"name": "campaign_id", "datatype": dbt.type_numeric()},
    {"name": "average_video_play", "datatype": dbt.type_float()},
    {"name": "average_video_play_per_user", "datatype": dbt.type_float()},
    {"name": "clicks", "datatype": dbt.type_numeric()},
    {"name": "comments", "datatype": dbt.type_numeric()},
    {"name": "conversion", "datatype": dbt.type_int()},
    {"name": "conversion_rate", "datatype": dbt.type_float()},
    {"name": "cost_per_conversion", "datatype": dbt.type_float()},
    {"name": "cpc", "datatype": dbt.type_float()},
    {"name": "cpm", "datatype": dbt.type_float()},
    {"name": "ctr", "datatype": dbt.type_float()},
    {"name": "follows", "datatype": dbt.type_numeric()},
    {"name": "impressions", "datatype": dbt.type_numeric()},
    {"name": "likes", "datatype": dbt.type_numeric()},
    {"name": "profile_visits", "datatype": dbt.type_numeric()},
    {"name": "reach", "datatype": dbt.type_numeric()},
    {"name": "real_time_conversion", "datatype": dbt.type_int()},
    {"name": "shares", "datatype": dbt.type_numeric()},
    {"name": "spend", "datatype": dbt.type_numeric()},
    {"name": "stat_time_hour", "datatype": dbt.type_timestamp()},
    {"name": "total_purchase_value", "datatype": dbt.type_numeric()},
    {"name": "total_sales_lead_value", "datatype": dbt.type_numeric()},
    {"name": "video_play_actions", "datatype": dbt.type_numeric()},
    {"name": "video_views_p_25", "datatype": dbt.type_numeric()},
    {"name": "video_views_p_50", "datatype": dbt.type_numeric()},
    {"name": "video_views_p_75", "datatype": dbt.type_numeric()},
    {"name": "video_watched_2_s", "datatype": dbt.type_numeric()},
    {"name": "video_watched_6_s", "datatype": dbt.type_numeric()}
] %}

{# Doing it this way in case users were bringing in conversion metrics via passthrough columns prior to us adding them by default #}
{{ tiktok_ads_add_pass_through_columns(base_columns=columns, pass_through_fields=var('tiktok_ads__campaign_hourly_passthrough_metrics'), except_fields=["real_time_conversion", "total_purchase_value", "total_sales_lead_value"]) }}

{{ return(columns) }}

{% endmacro %}
