# Healthcare Emergency Department Performance Analysis

Analysis of hospital-reported emergency department performance across Alabama, Louisiana, and Mississippi using Python, BigQuery SQL, Google Sheets, and Tableau.

## Interactive Dashboard

Explore the Tableau dashboard
https://public.tableau.com/views/HealthcareEDAnalysisProject/Dashboard1?:language=en-US&:sid=&:display_count=n&:origin=viz_share_link

![Healthcare ED Performance Dashboard](dashboard/Healthcare%20ED%20Performance.png)

## Business Problem

Hospital leadership needs to identify emergency department performance gaps and prioritize further operational review.

This project compares hospital scores with matching state benchmarks for two measures:

- **OP_18b:** Median ED duration for discharged patients, excluding psychiatric/mental health and transferred patients.
- **OP_22:** Percentage of patients who left the ED before being seen.

The analysis identifies benchmark gaps, examines hospital characteristics and geographic patterns, and documents score availability.

## Tools and Skills

| Tool | Application |
|---|---|
| Python | Data preparation, type conversion, and quality checks |
| BigQuery SQL | LEFT JOINs, aggregations, benchmark comparisons, and hospital rankings |
| Google Sheets | Analysis tracking, data dictionary, pivot table, and chart |
| Tableau | Dataset joins, calculated fields, map, hospital comparisons, and interactive State filter |

## Data Sources

Public CMS Provider Data Catalog datasets:

- [Hospital General Information](https://data.cms.gov/provider-data/dataset/xubh-q36u)
- [Timely and Effective Care — Hospital](https://data.cms.gov/provider-data/dataset/yv7e-xc69)
- [Timely and Effective Care — State](https://data.cms.gov/provider-data/dataset/apyc-v239)

### Scope

- **States:** Alabama, Louisiana, and Mississippi
- **Hospitals in the measure analysis:** 296
- **Hospital measure records:** 592
- **Unavailable hospital scores:** 129

| Measure | Reporting period | Score unit |
|---|---|---|
| OP_18b | October 1, 2024–September 30, 2025 | Minutes |
| OP_22 | January 1–December 31, 2024 | Percent |

Each analysis record represents one hospital, one measure, and one reporting period.

## Analysis Process

1. Prepared the three datasets in Python while preserving facility identifiers as text.
2. Converted unavailable scores to missing numeric values and retained valid zeros.
3. Checked reporting dates and join keys.
4. Used LEFT JOINs to connect hospital scores with hospital information and matching state benchmarks.
5. Matched benchmarks by state, measure ID, start date, and end date.
6. Analyzed coverage and benchmark comparisons across hospitals, hospital types, ownership groups, and counties/parishes.
7. Reproduced a state summary in a Google Sheets pivot table and chart.
8. Built a Tableau dashboard and checked its results against SQL outputs.
9. Tested the State filter, including recalculation of the top 10 hospital gaps within the selected state.

## Key Findings

### Hospitals above their own state benchmark

These percentages include only hospitals with comparable scores.

| State | ED duration: OP_18b | Left before seen: OP_22 |
|---|---:|---:|
| Alabama | 48.1% | 35.6% |
| Louisiana | 48.3% | 14.8% |
| Mississippi | 44.1% | 16.7% |

### Largest observed benchmark gaps

- **University Medical Center New Orleans:** ED duration of 327 minutes versus Louisiana's 129-minute benchmark, a difference of **198 minutes**.
- **South Sunflower County Hospital:** Left-before-seen score of 14% versus Mississippi's 3% benchmark, a difference of **11 percentage points**.

### Comparable score coverage

| State | OP_18b | OP_22 |
|---|---:|---:|
| Alabama | 90.8% | 83.9% |
| Louisiana | 79.5% | 78.6% |
| Mississippi | 70.1% | 68.0% |

Missing scores limit which hospitals can be included in performance comparisons.

## Recommendations

- Prioritize facility-level review at hospitals with the largest positive benchmark gaps.
- Examine internal patient-flow timestamps, arrival volumes, staffing patterns, and process delays to investigate possible explanations.
- Review left-before-seen patterns by time of day and time to initial assessment before selecting workflow changes.
- Examine reporting footnotes and measure eligibility when investigating unavailable scores.
- Evaluate any subsequent changes using consistent definitions and comparable reporting periods.

These recommendations have not been implemented or evaluated as part of this portfolio project.

## Interpretation and Limitations

- The analysis is observational and does not establish causes or overall hospital quality.
- Each hospital is compared with its own state benchmark. Above-benchmark percentages are not a direct ranking of statewide performance.
- OP_18b and OP_22 cover different reporting periods and are analyzed separately.
- Unavailable comparisons are excluded from above-benchmark percentages and are not treated as zeros.
- Small hospital-type, ownership, and geographic groups require cautious interpretation.
- County/parish results describe hospitals located in those areas, rather than outcomes for all residents.
- Some locations, including East Baton Rouge Parish, did not display on the Tableau map because generated coordinates were missing. Their records remained included in SQL analysis.

## Repository Structure

| Location | Contents |
|---|---|
| `sql/` | Six BigQuery analysis queries |
| `python/` | Data preparation and validation notebook |
| `data/` | Prepared source datasets and joined analysis export |
| `analysis/` | Query-result CSVs and analysis tracker |
| `dashboard/` | Dashboard image |
| `documentation/` | Case study and project workbook |

## Reviewing the Project

Start with the interactive Tableau dashboard and the case study in `documentation/`.

The Python notebook documents preparation. The SQL file contains the six analysis queries, which reference the project's existing BigQuery `ed_analysis` view. The SQL file does not recreate the source tables or analysis view.

Prepared datasets and exported results are included for inspection.

## Author

Toya Coleman
