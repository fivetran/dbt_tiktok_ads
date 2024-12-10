# DECISION LOG

## Why don't metrics add up across different grains (Ex. ad level vs campaign level)?
Not all ads are served at the ad level. In other words, there are some ads that are served only at the ad group, campaign, etc. levels. The implications are that since not ads are included in the ad-level report, their associated spend, for example, won't be included at that grain. Therefore your spend totals may differ across the ad grain and another grain. 

This is a reason why we have broken out the ad reporting packages into separate hierarchical end models (Ad, Ad Group, Campaign, and more). Because if we only used ad-level reports, we could be missing data.

## `age_groups` and `age` columns
In the [July 2023 TikTok Ads connector update](https://fivetran.com/docs/connectors/applications/tiktok-ads/changelog#july2023), we renamed the `age` column in the `ADGROUP_HISTORY` table to `age_groups`. To maintain compatibility with connectors using the old column name, our data models previously coalesced the `age` and `age_groups` columns. However, due to inconsistent data types between `age` and `age_groups`, this approach began causing errors.

### Decision
- The `age` column has been removed from the `stg_tiktok_ads__ad_group_history` model and the `fill` staging macro for the ad group history table.
- Models now rely exclusively on the `age_groups` column.

### Impact
- Customers using the `age` column will no longer have access to this field in the models.
- The change simplifies logic and resolves data inconsistency issues caused by merging fields with different data types.

### Action for Customers Requiring Historical `age` Data
Customers who still need the historical `age` column data can resync the `ADGROUP_HISTORY` table in their TikTok Ads connector. TikTok provides all historical data in the `age_groups` column, allowing the data to be fully populated.