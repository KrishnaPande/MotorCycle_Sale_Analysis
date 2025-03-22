-- 1️⃣ Which are the top 5 best-selling bike brands in the dataset?
select count(*), brand
from motorcycle_sales
group by 2
order by 1 desc
limit 5

-- * 2️⃣ What is the average price of motorcycles per city tier?

select ROUND(avg(motorcycle_sales."Price (INR)" ), 2), motorcycle_sales."City Tier" 
from motorcycle_sales
group by 2
order by 1
limit 5

-- * 3️⃣ Which brand has the highest average resale value?

select AVG(motorcycle_sales."Resale Price (INR)" ), brand
from motorcycle_sales
group by 2
order by 1 DESC
limit 5

-- * 4️⃣ How do bike prices vary based on engine capacity?

select distinct motorcycle_sales."Engine Capacity (cc)" , round(AVG(motorcycle_sales."Price (INR)" ), 2)
from motorcycle_sales
group by 1
order by 1 desc

-- * 5️⃣ Which states have the highest motorcycle sales volume?

select 
	motorcycle_sales.state,
	count(*),
	concat(round(100.00 * COUNT(*) / SUM(count(*)) over(), 2), '%') as per
from motorcycle_sales
group by 1
order by 2 desc

-- * 6️⃣ What percentage of bikes sold are first-owner vs. second-owner vs. third-owner?
select 
	motorcycle_sales."Fuel Type",
	count(*),
	concat(round(100.00 * COUNT(*) / SUM(count(*)) over(), 2), '%') as per
from motorcycle_sales
group by 1

-- * 7️⃣ Which fuel type (Petrol, Electric, Hybrid) has the highest market share?
select
	ms."Fuel Type", 
	count(*),
	concat(round(100.00 * count(*) / SUM(COUNT(*)) over(), 2), '%') as per
from motorcycle_sales ms
group by 1
order by 2 desc
limit 3



 




