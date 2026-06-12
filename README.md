# Customer Segmentation & Cohort Retention Analysis

## Project Overview
End-to-end customer analytics project on 1M+ e-commerce transactions using 
RFM modelling and cohort retention analysis.

**Tools:** PostgreSQL, Microsoft Excel  
**Dataset:** UCI Online Retail II — 1,067,371 raw transactions  
**Techniques:** Window functions, PERCENT_RANK, DATE_TRUNC, Cohort Analysis

## Project Steps
| File | Description |
|------|-------------|
| 01_data_cleaning.sql | Removed nulls, cancellations, returns → 805,531 clean records |
| 02_rfm_scores.sql | RFM scoring using PERCENT_RANK window functions |
| 03_segment_summary.sql | Revenue & customer count by segment |
| 04_cohort_retention.sql | Monthly cohort retention heatmap |
| 05_country_analysis.sql | Geographic revenue distribution |

## Key Findings
- **Champions** (12.4% of customers) → **50.85% of total revenue**
- **Lost segment** (24.5% of customers) → only 2.2% of revenue
- **65% customer churn** at Month 1 post first purchase
- **Month 11 retention spike** (49.5%) = Christmas seasonality effect
- **UK = 82.98%** of total revenue — high geographic concentration risk
