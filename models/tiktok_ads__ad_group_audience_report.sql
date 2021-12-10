
select
    ad_group_id,
    ad_group_name, 
    advertiser_id, 
    campaign_id, 
    action_days,
    -- action_categories,
    gender, 
    audience_type,
    budget
    -- age, 
    -- languages, 
    -- interest_category
from 
{{ ref('int_tiktok_ads__most_recent_ad_group') }}


