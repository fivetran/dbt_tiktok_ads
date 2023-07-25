# dbt_tiktok_ads v0.4.0
[PR #11](https://github.com/fivetran/dbt_tiktok_ads/pull/11) includes the following changes:

## 🚨 Breaking Changes 🚨
- In the [July 2023 connector update for TikTok Ads](https://fivetran.com/docs/applications/tiktok-ads/changelog), the connector was updated to support the TikTok Ads v1.3 API. As a result breaking changes exist within the dependent [v0.4.0 dbt_tiktok_ads_source](https://github.com/fivetran/dbt_tiktok_ads_source/releases/tag/v0.4.0) release in addition to the following breaking changes within this package release:

| **Updated model** | **Removed fields** |
| ----------| -------------------- |
| [tiktok_ads__ad_group_report](https://fivetran.github.io/dbt_tiktok_ads/#!/model/model.tiktok_ads.tiktok_ads__ad_group_report) | `action_categories`, `age`, `languages`, `interest_category` |
| [tiktok_ads__ad_report](https://fivetran.github.io/dbt_tiktok_ads/#!/model/model.tiktok_ads.tiktok_ads__ad_report) | `action_categories`, `age`, `languages`, `interest_category` |
| [tiktok_ads__url_report](https://fivetran.github.io/dbt_tiktok_ads/#!/model/model.tiktok_ads.tiktok_ads__url_report) | `action_categories`, `age`, `languages`, `interest_category` |

>**Note**: All of the above fields were also removed due to complications with the BigQuery JSON datatype causing errors during compilation.

 ## 🔧 Under the Hood 🔩
- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job.
- Updated the pull request [templates](/.github).

# dbt_tiktok_ads v0.3.0

## 🚨 Breaking Changes 🚨:
[PR #7](https://github.com/fivetran/dbt_tiktok_ads/pull/7) includes the following breaking changes:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- `packages.yml` has been updated to reflect new default `fivetran/fivetran_utils` version, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.

## 🎉 Features 🎉
- For use in the [dbt_ad_reporting package](https://github.com/fivetran/dbt_ad_reporting), users can now allow records having nulls in url fields to be included in the `ad_reporting__url_report` model. See the [dbt_ad_reporting README](https://github.com/fivetran/dbt_ad_reporting) for more details. [PR #8](https://github.com/fivetran/dbt_tiktok_ads/pull/8)
## 🚘 Under the Hood 🚘
- Disabled the `not_null` test for `tiktok_ads__url_report` when null urls are allowed. [PR #8](https://github.com/fivetran/dbt_tiktok_ads/pull/8)

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
