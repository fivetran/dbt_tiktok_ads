{# Unnests the `landing_page_url_list` JSON array (one Smart+ ad can have multiple landing pages) into one row per URL.
Adapted from the equivalent JSON-array-unnesting pattern in dbt_facebook_ads' `get_url_tags_query` macro. #}

{% macro tiktok_ads_get_landing_page_urls_query(output_cte_name) %}
    {{ return(adapter.dispatch('tiktok_ads_get_landing_page_urls_query', 'tiktok_ads')(output_cte_name)) }}
{% endmacro %}

{% macro default__tiktok_ads_get_landing_page_urls_query(output_cte_name) %}
{# bigquery #}
    {{ output_cte_name }} as (
        select
            source_relation,
            smart_plus_ad_id,
            json_extract_scalar(url_element, '$') as landing_page_url
        from required_fields,
            unnest(json_extract_array(landing_page_url_list)) as url_element
    )
{% endmacro %}

{% macro postgres__tiktok_ads_get_landing_page_urls_query(output_cte_name) %}
    {{ output_cte_name }} as (
        select
            source_relation,
            smart_plus_ad_id,
            trim(both '"' from url_element::text) as landing_page_url
        from required_fields
        cross join lateral json_array_elements(landing_page_url_list::json) as url_element
    )
{% endmacro %}

{% macro redshift__tiktok_ads_get_landing_page_urls_query(output_cte_name) %}
    parsed_landing_page_urls as (
        select
            source_relation,
            smart_plus_ad_id,
            json_parse(landing_page_url_list) as parsed_landing_page_url_list
        from required_fields
    ),

    {{ output_cte_name }} as (
        select
            p.source_relation,
            p.smart_plus_ad_id,
            url_element::varchar as landing_page_url
        from parsed_landing_page_urls as p, p.parsed_landing_page_url_list as url_element
    )
{% endmacro %}

{% macro snowflake__tiktok_ads_get_landing_page_urls_query(output_cte_name) %}
    {{ output_cte_name }} as (
        select
            source_relation,
            smart_plus_ad_id,
            url_element.value::string as landing_page_url
        from required_fields,
            lateral flatten(input => parse_json(landing_page_url_list)) as url_element
    )
{% endmacro %}

{% macro spark__tiktok_ads_get_landing_page_urls_query(output_cte_name) %}
{# databricks and spark #}
    {{ output_cte_name }} as (
        select
            source_relation,
            smart_plus_ad_id,
            landing_page_url
        from required_fields
        lateral view explode(from_json(landing_page_url_list, 'array<string>')) as landing_page_url
    )
{% endmacro %}

{% macro duckdb__tiktok_ads_get_landing_page_urls_query(output_cte_name) %}
    {{ output_cte_name }} as (
        select
            source_relation,
            smart_plus_ad_id,
            unnest(from_json(landing_page_url_list, '["VARCHAR"]')) as landing_page_url
        from required_fields
    )
{% endmacro %}
