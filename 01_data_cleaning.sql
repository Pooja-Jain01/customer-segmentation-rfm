-- 01_data_cleaning.sql
CREATE TABLE online_retail_clean AS
SELECT
    Invoice,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    Price,
    SPLIT_PART(CustomerID, '.', 1) AS CustomerID,
    Country,
    ROUND((Quantity * Price)::NUMERIC, 2) AS Revenue
FROM online_retail
WHERE
    CustomerID IS NOT NULL
    AND CustomerID != ''
    AND Quantity > 0
    AND Price > 0
    AND Invoice NOT LIKE 'C%';
