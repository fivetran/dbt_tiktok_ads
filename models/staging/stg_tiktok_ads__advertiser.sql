{{ config(enabled=var('ad_reporting__tiktok_ads_enabled', true)) }}

with base as (

    select *
    from {{ ref('stg_tiktok_ads__advertiser_tmp') }}
), 

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_tiktok_ads__advertiser_tmp')),
                staging_columns=get_advertiser_columns()
            )
        }}

    
        {{ fivetran_utils.source_relation(
            union_schema_variable='tiktok_ads_union_schemas', 
            union_database_variable='tiktok_ads_union_databases') 
        }}

    from base
),

final as (

    select
        source_relation,   
        id as advertiser_id, 
        address, 
        balance, 
        company, 
        contacter, 
        country, 
        currency, 
        description, 
        email, 
        industry, 
        language,
        name as advertiser_name, 
        coalesce(cellphone_number, phone_number) as cellphone_number, 
        coalesce(telephone_number, telephone) as telephone_number,
        timezone
    from fields
)

select *
from final