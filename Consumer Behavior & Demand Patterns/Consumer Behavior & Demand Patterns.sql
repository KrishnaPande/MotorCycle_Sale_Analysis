📌 Consumer Behavior & Demand Patterns
-- 1️⃣3️⃣ What is the most common daily distance range for each brand's buyers?
-- 1️⃣4️⃣ How do different owner types affect the selling price?
-- 1️⃣5️⃣ Do individual sellers price their bikes higher than dealers?
-- 1️⃣6️⃣ Which seller type (Dealer vs. Individual) has a higher percentage of expired insurance sales?

-- 1️⃣3️⃣ What is the most common daily distance range for each brand's buyers?

select *
from motorcycle_sales ms

select AVG(ms."Avg Daily Distance (km)") as av_daily, ms.brand 
from motorcycle_sales ms
group by 2

-- 1️⃣4️⃣ How do different owner types affect the selling price?

SELECT "Owner Type", AVG("Price (INR)") AS avg_price
FROM motorcycle_sales
GROUP BY "Owner Type"
ORDER BY avg_price DESC;

-- 1️⃣5️⃣ Do Individual Sellers Price Higher than Dealers?

SELECT "Seller Type", AVG("Price (INR)") AS avg_price
FROM motorcycle_sales
GROUP BY "Seller Type";

--1️⃣6️⃣ Which Seller Type Has More Expired Insurance Sales?

SELECT "Seller Type",
       COUNT(*) AS total_sales,
       SUM(CASE WHEN "Insurance Status" = 'Expired' THEN 1 ELSE 0 END) AS expired_insurance_sales,
       100.0 * SUM(CASE WHEN "Insurance Status" = 'Expired' THEN 1 ELSE 0 END) / COUNT(*) AS percentage_expired
FROM motorcycle_sales
GROUP BY "Seller Type";

SELECT ms."City Tier", 
       COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS percentage_sales
FROM motorcycle_sales ms
WHERE ms."Owner Type" IN ('Second', 'Third')
GROUP BY ms."City Tier"
ORDER BY 2 DESC;

SELECT ms.state , COUNT(*) AS high_cc_bikes
FROM motorcycle_sales ms
WHERE ms."Engine Capacity (cc)" > 500
GROUP BY ms.state
ORDER BY high_cc_bikes DESC;

select *
from motorcycle_sales ms 

SELECT ms."City Tier", ms."Fuel Type", COUNT(*) AS fuel_type_count
FROM motorcycle_sales ms
GROUP BY ms."City Tier", ms."Fuel Type"
ORDER BY fuel_type_count desc, 1;

SELECT ms."City Tier", ms."Fuel Type", COUNT(*) AS fuel_type_count
FROM motorcycle_sales ms
GROUP BY ms."City Tier", ms."Fuel Type"
ORDER BY ms."City Tier", fuel_type_count DESC;

SELECT 
	ms.state , 
	COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS premium_bike_percentage
FROM motorcycle_sales ms
WHERE ms."City Tier" = 'Metro' AND ms."Price (INR)" >= 100000
GROUP BY 1
ORDER BY 2 DESC;

SELECT "Brand", width_bucket("Avg Daily Distance (km)", 0, 80, 5) AS distance_range,
       COUNT(*) AS total_buyers
FROM motorcycle_sales
GROUP BY "Brand", distance_range
ORDER BY "Brand", total_buyers DESC;

SELECT ms.brand , width_bucket("Avg Daily Distance (km)", 0, 80, 5) AS distance_range,
       COUNT(*) AS total_buyers
FROM motorcycle_sales ms
GROUP BY 1, 2
ORDER BY 1, 3 DESC;

SELECT "Owner Type", AVG("Price (INR)") AS avg_price
FROM motorcycle_sales
GROUP BY "Owner Type"
ORDER BY avg_price DESC;


SELECT "Seller Type", COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS expired_insurance_percentage
FROM motorcycle_sales
WHERE "Insurance Status" = 'Expired'
GROUP BY "Seller Type"
ORDER BY 2 DESC;

select 
    avg(100.0 * (1 - (ms."Resale Price (INR)") / (ms."Price (INR)" ))) as depreciation_price, 
    ms.brand 
from motorcycle_sales ms
group by 2
order by 1 desc
