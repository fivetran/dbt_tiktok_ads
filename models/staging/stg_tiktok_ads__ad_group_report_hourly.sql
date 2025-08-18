{{ config(enabled=var('ad_reporting__tiktok_ads_enabled', true)) }}

with base as (

    select *
    from {{ ref('stg_tiktok_ads__ad_group_report_hourly_tmp') }}
), 

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_tiktok_ads__ad_group_report_hourly_tmp')),
                staging_columns=get_ad_group_report_hourly_columns()
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
        cast(stat_time_hour as {{ dbt.type_timestamp() }}) as stat_time_hour, 
        cpc, 
        cpm, 
        ctr, 
        coalesce(impressions, 0) as impressions,
        coalesce(clicks, 0) as clicks, 
        coalesce(spend, 0) as spend, 
        coalesce(reach, 0) as reach, 
        coalesce(conversion, 0) as conversion, 
        cost_per_conversion, 
        conversion_rate, 
        coalesce(likes, 0) as likes,
        coalesce(comments, 0) as comments,
        coalesce(shares, 0) as shares,
        coalesce(profile_visits, 0) as profile_visits,
        coalesce(follows, 0) as follows,
        coalesce(video_play_actions, 0) as video_play_actions,
        coalesce(video_watched_2_s, 0) as video_watched_2_s,
        coalesce(video_watched_6_s, 0) as video_watched_6_s,
        coalesce(video_views_p_25, 0) as video_views_p_25,
        coalesce(video_views_p_50, 0) as video_views_p_50,
        coalesce(video_views_p_75, 0) as video_views_p_75,
        average_video_play, 
        average_video_play_per_user,
        coalesce(real_time_conversion, 0) as real_time_conversion,
        coalesce(total_purchase_value, 0) as total_purchase_value,
        coalesce(total_sales_lead_value, 0) as total_sales_lead_value

        {{ tiktok_ads_fill_pass_through_columns(pass_through_fields=var('tiktok_ads__ad_group_hourly_passthrough_metrics'), except_fields=["real_time_conversion", "total_purchase_value", "total_sales_lead_value"]) }}

    from fields
) 

select *
from final

