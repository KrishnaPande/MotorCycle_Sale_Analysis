📌 Geographic & City-Tier Trends
1️⃣7️⃣ Which city tier has the highest percentage of second-hand bike sales?
1️⃣8️⃣ Which states have the highest number of high-engine capacity (>500cc) motorcycles?
1️⃣9️⃣ How do fuel type preferences vary by city tier?
2️⃣0️⃣ Which metro cities have the highest percentage of premium bikes (₹1,00,000+)?

### 2️⃣1️⃣ Can we predict the expected resale price of a bike based on brand, mileage, and owner type?

select *
from motorcycle_sales ms 

### 2️⃣1️⃣ Can we predict the expected resale price of a bike based on brand, mileage, and owner type?

select 
	ms.brand,
	ms."Owner Type", 
	width_bucket(ms."Mileage (km/l)" , 10, 60, 5) AS mileage_range,
	avg(ms."Resale Price (INR)") as expected_resale_price
from motorcycle_sales ms
group by 1, 2, 3
order by 1, 3

### 2️⃣2️⃣ Which attributes (price, engine capacity, mileage) have the highest impact on resale price?

SELECT corr("Price (INR)", "Resale Price (INR)") AS price_corr,
       corr("Engine Capacity (cc)", "Resale Price (INR)") AS engine_capacity_corr,
       corr(motorcycle_sales."Mileage (km/l)", "Resale Price (INR)") AS mileage_corr
FROM motorcycle_sales;

WITH correlation_analysis AS (
    SELECT 
        corr("Price (INR)", "Resale Price (INR)") AS price_corr,
        corr("Mileage (km/l)", "Resale Price (INR)") AS mileage_corr,
        corr("Engine Capacity (cc)", "Resale Price (INR)") AS engine_corr
    FROM motorcycle_sales
),
= AS (
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
    p.price_slope * ms."Price (INR)" + p.price_intercept AS predicted_resale_price_price,
    p.mileage_slope * ms."Mileage (km/l)" + p.mileage_intercept AS predicted_resale_price_mileage
FROM price_model p
JOIN motorcycle_sales ms ON p.brand = ms.brand AND p."Owner Type" = ms."Owner Type"
ORDER BY 1, 3;


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

Some brands (like Bajaj and Kawasaki) show negative price slopes, indicating heavy depreciation.
Certain motorcycles (e.g., Hero, Yamaha) have higher mileage slopes, meaning better mileage contributes positively to resale value.
Higher mileage_range values are associated with lower depreciation, likely because fuel efficiency is a major selling point.

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



