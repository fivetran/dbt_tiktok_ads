# dbt_tiktok_ads v0.1.1
## Under the Hood
- Updated package yml to point to live source 

# dbt_tiktok_ads v0.1.0

## Initial Release
- This is the initial release of this package. For more information refer to the [README](/README.md).

## Under the Hood
- Aggregating daily metrics: As best practice, we try using the most granular data to perform aggregations. Therefore metrics such as `spend` and `daily_cpc` for each day is aggregated using the hourly source tables rather than daily source tables. In addition, aggregations done per ad group and per campaign is done using the ad table. 
