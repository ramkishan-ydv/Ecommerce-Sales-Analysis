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

-- Q3. How does shipping cost affect profit margins across different shipping modes?

WITH order_priority_cte AS (
    SELECT
        order_priority AS order_priority,
        ROUND(AVG(shipment_days)) AS avg_shipment_days,
        ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_pct
    FROM sales
    GROUP BY order_priority
)

SELECT
    order_priority,
    avg_shipment_days,
    profit_margin_pct,
    DENSE_RANK() OVER (ORDER BY avg_shipment_days DESC) AS shipment_days_rank,
    DENSE_RANK() OVER (ORDER BY profit_margin_pct ASC) AS profit_margin_rank
FROM order_priority_cte;

-- Q4. Does longer delivery time negatively impact profitability or priority orders?

WITH ship_mode_summary AS (
    SELECT
        ship_mode,
        ROUND(SUM(shipment_days) / COUNT(shipment_days)) AS avg_days,
        ROUND((SUM(shipping_cost) / SUM(sales)) * 100, 2) AS shipping_cost_pct,
        ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin
    FROM sales
    GROUP BY ship_mode
)

SELECT
    ship_mode,
    avg_days,
    shipping_cost_pct,
    profit_margin,
    DENSE_RANK() OVER (ORDER BY shipping_cost_pct DESC) AS shipping_cost_rank,
    DENSE_RANK() OVER (ORDER BY profit_margin ASC) AS profit_margin_rank
FROM ship_mode_summary
ORDER BY shipping_cost_rank;

