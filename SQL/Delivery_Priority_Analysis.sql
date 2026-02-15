-- Q4. Does longer delivery time negatively impact profitability or priority orders?

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
