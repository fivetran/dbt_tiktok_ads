
    select *
    from {{ ref('int_tiktok_ads__most_recent_ad_group') }}

-- -- take urls and utms from ad group 


-- adgroup_id, 
-- adgroup_name , 
-- campaign_date, 
-- campaign_id, 
-- advertiser_id, 
-- action_categories, 
-- action_days, 
-- audience, 
-- audience_type, 
-- category, 
-- video_actions, 
-- video_downloads, 
-- stat_time_day, -- or hour depending on which ad report we use, hourly or daily 
-- sum(spend) as spend, 
-- sum(clicks) as clicks, 
-- sum(impressions) as impressions, 
-- sum(follows) as follows, 
-- sum(likes) as likes, 
-- sum(comments) as comments, 
-- sum(shares) as shares, 
-- -- cac,


-- from

-- left join ad_group_report_daily 

-- -- Ad_id
-- -- Stat_time_day
-- -- Spend
-- -- Cpc
-- -- Cpm
-- -- Ctr
-- -- Impressions
-- -- Clicks
-- -- Reach
-- -- Conversion
-- -- Cost_per_conversion
-- -- Conversion_rate
-- -- Likes
-- -- Comments
-- -- Shares
-- -- Follows
-- -- Engagements
-- -- Video_play_actions
-- -- video_watched_2s
-- -- Video_watched_6s
-- -- video_views_p25
-- -- average_video_play

-- group by 