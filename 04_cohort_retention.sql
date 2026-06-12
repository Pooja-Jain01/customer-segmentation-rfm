-- 04_cohort_retention.sql

-- Step 4a: Cohort month per customer
CREATE TABLE customer_cohorts AS
SELECT
    CustomerID,
    DATE_TRUNC('month', MIN(InvoiceDate))::DATE AS CohortMonth
FROM online_retail_clean
GROUP BY CustomerID;

-- Step 4b: Tag transactions with cohort + month number
CREATE TABLE cohort_activity AS
SELECT
    o.CustomerID,
    c.CohortMonth,
    DATE_TRUNC('month', o.InvoiceDate)::DATE AS OrderMonth,
    (DATE_PART('year', DATE_TRUNC('month', o.InvoiceDate)) -
     DATE_PART('year', c.CohortMonth)) * 12 +
    (DATE_PART('month', DATE_TRUNC('month', o.InvoiceDate)) -
     DATE_PART('month', c.CohortMonth)) AS MonthNumber
FROM online_retail_clean o
JOIN customer_cohorts c ON o.CustomerID = c.CustomerID;

-- Step 4c: Count active customers per cohort per month
CREATE TABLE cohort_counts AS
SELECT
    CohortMonth,
    MonthNumber,
    COUNT(DISTINCT CustomerID) AS Active_Customers
FROM cohort_activity
GROUP BY CohortMonth, MonthNumber
ORDER BY CohortMonth, MonthNumber;

-- Step 4d: Retention percentage
SELECT
    c.CohortMonth,
    c.MonthNumber,
    c.Active_Customers,
    base.Active_Customers AS Cohort_Size,
    ROUND(c.Active_Customers * 100.0 / base.Active_Customers, 1) AS Retention_Pct
FROM cohort_counts c
JOIN cohort_counts base
    ON c.CohortMonth = base.CohortMonth
    AND base.MonthNumber = 0
ORDER BY c.CohortMonth, c.MonthNumber;