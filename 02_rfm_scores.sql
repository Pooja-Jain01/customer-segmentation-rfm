-- 02_rfm_scores.sql

-- Step 2a: Raw RFM values
CREATE TABLE rfm_raw AS
SELECT
    CustomerID,
    Country,
    MAX(InvoiceDate) AS last_purchase_date,
    DATE_PART('day',
        (SELECT MAX(InvoiceDate) FROM online_retail_clean)
        - MAX(InvoiceDate)
    )::INT AS Recency,
    COUNT(DISTINCT Invoice) AS Frequency,
    ROUND(SUM(Revenue)::NUMERIC, 2) AS Monetary
FROM online_retail_clean
GROUP BY CustomerID, Country;

-- Step 2b: Score using PERCENT_RANK
CREATE TABLE rfm_scored AS
WITH percentiles AS (
    SELECT
        CustomerID, Country, Recency, Frequency, Monetary,
        PERCENT_RANK() OVER (ORDER BY Recency ASC)    AS r_rank,
        PERCENT_RANK() OVER (ORDER BY Frequency ASC)  AS f_rank,
        PERCENT_RANK() OVER (ORDER BY Monetary ASC)   AS m_rank
    FROM rfm_raw
)
SELECT
    CustomerID, Country, Recency, Frequency, Monetary,
    CASE
        WHEN r_rank <= 0.20 THEN 5
        WHEN r_rank <= 0.40 THEN 4
        WHEN r_rank <= 0.60 THEN 3
        WHEN r_rank <= 0.80 THEN 2
        ELSE 1
    END AS R_Score,
    CASE
        WHEN f_rank <= 0.20 THEN 1
        WHEN f_rank <= 0.40 THEN 2
        WHEN f_rank <= 0.60 THEN 3
        WHEN f_rank <= 0.80 THEN 4
        ELSE 5
    END AS F_Score,
    CASE
        WHEN m_rank <= 0.20 THEN 1
        WHEN m_rank <= 0.40 THEN 2
        WHEN m_rank <= 0.60 THEN 3
        WHEN m_rank <= 0.80 THEN 4
        ELSE 5
    END AS M_Score
FROM percentiles;

-- Step 2c: Segment labels
CREATE TABLE rfm_segments AS
SELECT
    CustomerID, Country, Recency, Frequency, Monetary,
    R_Score, F_Score, M_Score,
    CASE
        WHEN R_Score = 5 AND F_Score >= 4 AND M_Score >= 4 THEN 'Champions'
        WHEN R_Score >= 4 AND F_Score >= 3                 THEN 'Loyal Customers'
        WHEN R_Score >= 3 AND F_Score <= 2                 THEN 'Recent Customers'
        WHEN R_Score >= 3 AND M_Score >= 3                 THEN 'Potential Loyalists'
        WHEN R_Score <= 2 AND F_Score >= 3                 THEN 'At Risk'
        WHEN R_Score <= 2 AND F_Score <= 2 AND M_Score >= 3 THEN 'Cant Lose Them'
        ELSE 'Lost'
    END AS Segment
FROM rfm_scored;