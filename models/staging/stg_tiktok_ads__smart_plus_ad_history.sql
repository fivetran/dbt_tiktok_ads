{{ config(enabled=var('ad_reporting__tiktok_ads_enabled', true) and var('tiktok_ads__using_smart_plus_ads', true)) }}

with base as (

    select *
    from {{ ref('stg_tiktok_ads__smart_plus_ad_history_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_tiktok_ads__smart_plus_ad_history_tmp')),
                staging_columns=get_smart_plus_ad_history_columns()
            )
        }}

        {{ fivetran_utils.apply_source_relation(package_name='tiktok_ads') }}

    from base
),

required_fields as (

    select
        source_relation,
        smart_plus_ad_id,
        landing_page_url_list
    from fields
    where landing_page_url_list is not null
),

{{ tiktok_ads_get_landing_page_urls_query(output_cte_name='landing_page_urls_unnested') }},

landing_page_urls_agg as (

    select
        source_relation,
        smart_plus_ad_id,
        -- A single Smart+ ad can have multiple landing pages. `landing_page_url` picks one (the lowest alphabetically,
        -- for a deterministic result) to derive `base_url`/`url_host`/`url_path`/`utm_*` from, consistent with the single
        -- URL that `ad_history` provides for manual ads. `landing_page_urls` preserves the full set so no data is lost.
        min(landing_page_url) as landing_page_url,
        {{ fivetran_utils.string_agg('landing_page_url', "', '") }} as landing_page_urls
    from landing_page_urls_unnested
    group by 1, 2
),

final as (

    select
        fields.source_relation,
        fields.smart_plus_ad_id,
        cast(fields.modify_time as {{ dbt.type_timestamp() }}) as updated_at,
        fields.adgroup_id,
        fields.advertiser_id,
        fields.campaign_id,
        fields.ad_name,
        fields.campaign_name,
        fields.adgroup_name,
        fields.create_time,
        fields.operation_status,
        fields.secondary_status,
        landing_page_urls_agg.landing_page_url,
        landing_page_urls_agg.landing_page_urls,
        {{ dbt.split_part('landing_page_urls_agg.landing_page_url', "'?'", 1) }} as base_url,
        {{ dbt_utils.get_url_host('landing_page_urls_agg.landing_page_url') }} as url_host,
        '/' || {{ dbt_utils.get_url_path('landing_page_urls_agg.landing_page_url') }} as url_path,
        {{ tiktok_ads.tiktok_ads_extract_url_parameter('landing_page_urls_agg.landing_page_url', 'utm_source') }} as utm_source,
        {{ tiktok_ads.tiktok_ads_extract_url_parameter('landing_page_urls_agg.landing_page_url', 'utm_medium') }} as utm_medium,
        {{ tiktok_ads.tiktok_ads_extract_url_parameter('landing_page_urls_agg.landing_page_url', 'utm_campaign') }} as utm_campaign,
        {{ tiktok_ads.tiktok_ads_extract_url_parameter('landing_page_urls_agg.landing_page_url', 'utm_content') }} as utm_content,
        {{ tiktok_ads.tiktok_ads_extract_url_parameter('landing_page_urls_agg.landing_page_url', 'utm_term') }} as utm_term,
        fields.tracking_info_click_tracking_url,
        fields.tracking_info_impression_tracking_url,
        fields.tracking_info_tracking_app_id,
        fields.tracking_info_tracking_message_event_set_id,
        fields.identity_id,
        fields.identity_type,
        fields.dark_post_status,
        fields.product_specific_type,
        fields.product_set_id,
        fields.product_ids,
        fields.creative_auto_add_toggle,
        fields.catalog_creative_toggle,
        fields.end_card_cta,
        fields.product_display_field_list,
        fields.auto_disclaimer_types,
        fields.fallback_type,
        fields.call_to_action_id,
        fields.product_info_selling_points,
        fields.phone_info_phone_region_code,
        fields.phone_info_phone_region_calling_code,
        fields.phone_info_phone_number,
        fields.ad_text_list,
        fields.auto_message_list,
        fields.call_to_action_list,
        fields.interactive_add_on_list,
        fields.page_list,
        fields.custom_product_page_list,
        fields.deeplink_list,
        row_number() over (partition by fields.smart_plus_ad_id {{ fivetran_utils.partition_by_source_relation(package_name='tiktok_ads') }} order by fields.modify_time desc) = 1 as is_most_recent_record
    from fields
    left join landing_page_urls_agg
        on fields.smart_plus_ad_id = landing_page_urls_agg.smart_plus_ad_id
        and fields.source_relation = landing_page_urls_agg.source_relation
)

select *
from final
