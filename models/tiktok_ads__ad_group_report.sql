-- take urls and utms from ad group 


adgroup_id
adgroup_name 
campaign_date
campaign_id
advertiser_id
action_categories
action_days
audience
audience_type
category
gender
age
location
languages
video_actions
video_downloads
state_time_day -- or hour depending on which ad report we use, hourly or daily 
sum(spend)
sum(clicks)
sum(impressions)
sum(follows)
sum(likes)
sum(comments)
sum(shares)


from

left join ad_group_report_daily 

-- Ad_id
-- Stat_time_day
-- Spend
-- Cpc
-- Cpm
-- Ctr
-- Impressions
-- Clicks
-- Reach
-- Conversion
-- Cost_per_conversion
-- Conversion_rate
-- Likes
-- Comments
-- Shares
-- Follows
-- Engagements
-- Video_play_actions
-- video_watched_2s
-- Video_watched_6s
-- video_views_p25
-- average_video_play

