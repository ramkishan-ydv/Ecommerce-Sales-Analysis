-- Q3.How does shipping cost affect profit margins across different shipping modes?

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
