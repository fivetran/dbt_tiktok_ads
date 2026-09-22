{{ config(enabled=var('ad_reporting__tiktok_ads_enabled', true) and var('tiktok_ads__using_smart_plus_ads', true)) }}

with base as (

    select *
    from {{ ref('stg_tiktok_ads__creative_history_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_tiktok_ads__creative_history_tmp')),
                staging_columns=get_creative_history_columns()
            )
        }}

        {{ fivetran_utils.apply_source_relation(package_name='tiktok_ads') }}

    from base
),

final as (

    select
        source_relation,
        creative_id,
        cast(modify_time as {{ dbt.type_timestamp() }}) as updated_at,
        smart_plus_ad_id,
        advertiser_id,
        adgroup_id,
        campaign_id,
        video_id,
        create_time,
        creative_name,
        campaign_name,
        adgroup_name,
        identity_id,
        identity_type,
        campaign_automation_type,
        ad_text,
        secondary_status,
        operation_status,
        image_ids,
        -- See stg_tiktok_ads__smart_plus_ad_history.sql for why the empty-table case is special-cased.
        case
            when creative_id is null and modify_time is null then true
            else row_number() over (partition by creative_id {{ fivetran_utils.partition_by_source_relation(package_name='tiktok_ads') }} order by modify_time desc) = 1
        end as is_most_recent_record
    from fields
)

select *
from final
