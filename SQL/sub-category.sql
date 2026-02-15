-- Q2. Which sub-categories are causing margin leakage within low-performing categories?

SELECT 
    s.sub_category,
    b.net_profit_margin,
    ROUND((SUM(s.profit) / SUM(s.sales)) * 100) AS profit_margin,
    CASE 
        WHEN ROUND((SUM(s.profit) / SUM(s.sales)) * 100) >= b.net_profit_margin
        THEN 'Profitable'
        ELSE 'Less Profitable'
    END AS profitability
FROM sales AS s
CROSS JOIN (
    SELECT ROUND((SUM(profit) / SUM(sales)) * 100) AS net_profit_margin
    FROM sales
    where category="Furniture"
) AS b
GROUP BY s.sub_category, b.net_profit_margin
order by profit_margin;
