SELECT 	ms.brand, 
		"Owner Type", 
		width_bucket(ms."Mileage (km/l)" , 10, 60, 5) AS mileage_range, 
       	AVG("Resale Price (INR)") AS expected_resale_price
FROM motorcycle_sales ms
GROUP BY ms.brand, "Owner Type", mileage_range
ORDER BY ms.brand, mileage_range;



SELECT 
        ms.brand,
        ms."Owner Type", 
        width_bucket(ms."Mileage (km/l)", 10, 60, 5) AS mileage_range,
        regr_slope(ms."Resale Price (INR)", ms."Price (INR)") AS price_slope,
        regr_intercept(ms."Resale Price (INR)", ms."Price (INR)") AS price_intercept,
        regr_slope(ms."Resale Price (INR)", ms."Mileage (km/l)") AS mileage_slope,
        regr_intercept(ms."Resale Price (INR)", ms."Mileage (km/l)") AS mileage_intercept
FROM motorcycle_sales ms
GROUP BY 1, 2, 3

SELECT corr("Price (INR)", "Resale Price (INR)") AS price_corr,
       corr("Engine Capacity (cc)", "Resale Price (INR)") AS engine_capacity_corr,
       corr(ms."Mileage (km/l)", ms."Resale Price (INR)") AS mileage_corr
FROM motorcycle_sales ms;


WITH correlation_analysis AS (
    SELECT 
        corr("Price (INR)", "Resale Price (INR)") AS price_corr,
        corr("Mileage (km/l)", "Resale Price (INR)") AS mileage_corr,
        corr("Engine Capacity (cc)", "Resale Price (INR)") AS engine_corr
    FROM motorcycle_sales
),
price_model AS (
    SELECT 
        ms.brand,
        ms."Owner Type", 
        width_bucket(ms."Mileage (km/l)", 10, 60, 5) AS mileage_range,
        regr_slope(ms."Resale Price (INR)", ms."Price (INR)") AS price_slope,
        regr_intercept(ms."Resale Price (INR)", ms."Price (INR)") AS price_intercept,
        regr_slope(ms."Resale Price (INR)", ms."Mileage (km/l)") AS mileage_slope,
        regr_intercept(ms."Resale Price (INR)", ms."Mileage (km/l)") AS mileage_intercept
    FROM motorcycle_sales ms
    GROUP BY 1, 2, 3
)
SELECT 
    p.brand,
    p."Owner Type",
    p.mileage_range,
    p.price_slope * ms."Price (INR)" + p.price_intercept AS predicted_resale_price_price
FROM price_model p
JOIN motorcycle_sales ms ON p.brand = ms.brand AND p."Owner Type" = ms."Owner Type"
ORDER BY 1, 3;