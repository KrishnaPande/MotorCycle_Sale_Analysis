select *
from motorcycle_sales ms 

📌 Resale Value & Depreciation Analysis
* 8️⃣ What is the average depreciation rate for each brand?
* 9️⃣ How does the resale value change based on bike age (Manufacturing Year vs. Resale Price)?
* 🔟 Which city tier has the lowest resale value compared to the original price?
* 1️⃣1️⃣ Does insurance status affect the resale price significantly?
* 1️⃣2️⃣ Which bike model retains its value the most over time?

-- * 8️⃣ What is the average depreciation rate for each brand?
-- No Need of SUM and over (partition by) it can be soved simply by group by: 
select avg(100.0 * (1 - (SUM(ms."Resale Price (INR)") / SUM(ms."Price (INR)" )))) over (partition by ms.brand) as ro, ms.brand 
from motorcycle_sales ms
group by 2
order by 1 desc

-- Gives Same result
select AVG(100.0 * (1 - (ms."Resale Price (INR)") / (ms."Price (INR)" ))) as depreciation_price, ms.brand 
from motorcycle_sales ms
group by 2
order by 1 desc

* 9️⃣ How does the resale value change based on bike age (Manufacturing Year vs. Resale Price)?

select ms."Year of Manufacture" , AVG(ms."Resale Price (INR)" )
from motorcycle_sales ms 
group by 1
order by 1

select AVG(ms."Resale Price (INR)" ), ms.brand , ms."Year of Manufacture" 
from motorcycle_sales ms
group by 2, 3
order by 3, 1

1️⃣ Brand Variations – Different brands have different depreciation rates. Some hold value better (e.g., Royal Enfield), while others drop faster.
2️⃣ Market Fluctuations – Resale values are affected by market conditions, not just age. A popular model might have a high resale even after years.
3️⃣ Data Noise – Individual resale values may not follow a perfect downward slope. Outliers (rare models, high demand) can distort the trend.
4️⃣ Grouping Needed – Instead of looking at each brand separately, try averaging across all brands per year to see an overall trend.

-- * 🔟 Which city tier has the lowest resale value compared to the original price?

select ms."City Tier" , AVG(100.0 * (1 - (ms."Resale Price (INR)") / (ms."Price (INR)" ))) as depreciation_price
from motorcycle_sales ms
group by 1
order by 2 asc

* 1️⃣1️⃣ Does insurance status affect the resale price significantly?

* 1️⃣2️⃣ Which bike model retains its value the most over time?



select ms.model, ms.brand, ms."Year of Manufacture" , AVG(100.0 * (1 - (ms."Resale Price (INR)") / (ms."Price (INR)" ))) as depreciation_price
from motorcycle_sales ms 
group by 1, 2, 3
order by 4 asc 


select ms.model, ms.brand, ms."Year of Manufacture" , AVG(100.0 * (1 - (ms."Resale Price (INR)") / (ms."Price (INR)" ))) as depreciation_price
from motorcycle_sales ms 
group by 2, 1, 3
order by 4 asc

SELECT 
    ms.brand, 
    ms.model, 
    AVG(100.0 * (1 - (ms."Resale Price (INR)") / (ms."Price (INR)"))) AS avg_depreciation,
    STDDEV(100.0 * (1 - (ms."Resale Price (INR)") / (ms."Price (INR)"))) AS depreciation_variance
FROM motorcycle_sales ms
GROUP BY ms.brand, ms.model
ORDER BY avg_depreciation ASC;

SELECT ms.brand, 
       AVG(100.0 * (1 - (ms."Resale Price (INR)") / (ms."Price (INR)"))) AS avg_depreciation
FROM motorcycle_sales ms
GROUP BY ms.brand
ORDER BY avg_depreciation ASC;

-- Lower depreciation means the bike retains its value better over time.

-- Lower % depreciation → The bike holds its resale value well.
Higher % depreciation → The bike loses value quickly.

SELECT ms.brand, ms.model, 
       AVG(100.0 * (1 - (ms."Resale Price (INR)") / (ms."Price (INR)"))) AS avg_depreciation
FROM motorcycle_sales ms
GROUP BY ms.brand, ms.model
HAVING AVG(100.0 * (1 - (ms."Resale Price (INR)") / (ms."Price (INR)"))) < 40
ORDER BY avg_depreciation ASC;

SELECT ms.brand, 
       AVG(100.0 * (1 - (ms."Resale Price (INR)") / (ms."Price (INR)"))) AS avg_depreciation,
       STDDEV(100.0 * (1 - (ms."Resale Price (INR)") / (ms."Price (INR)"))) AS depreciation_variance
FROM motorcycle_sales ms
GROUP BY ms.brand
ORDER BY depreciation_variance DESC;










