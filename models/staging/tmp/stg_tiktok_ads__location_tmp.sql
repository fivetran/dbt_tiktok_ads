{{ config(enabled=var('ad_reporting__tiktok_ads_enabled', true) and var('tiktok_ads__using_location', true)) }}

{% if var('tiktok_ads_union_schemas', []) | length > 0 or var('tiktok_ads_union_databases', []) | length > 0 %}

{{
    fivetran_utils.union_data(
        table_identifier='location',
        database_variable='tiktok_ads_database',
        schema_variable='tiktok_ads_schema',
        default_database=target.database,
        default_schema='tiktok_ads',
        default_variable='location',
        union_schema_variable='tiktok_ads_union_schemas',
        union_database_variable='tiktok_ads_union_databases'
    )
}}

{% else %}

{{
    fivetran_utils.union_connections(
        connection_dictionary='tiktok_ads_sources',
        single_source_name='tiktok_ads',
        single_table_name='location'
    )
}}

{% endif %}