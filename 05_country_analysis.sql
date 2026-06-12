-- 05_country_analysis.sql
SELECT
    Country,
    COUNT(DISTINCT CustomerID) AS Customer_Count,
    COUNT(DISTINCT Invoice) AS Total_Orders,
    ROUND(SUM(Revenue)::NUMERIC, 2) AS Total_Revenue,
    ROUND(AVG(Revenue)::NUMERIC, 2) AS Avg_Order_Value,
    ROUND(SUM(Revenue) * 100.0 / SUM(SUM(Revenue)) OVER (), 2) AS Pct_of_Revenue
FROM online_retail_clean
GROUP BY Country
ORDER BY Total_Revenue DESC
LIMIT 15;

-- UK vs International split
SELECT
    CASE WHEN Country = 'United Kingdom' THEN 'UK'
         ELSE 'International' END AS Market,
    COUNT(DISTINCT CustomerID) AS Customers,
    ROUND(SUM(Revenue)::NUMERIC, 2) AS Revenue,
    ROUND(SUM(Revenue) * 100.0 / SUM(SUM(Revenue)) OVER (), 2) AS Pct_Revenue
FROM online_retail_clean
GROUP BY
    CASE WHEN Country = 'United Kingdom' THEN 'UK'
         ELSE 'International' END;