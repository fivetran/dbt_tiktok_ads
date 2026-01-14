<!--section="tiktok-ads_transformation_model"-->
# Tiktok Ads dbt Package

<p align="left">
    <a alt="License"
        href="https://github.com/fivetran/dbt_tiktok_ads/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0,_<3.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
    <a alt="Fivetran Quickstart Compatible"
        href="https://fivetran.com/docs/transformations/dbt/quickstart">
        <img src="https://img.shields.io/badge/Fivetran_Quickstart_Compatible%3F-yes-green.svg" /></a>
</p>

This dbt package transforms data from Fivetran's Tiktok Ads connector into analytics-ready tables.

## Resources

- Number of materialized models¹: 22
- Connector documentation
  - [Tiktok Ads connector documentation](https://fivetran.com/docs/connectors/applications/tiktok-ads)
  - [Tiktok Ads ERD](https://fivetran.com/docs/connectors/applications/tiktok-ads#schemainformation)
- dbt package documentation
  - [GitHub repository](https://github.com/fivetran/dbt_tiktok_ads)
  - [dbt Docs](https://fivetran.github.io/dbt_tiktok_ads/#!/overview)
  - [DAG](https://fivetran.github.io/dbt_tiktok_ads/#!/overview?g_v=1)
  - [Changelog](https://github.com/fivetran/dbt_tiktok_ads/blob/main/CHANGELOG.md)

## What does this dbt package do?
This package enables you to produce modeled tables, create reports on daily marketing performance, and generate comprehensive data dictionaries. It creates enriched models with metrics focused on spend, clicks, impressions, and conversions across various levels of granularity.

### Output schema
Final output tables are generated in the following target schema:

```
<your_database>.<connector/schema_name>_tiktok_ads
```

### Final output tables

By default, this package materializes the following final tables:

| Table | Description |
| :---- | :---- |
| [tiktok_ads__ad_group_report](https://github.com/fivetran/dbt_tiktok_ads/blob/main/models/tiktok_ads__ad_group_report.sql) | Represents daily performance aggregated at the ad group level, including `spend`, `clicks`, `impressions`, and `conversions`, enriched with demographic targeting data.<br><br>**Example Analytics Questions:**<ul><li>Which ad groups have the strongest engagement relative to their budget?</li><li>Do certain ad groups dominate impressions within a campaign?</li><li>Are new ad groups ramping up as expected after launch?</li></ul> |
| [tiktok_ads__campaign_report](https://github.com/fivetran/dbt_tiktok_ads/blob/main/models/tiktok_ads__campaign_report.sql) | Represents daily performance aggregated at the campaign level, including `spend`, `clicks`, `impressions`, and `conversions`.<br><br>**Example Analytics Questions:**<ul><li>Which campaigns are most efficient in terms of cost per conversion?</li><li>Are paused or limited-status campaigns still accruing impressions?</li><li>Which campaigns contribute most to overall spend or conversions?</li></ul> |
| [tiktok_ads__campaign_country_report](https://github.com/fivetran/dbt_tiktok_ads/blob/main/models/tiktok_ads__campaign_country_report.sql) | Represents daily performance aggregated at the campaign level by country, including `spend`, `clicks`, `impressions`, and `conversions`, enriched with geographic context.<br><br>**Example Analytics Questions:**<ul><li>Which countries are delivering the highest return on ad spend for each campaign?</li><li>Are there seasonal performance variations by geographic region?</li></ul> |
| [tiktok_ads__advertiser_report](https://github.com/fivetran/dbt_tiktok_ads/blob/main/models/tiktok_ads__advertiser_report.sql) | Represents daily performance aggregated at the advertiser level (equivalent to account level), including `spend`, `clicks`, `impressions`, and `conversions`.<br><br>**Example Analytics Questions:**<ul><li>How does performance compare across different accounts by account manager?</li><li>Are currency fluctuations affecting results across markets?</li></ul> |
| [tiktok_ads__ad_report](https://github.com/fivetran/dbt_tiktok_ads/blob/main/models/tiktok_ads__ad_report.sql) | Represents daily performance at the individual ad level, including `spend`, `clicks`, `impressions`, and `conversions`, enriched with demographic targeting data.<br><br>**Example Analytics Questions:**<ul><li>Which ad creatives are driving the lowest cost per click?</li><li>Do expanded text ads perform better than responsive search ads?</li><li>How do performance trends change after refreshing ad copy?</li></ul> |
| [tiktok_ads__url_report](https://github.com/fivetran/dbt_tiktok_ads/blob/main/models/tiktok_ads__url_report.sql) | Represents daily performance of URLs at the ad level, including `spend`, `clicks`, `impressions`, and `conversions`, enriched with ad context and demographic targeting data.<br><br>**Example Analytics Questions:**<ul><li>Which landing pages are driving the highest conversion rates?</li><li>Are certain URLs performing better with specific ad creative combinations?</li></ul> |

¹ Each Quickstart transformation job run materializes these models if all components of this data model are enabled. This count includes all staging, intermediate, and final models materialized as `view`, `table`, or `incremental`.

---

## Visualizations
Many of the above reports are now configurable for [visualization via Streamlit](https://github.com/fivetran/streamlit_ad_reporting). Check out some [sample reports here](https://fivetran-ad-reporting.streamlit.app/ad_performance).

<p align="center">
  <a href="https://fivetran-ad-reporting.streamlit.app/ad_performance">
    <img src="https://raw.githubusercontent.com/fivetran/dbt_tiktok_ads/main/images/streamlit_example.png" alt="Fivetran Ad Reporting Streamlit App" width="100%">
  </a>
</p>

## Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Tiktok Ads connection syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

## How do I use the dbt package?
You can either add this dbt package in the Fivetran dashboard or import it into your dbt project:

- To add the package in the Fivetran dashboard, follow our [Quickstart guide](https://fivetran.com/docs/transformations/dbt).
- To add the package to your dbt project, follow the setup instructions in the dbt package's [README file](https://github.com/fivetran/dbt_tiktok_ads/blob/main/README.md#how-do-i-use-the-dbt-package) to use this package.

<!--section-end-->

### Install the package (skip if also using the `ad_reporting` combo package)
Include the following tiktok_ads package version in your `packages.yml` file _if_ you are not also using the upstream [Ad Reporting combination package](https://github.com/fivetran/dbt_ad_reporting):
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

```yaml
packages:
  - package: fivetran/tiktok_ads
    version: [">=1.2.0", "<1.3.0"]

```
> All required sources and staging models are now bundled into this transformation package. Do not include `fivetran/tiktok_ads_source` in your `packages.yml` since this package has been deprecated.

#### Databricks Dispatch Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

### Define database and schema variables
By default, this package will look for your TikTok Ads data in the `tiktok_ads` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your TikTok Ads data is, you would add the following configuration to your root `dbt_project.yml` file with your custom database and schema names:

```yml
vars:
    tiktok_ads_schema: your_database_name
    tiktok_ads_database: your_schema_name
```

### (Optional) Additional configurations

<details open><summary>Expand/Collapse details</summary>

#### Union multiple connections
If you have multiple tiktok_ads connections in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. The package will union all of the data together and pass the unioned table into the transformations. You will be able to see which source it came from in the `source_relation` column of each model. To use this functionality, you will need to set either the `tiktok_ads_union_schemas` OR `tiktok_ads_union_databases` variables (cannot do both) in your root `dbt_project.yml` file:

```yml
vars:
    tiktok_ads_union_schemas: ['tiktok_ads_usa','tiktok_ads_canada'] # use this if the data is in different schemas/datasets of the same database/project
    tiktok_ads_union_databases: ['tiktok_ads_usa','tiktok_ads_canada'] # use this if the data is in different databases/projects but uses the same schema name
```
> NOTE: The native `source.yml` connection set up in the package will not function when the union schema/database feature is utilized. Although the data will be correctly combined, you will not observe the sources linked to the package models in the Directed Acyclic Graph (DAG). This happens because the package includes only one defined `source.yml`.

To connect your multiple schema/database sources to the package models, follow the steps outlined in the [Union Data Defined Sources Configuration](https://github.com/fivetran/dbt_fivetran_utils/tree/releases/v0.4.latest#union_data-source) section of the Fivetran Utils documentation for the union_data macro. This will ensure a proper configuration and correct visualization of connections in the DAG.

#### Disable Country Reports
This package leverages the `campaign_country_report` table to help report on ad and campaign performance by country/geographic region level. However, if you are not actively syncing this report from your TikTok Ads connection, you may disable the transformations for the `campaign_country_report` by adding the following variable configuration to your root `dbt_project.yml` file:
```yml
vars:
    tiktok_ads__using_campaign_country_report: False # True by default
```

#### Passing Through Additional Metrics
By default, this package will select `clicks`, `impressions`, `spend` , `conversion`, `real_time_conversion`, `total_purchase_value`, and `total_sales_lead_value` from the source reporting tables to store into the staging models. If you would like to pass through additional metrics to the staging models, add the below configurations to your `dbt_project.yml` file. These variables allow for the pass-through fields to be aliased (`alias`) if desired, but not required. Use the below format for declaring the respective pass-through variables:

> IMPORTANT: Make sure to exercise due diligence when adding metrics to these models. The metrics added by default (clicks, impressions, spend, and various conversion metrics) have been vetted by the Fivetran team, maintaining this package for accuracy. There are metrics included within the source reports, such as metric averages, which may be inaccurately represented at the grain for reports created in this package. You must ensure that whichever metrics you pass through are appropriate to aggregate at the respective reporting levels in this package.

```yml
vars:
    tiktok_ads__ad_group_hourly_passthrough_metrics: 
      - name: "new_custom_field"
        alias: "custom_field"
      - name: "my_other_field"
    tiktok_ads__ad_hourly_passthrough_metrics:
      - name: "this_field"
    tiktok_ads__campaign_country_report_passthrough_metrics:
      - name: "unique_string_field"
        alias: "field_id"
    tiktok_ads__campaign_hourly_passthrough_metrics:
      - name: "unique_string_field"
        alias: "field_id"
```

#### Change the build schema
By default, this package will build the TikTok Ads staging models (8 views, 8 tables) within a schema titled (`<target_schema>` + `_stg_tiktok_ads`) and the final TikTok Ads models (6 tables) within a schema titled (`<target_schema>` + `_tiktok_ads`) in your target database. If this is not where you would like your modeled TikTok data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml
models:
    tiktok_ads:
      +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
      staging:
        +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
```

#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable. This is not available when running the package on multiple unioned connections.

> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_tiktok_ads/blob/main/dbt_project.yml) variable declarations to see the expected names.

```yml
vars:
    tiktok_ads_<default_source_table_name>_identifier: your_table_name 
```

</details>

### (Optional) Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for more details</summary>
<br>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).

</details>

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.

```yml
packages:
    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]

    - package: dbt-labs/spark_utils
      version: [">=0.3.0", "<0.4.0"]
```
<!--section="tiktok-ads_maintenance"-->
## How is this package maintained and can I contribute?

### Package Maintenance
The Fivetran team maintaining this package only maintains the [latest version](https://hub.getdbt.com/fivetran/tiktok_ads/latest/) of the package. We highly recommend you stay consistent with the latest version of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_tiktok_ads/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Learn how to contribute to a package in dbt's [Contributing to an external dbt package article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657).

#### Contributors
We thank [everyone](https://github.com/fivetran/dbt_tiktok_ads/graphs/contributors) who has taken the time to contribute. Each PR, bug report, and feature request has made this package better and is truly appreciated.

A special thank you to [Seer Interactive](https://www.seerinteractive.com/?utm_campaign=Fivetran%20%7C%20Models&utm_source=Fivetran&utm_medium=Fivetran%20Documentation), who we closely collaborated with to introduce native conversion support to our Ad packages.

<!--section-end-->

## Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_tiktok_ads/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).