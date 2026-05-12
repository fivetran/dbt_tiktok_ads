{{ config(enabled=var('ad_reporting__tiktok_ads_enabled', true) and var('tiktok_ads__using_location', true)) }}

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
