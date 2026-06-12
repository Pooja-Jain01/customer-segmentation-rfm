-- 03_segment_summary.sql
SELECT
    Segment,
    COUNT(CustomerID) AS Customer_Count,
    ROUND(COUNT(CustomerID) * 100.0 / SUM(COUNT(CustomerID))
          OVER (), 2) AS Pct_of_Customers,
    ROUND(AVG(Monetary), 2) AS Avg_Revenue,
    ROUND(AVG(Frequency), 1) AS Avg_Orders,
    ROUND(SUM(Monetary), 2) AS Total_Revenue,
    ROUND(SUM(Monetary) * 100.0 / SUM(SUM(Monetary)) OVER (), 2) AS Pct_of_Revenue
FROM rfm_segments
GROUP BY Segment
ORDER BY Total_Revenue DESC;