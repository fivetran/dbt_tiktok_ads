# dbt_tiktok_ads v0.2.0
- This PR ([#5](https://github.com/fivetran/dbt_tiktok_ads/pull/5)) applies the Ad Reporting V2 updates to provide further flexibility in your ad reporting. Additionally, these new end models will be leveraged in the respective downstream [dbt_ad_reporting](https://github.com/fivetran/dbt_ad_reporting) models. 

- Adds in the `account_report`, `url_report`, `ad_report` models and the respective field descriptions and tests for the new models in the yml files
- Adds additional fields to existing models `ad_group_report` and `campaign_report` that were previously not brought in
- Removes the ad_adapter model and the respective dependencies the other models have on it, instead using that model's level of granularity's hourly report.
- Add passthrough metrics for respective models: ([#5](https://github.com/fivetran/dbt_tiktok_ads/pull/5))
    - `tiktok_ads__ad_hourly_passthrough_metrics`
    - `tiktok_ads__ad_group_hourly_passthrough_metrics`
    - `tiktok_ads__campaign_hourly_passthrough_metrics`
- Applies standardization updates 

# dbt_tiktok_ads v0.1.1
## Under the Hood
- Updated package yml to point to live source 

# dbt_tiktok_ads v0.1.0

## Initial Release
- This is the initial release of this package. For more information refer to the [README](/README.md).

## Under the Hood
- Aggregating daily metrics: As best practice, we try using the most granular data to perform aggregations. Therefore metrics such as `spend` and `daily_cpc` for each day is aggregated using the hourly source tables rather than daily source tables. In addition, aggregations done per ad group and per campaign is done using the ad table. 
