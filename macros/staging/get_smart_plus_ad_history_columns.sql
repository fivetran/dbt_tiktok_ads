{% macro get_smart_plus_ad_history_columns() %}

{% set columns = [
    {"name": "smart_plus_ad_id", "datatype": dbt.type_numeric()},
    {"name": "modify_time", "datatype": dbt.type_timestamp()},
    {"name": "advertiser_id", "datatype": dbt.type_numeric()},
    {"name": "adgroup_id", "datatype": dbt.type_numeric()},
    {"name": "campaign_id", "datatype": dbt.type_numeric()},
    {"name": "create_time", "datatype": dbt.type_timestamp()},
    {"name": "secondary_status", "datatype": dbt.type_string()},
    {"name": "operation_status", "datatype": dbt.type_string()},
    {"name": "ad_name", "datatype": dbt.type_string()},
    {"name": "campaign_name", "datatype": dbt.type_string()},
    {"name": "adgroup_name", "datatype": dbt.type_string()},
    {"name": "landing_page_url_list", "datatype": dbt.type_string()},
    {"name": "tracking_info_click_tracking_url", "datatype": dbt.type_string()},
    {"name": "tracking_info_impression_tracking_url", "datatype": dbt.type_string()},
    {"name": "tracking_info_tracking_app_id", "datatype": dbt.type_string()},
    {"name": "tracking_info_tracking_message_event_set_id", "datatype": dbt.type_string()},
    {"name": "identity_id", "datatype": dbt.type_string()},
    {"name": "identity_type", "datatype": dbt.type_string()},
    {"name": "dark_post_status", "datatype": dbt.type_string()},
    {"name": "product_specific_type", "datatype": dbt.type_string()},
    {"name": "product_set_id", "datatype": dbt.type_string()},
    {"name": "product_ids", "datatype": dbt.type_string()},
    {"name": "creative_auto_add_toggle", "datatype": dbt.type_boolean()},
    {"name": "catalog_creative_toggle", "datatype": dbt.type_boolean()},
    {"name": "end_card_cta", "datatype": dbt.type_string()},
    {"name": "product_display_field_list", "datatype": dbt.type_string()},
    {"name": "auto_disclaimer_types", "datatype": dbt.type_string()},
    {"name": "fallback_type", "datatype": dbt.type_string()},
    {"name": "call_to_action_id", "datatype": dbt.type_string()},
    {"name": "product_info_selling_points", "datatype": dbt.type_string()},
    {"name": "phone_info_phone_region_code", "datatype": dbt.type_string()},
    {"name": "phone_info_phone_region_calling_code", "datatype": dbt.type_string()},
    {"name": "phone_info_phone_number", "datatype": dbt.type_string()},
    {"name": "ad_text_list", "datatype": dbt.type_string()},
    {"name": "auto_message_list", "datatype": dbt.type_string()},
    {"name": "call_to_action_list", "datatype": dbt.type_string()},
    {"name": "interactive_add_on_list", "datatype": dbt.type_string()},
    {"name": "page_list", "datatype": dbt.type_string()},
    {"name": "custom_product_page_list", "datatype": dbt.type_string()},
    {"name": "deeplink_list", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
