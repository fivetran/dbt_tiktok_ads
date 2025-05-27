# dbt_tiktok_ads v0.8.1

[PR #26](https://github.com/fivetran/dbt_tiktok_ads/pull/26) includes the following updates:
## Under the Hood
- Updated `unique_combination_of_columns` test for `tiktok_ads__campaign_country_report` to include `country_code` column.  ([#26](https://github.com/fivetran/dbt_tiktok_ads/pull/26))

## Contributors
- [@timvyas](https://github.com/timvyas) ([PR #26](https://github.com/fivetran/dbt_ad_reporting/pull/26))

# dbt_tiktok_ads v0.8.0

[PR #24](https://github.com/fivetran/dbt_tiktok_ads/pull/24) includes the following updates:
## Schema Changes
**4 total changes • 0 possible breaking changes**
| Data Model                                     | Change Type | Old Names | New Names                                  | Notes                                                             |
|---------------------------------------------------|-------------|----------|-------------------------------------------|-------------------------------------------------------------------|
| [tiktok_ads__campaign_country_report](https://fivetran.github.io/dbt_tiktok_ads/#!/model/model.tiktok_ads.tiktok_ads__campaign_country_report)       | New Transformation Model   |          |  | New table that represents the daily performance of a campaign at the country/geographic region level.               |
| [stg_tiktok_ads__campaign_country_report_tmp](https://fivetran.github.io/dbt_tiktok_ads/#!/model/model.tiktok_ads_source.stg_tiktok_ads__campaign_country_report_tmp)       | New Temp Model   |          |  | Temp model added for `campaign_country_report`.               |
| [stg_tiktok_ads__campaign_country_report](https://fivetran.github.io/dbt_tiktok_ads/#!/model/model.tiktok_ads_source.stg_tiktok_ads__campaign_country_report)           | New Staging Model   |          |    | Staging model added for `campaign_country_report`.         |
| [stg_tiktok_ads__campaign_history](https://fivetran.github.io/dbt_tiktok_ads/#!/model/model.tiktok_ads_source.stg_tiktok_ads__campaign_history)           | New Columns   |          | `objective_type`, `status`, `budget`, `budget_mode`, `created_at`, `is_new_structure`   |         |

## Feature Updates
- Added the `tiktok_ads__campaign_country_report` end model and upstream staging models. See above for schema change details and new models added.
  - For dbt Core users: If you do not sync this table or would like disable these new models you can disable the models by setting the  `tiktok_ads__using_campaign_country_report` variable to `false` in your `dbt_project.yml` file (`true` by default).  See [README](https://github.com/fivetran/dbt_tiktok_ads?tab=readme-ov-file#disable-country-reports) for more details.
- Included the `tiktok_ads__campaign_country_report_passthrough_metrics` passthrough variable in the above mentioned new staging models. Refer to the [README](https://github.com/fivetran/dbt_tiktok_ads/tree/main?tab=readme-ov-file#passing-through-additional-metrics) for more details.

## Documentation
- Added Quickstart model counts to README. ([#23](https://github.com/fivetran/dbt_tiktok_ads/pull/23))
- Corrected references to connectors and connections in the README. ([#23](https://github.com/fivetran/dbt_tiktok_ads/pull/23))

## Under the Hood
- Added vertical integrity test to ensure data accuracy of the new `tiktok_ads__campaign_country_report`.  ([#24](https://github.com/fivetran/dbt_tiktok_ads/pull/24))

# dbt_tiktok_ads v0.7.0
[PR #22](https://github.com/fivetran/dbt_tiktok_ads/pull/22) includes the following updates:

## Breaking Changes
- **Upstream Breaking Change:** In the [July 2023 TikTok Ads connector update](https://fivetran.com/docs/connectors/applications/tiktok-ads/changelog#july2023) for the `ADGROUP_HISTORY` table, the `age` column was renamed to `age_groups`.
  - This change primarily affects the upstream `stg_tiktok_ads__ad_group_history` model in `dbt_tiktok_source`. The `age_groups` column was not previously used in any downstream models within `dbt_tiktok_ads`, so this change impacts only the upstream staging model.
  - Previously, we coalesced the `age` and `age_groups` columns in the `stg_tiktok_ads__ad_group_history` model to accommodate connectors using the old naming convention. However, due to inconsistent data types, this approach is no longer viable.
  - As a result, the coalesced field has been removed in favor of the `age_groups` column.
  - If necessary, you can populate historical data in the `age_groups` column by performing a resync of the `ADGROUP_HISTORY` table, as TikTok provides all data regardless of the previous sync state.
  - For more details, see the [DECISIONLOG entry](https://github.com/fivetran/dbt_tiktok_ads/blob/main/DECISIONLOG.md#age_groups-and-age-columns).

## Documentation  
- Added `DECISIONLOG` file:  
  - Detailed the removal of the previously mentioned coalesced `age` and `age_groups` column.  
  - Clarified why aggregation differences occur across varying grains.  

# dbt_tiktok_ads v0.6.0
[PR #20](https://github.com/fivetran/dbt_tiktok_ads/pull/20) includes the following **BREAKING CHANGE** updates:

# Feature Updates: Conversion Support
- We have added the following source fields to each `tiktok_ads` end model (note that the `conversion` field was already present):
  - `real_time_conversion`: Number of times your ad resulted in the optimization event and timeframe you selected.
  - `total_purchase_value`: The total value of purchase events that occurred in your app that were recorded by your measurement partner.
  - `total_sales_lead_value`: The monetary worth or potential value assigned to a lead generated through ads.
  - `total_conversion_value`: The accumulated value of `total_purchase_value` and `total_sales_lead_value`.

- In the event that you were already passing the above fields in via our [passthrough columns](https://github.com/fivetran/dbt_tiktok_ads?tab=readme-ov-file#passing-through-additional-metrics), the package will dynamically avoid "duplicate column" errors.
> The above new field additions are **breaking changes**  for users who were not already bringing in conversion fields via passthrough columns.

## Under the Hood
- Created `tiktok_ads_persist_pass_through_columns` macro to ensure that the new conversion fields are backwards compatible with users who have already included them via passthrough fields.
- Updated `conversion` field to be an integer rather than a numeric data type in the `tiktok_ads_source` package, as is the expected behavior of the field. **This is a breaking change.**
- Added integrity and consistency validation tests within `integration_tests` folder for the transformation models (to be used by maintainers only).
- Updated seed data to adequately test new field additions in integration tests.

## Contributors
- [Seer Interactive](https://www.seerinteractive.com/?utm_campaign=Fivetran%20%7C%20Models&utm_source=Fivetran&utm_medium=Fivetran%20Documentation)

# dbt_tiktok_ads v0.5.0
[PR #13](https://github.com/fivetran/dbt_tiktok_ads/pull/13) includes the following updates:

## Breaking changes
- Updated the source identifier format for consistency with other packages and for compatibility with the `fivetran_utils.union_data` macro. Identifiers now are:

| current  | previous |
|----------|----------|
|tiktok_ads_adgroup_history_identifier | tiktok_ads__ad_group_history_identifier |
|tiktok_ads_ad_history_identifier | tiktok_ads__ad_history_identifier
|tiktok_ads_advertiser_identifier | tiktok_ads__advertiser_identifier|
|tiktok_ads_campaign_history_identifier | tiktok_ads__campaign_history_identifier|
|tiktok_ads_ad_report_hourly_identifier | tiktok_ads__ad_report_hourly_identifier|
|tiktok_ads_adgroup_report_hourly_identifier | tiktok_ads__ad_group_report_hourly_identifier|
|tiktok_ads_campaign_report_hourly_identifier | tiktok_ads__campaign_report_hourly_identifier|

- If you are using the previous identifier, be sure to update to the current version!

## Feature update 🎉
- Unioning capability! This adds the ability to union source data from multiple tiktok_ads connectors. Refer to the [Union Multiple Connectors README section](https://github.com/fivetran/dbt_tiktok_ads/blob/main/README.md#union-multiple-connectors) for more details.

## Under the hood 🚘
- In the source package, updated tmp models to union source data using the `fivetran_utils.union_data` macro. 
- To distinguish which source each field comes from, added `source_relation` column in each staging and downstream model and applied the `fivetran_utils.source_relation` macro.
  - The `source_relation` column is included in all joins in the transform package. 
- Updated tests to account for the new `source_relation` column.


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
