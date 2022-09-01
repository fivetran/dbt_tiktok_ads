# dbt_tiktok_ads v0.2.1

This PR ([#6](https://github.com/fivetran/dbt_tiktok_ads/pull/6)) updates the source package version.
# dbt_tiktok_ads v0.2.0
This PR ([#5](https://github.com/fivetran/dbt_tiktok_ads/pull/5)) applies the following updates to provide further flexibility in your ad reporting. Additionally, these new end models will be leveraged in the respective downstream [dbt_ad_reporting](https://github.com/fivetran/dbt_ad_reporting) models. 
## 🚨 Breaking Changes 🚨
- Updates `ad_group_hourly` variable to `ad_group_report_hourly`
- Removes intermediate models and instead incorporates previous logic into end models
- Renames the `tikok_ads__ad_adapter` model to `tiktok_ads__url_report` 
- Removes dependency of models on the `tikok_ads__ad_adapter` model and moves that previous logic into each model, using corresponding hourly reports for each model's granularity (e.g. `tikok_ads__campaign_report` now uses the `campaign_report_hourly`)
## 🎉 Feature Enhancements 🎉
- Adds in the following models and respective field descriptions and tests:
    - `tiktok_ads__account_report`
    - `tiktok_ads__url_report`
    - `tiktok_ads__ad_report`
- Adds additional fields to existing models `ad_group_report` and `campaign_report` that were previously not brought in
- Inclusion of passthrough metrics:
  - `tiktok_ads__ad_group_hourly_passthrough_metrics`
  - `tiktok_ads__ad_hourly_passthrough_metrics`
  - `tiktok_ads__campaign_hourly_passthrough_metrics`
> This applies to all passthrough columns within the `dbt_tiktok_ads` package and not just the `tiktok_ads__ad_group_hourly_passthrough_metrics` example.
```yml
vars:
  tiktok_ads__ad_group_hourly_passthrough_metrics:
    - name: "my_field_to_include" # Required: Name of the field within the source.
      alias: "field_alias" # Optional: If you wish to alias the field within the staging model.
```
- Adds not-null tests to key fields
- Applies standardization updates 
- Add enable configs for this specific ad platform, for use in the Ad Reporting rollup package 

# dbt_tiktok_ads v0.1.1
## Under the Hood
- Updated package yml to point to live source 

# dbt_tiktok_ads v0.1.0

## Initial Release
- This is the initial release of this package. For more information refer to the [README](/README.md).

## Under the Hood
- Aggregating daily metrics: As best practice, we try using the most granular data to perform aggregations. Therefore metrics such as `spend` and `daily_cpc` for each day is aggregated using the hourly source tables rather than daily source tables. In addition, aggregations done per ad group and per campaign is done using the ad table. 
