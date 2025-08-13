{{ config(enabled=var('ad_reporting__tiktok_ads_enabled', true)) }}

{{
    fivetran_utils.union_data(
        table_identifier='adgroup_history', 
        database_variable='tiktok_ads_database', 
        schema_variable='tiktok_ads_schema', 
        default_database=target.database,
        default_schema='tiktok_ads',
        default_variable='adgroup_history',
        union_schema_variable='tiktok_ads_union_schemas',
        union_database_variable='tiktok_ads_union_databases'
    )
}}