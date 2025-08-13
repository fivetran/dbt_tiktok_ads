{{ config(enabled=var('ad_reporting__tiktok_ads_enabled', true)) }}

with base as (

    select *
    from {{ ref('stg_tiktok_ads__ad_group_history_tmp') }}
), 

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_tiktok_ads__ad_group_history_tmp')),
                staging_columns=get_ad_group_history_columns()
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
        adgroup_id as ad_group_id,
        cast(updated_at as {{ dbt.type_timestamp() }}) as updated_at,
        advertiser_id,
        campaign_id,
        action_days,
        action_categories,
        adgroup_name as ad_group_name,
        age_groups,
        audience_type,
        budget,
        category,
        display_name,
        interest_category_v_2 as interest_category,
        frequency,
        frequency_schedule,
        gender,
        languages, 
        landing_page_url,
        row_number() over (partition by source_relation, adgroup_id order by updated_at desc) = 1 as is_most_recent_record
    from fields
)

select * 
from final