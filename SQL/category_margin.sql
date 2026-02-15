-- Q1. Which product categories are performing below and above the overall business profit margin?

  SELECT
    s.Category AS category,
    ROUND(overall_pm.overall_profit_margin_pct, 2) AS overall_profit_margin_pct,
    ROUND((SUM(s.Profit) / SUM(s.Sales)) * 100, 2) AS category_profit_margin_pct,
    CASE
        WHEN (SUM(s.Profit) / SUM(s.Sales)) * 100 
             >= overall_pm.overall_profit_margin_pct
        THEN 'Above Average'
        ELSE 'Below Average'
    END AS profitability_status
FROM sales AS s
CROSS JOIN (
    -- Overall business profit margin
    SELECT
        (SUM(Profit) / SUM(Sales)) * 100 AS overall_profit_margin_pct
    FROM sales
) AS overall_pm
GROUP BY
    s.Category,
    overall_pm.overall_profit_margin_pct
ORDER BY
    category_profit_margin_pct;
