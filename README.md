<p align="center">
    <a alt="License"
        href="https://github.com/fivetran/dbt_tiktok_ads/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_,<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
</p>

# Tiktok Ads Transformation dbt Package ([Docs](https://fivetran.github.io/dbt_tiktok_ads/))
# 📣 What does this dbt package do?
- Produces modeled tables that leverage Tiktok Ads data from [Fivetran's connector](https://fivetran.com/docs/applications/tiktok-ads) in the format described by [this ERD](https://fivetran.com/docs/applications/tiktok-ads#schemainformation) and builds off the output of our [Tiktok Ads source package](https://github.com/fivetran/dbt_tiktok_ads_source).
- Creates reports on daily marketing performance across various levels of granularity. 
- Generates a comprehensive data dictionary of your source and modeled Tiktok Ads data through the [dbt docs site](https://fivetran.github.io/dbt_tiktok_ads/).

The following table provides a detailed list of all models materialized within this package by default. 
> TIP: See more details about these models in the package's [dbt docs site](https://fivetran.github.io/dbt_tiktok_ads/#!/overview?g_v=1&g_e=seeds).

| **model**                    | **description**                                                                                                        |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| [tiktok_ads__ad_group_report](https://github.com/fivetran/dbt_tiktok_ads/blob/main/models/tiktok_ads__ad_group_report.sql)                     | Each record represents the daily performance for each ad group. This also includes additional data on the demographics you are targeting. | 
| [tiktok_ads__campaign_report](https://github.com/fivetran/dbt_tiktok_ads/blob/main/models/tiktok_ads__campaign_report.sql)                     | Each record represents the daily performance for each campaign. |
| [tiktok_ads__advertiser_report](https://github.com/fivetran/dbt_tiktok_ads/blob/main/models/tiktok_ads__advertiser_report.sql)                     | Each record represents the daily performance for each account. |
| [tiktok_ads__ad_report](https://github.com/fivetran/dbt_tiktok_ads/blob/main/models/tiktok_ads__ad_report.sql)                     | Each record represents the daily performance for each ad. This also includes additional data on the demographics you are targeting. | 
| [tiktok_ads__url_report](https://github.com/fivetran/dbt_tiktok_ads/blob/main/models/tiktok_ads__url_report.sql)                     | Each record in this table represents the daily performance of URLs at the ad level. This also includes additional data on the demographics you are targeting.

# 🎯 How do I use the dbt package?

## Step 1: Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Tiktok Ads connector syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

### Databricks Dispatch Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

## Step 2: Install the package
Include the following tiktok_ads package version in your `packages.yml` file:
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/tiktok_ads
    version: [">=0.4.0", "<0.5.0"]

```
Do **NOT** include the `tiktok_ads_source` package in this file. The transformation package itself has a dependency on it and will install the source package as well. 

## Step 3: Define database and schema variables
By default, this package will look for your TikTok Ads data in the `tiktok_ads` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your TikTok Ads data is, you would add the following configuration to your root `dbt_project.yml` file with your custom database and schema names:

```yml
vars:
    tiktok_ads_schema: your_database_name
    tiktok_ads_database: your_schema_name
```

For additional configurations for the source models, visit the [Tiktok Ads source package](https://github.com/fivetran/dbt_tiktok_ads_source).

## (Optional) Step 4: Additional configurations
<details><summary>Expand for configurations</summary>

### Passing Through Additional Metrics
By default, this package will select `clicks`, `impressions`, and `cost` from the source reporting tables to store into the staging models. If you would like to pass through additional metrics to the staging models, add the below configurations to your `dbt_project.yml` file. These variables allow for the pass-through fields to be aliased (`alias`) if desired, but not required. Use the below format for declaring the respective pass-through variables:

>**Note** Please ensure you exercised due diligence when adding metrics to these models. The metrics added by default (taps, impressions, and spend) have been vetted by the Fivetran team maintaining this package for accuracy. There are metrics included within the source reports, for example metric averages, which may be inaccurately represented at the grain for reports created in this package. You will want to ensure whichever metrics you pass through are indeed appropriate to aggregate at the respective reporting levels provided in this package.

```yml
vars:
    tiktok_ads__ad_group_hourly_passthrough_metrics: 
      - name: "new_custom_field"
        alias: "custom_field"
      - name: "my_other_field"
    tiktok_ads__ad_hourly_passthrough_metrics:
      - name: "this_field"
    tiktok_ads__campaign_hourly_passthrough_metrics:
      - name: "unique_string_field"
        alias: "field_id"
```

### Change the build schema
By default, this package will build the TikTok Ads staging models within a schema titled (`<target_schema>` + `_stg_tiktok_ads`) and the final TikTok Ads models within a schema titled (`<target_schema>` + `_tiktok_ads`) in your target database. If this is not where you would like your modeled TikTok data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
models:
    tiktok_ads:
        +schema: my_new_schema_name # leave blank for just the target_schema
    tiktok_ads_source:
        +schema: my_new_schema_name # leave blank for just the target_schema
```

    
### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:

> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_tiktok_ads/blob/main/dbt_project.yml) variable declarations to see the expected names.

```yml
vars:
    tiktok_ads_<default_source_table_name>_identifier: your_table_name 
```

</details>

## (Optional) Step 5: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for more details</summary>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).

</details>

# 🔍 Does this package have dependencies?
This dbt package is dependent on the following dbt packages. Please be aware that these dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.
    
```yml
packages:
    - package: fivetran/tiktok_ads_source
      version: [">=0.4.0", "<0.5.0"]

    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]

    - package: dbt-labs/spark_utils
      version: [">=0.3.0", "<0.4.0"]
```
# 🙌 How is this package maintained and can I contribute?
## Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/tiktok_ads/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_tiktok_ads/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

## Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions! 

We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package!

# 🏪 Are there any resources available?
- If you have questions or want to reach out for help, please refer to the [GitHub Issue](https://github.com/fivetran/dbt_tiktok_ads/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
- Have questions or want to just say hi? Book a time during our office hours [on Calendly](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or email us at solutions@fivetran.com.
