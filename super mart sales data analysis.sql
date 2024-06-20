Create database project3;
use project3;

show tables;
select * from order_details_v1;
select * from producthierarchy;
select * from store_cities;

#Table 1: This table presents the status of Category Level View:
select 
category,
Sum(case when order_date = '2024-04-06' then orders else 0 end) as yday_orders,
sum(case when order_date between '2024-04-01' and '2024-04-06' then orders else 0 end) as mtd_orders,
Sum(case when order_date = '2024-04-06' then gmv else 0 end) as yday_gmv,
Sum(case when order_date = '2024-04-06' then gmv else 0 end)/1.18 as yday_revenue,
sum(case when order_date between '2024-04-01' and '2024-04-06' then gmv else 0 end) as mtd_gmv,
sum(case when order_date between '2024-04-01' and '2024-04-06' then gmv else 0 end)/1.18 as mtd_Revenue,
coalesce(sum(case when x.order_date ='2024-04-06' then Customers end),0) as Yesterday_Customers,
Sum(case when order_date = datediff('2024-04-05','2024-04-04')then orders else 0 end) as yday_growth,
sum(case when x.order_date between '2024-04-01' and '2024-04-06' then Customers end) as MTD_New_Customers,
sum(case when x.order_date between '2024-04-01' and '2024-04-06' then Customers end) as MTD_New_Customers
from
(select
y.category,
x.order_date,
count(distinct x.order_id) as orders,
sum(x.selling_price) as gmv,
count(distinct x.customer_id) as customers
from order_details_v1 x
join producthierarchy y on x.product_id = y.product_id
group by 1,2
)x
group by 1;
--	----------------------------------------------------------------------------------------------------------------------------------------------------------
--	Table 2: This table presents the status of Top 20 Brand Level View:

SELECT 
    product_id,
    SUBSTRING_INDEX(product_name, '-', 1) AS product_name,
    SUBSTRING_INDEX(product_name, '-', 1) AS brand_level,
Sum(case when order_date = date_add(curdate(), interval -1 day) then orders else 0 end) as yday_orders,
sum(case when order_date between '2024-04-01' and '2024-04-06' then orders else 0 end) as mtd_orders,
Sum(case when order_date between '2024-03-01' and '2024-03-06' then orders else 0 end) as lmtd_orders,
Sum(case when order_date between '2024-03-01' and '2024-03-01' then orders else 0 end) as lm_orders,
Sum(case when order_date between '2023-04-01' and '2024-03-31' then orders else 0 end) as YTD_orders,
sum(case when x.order_date between '2024-04-01' and '2024-04-06' then Customers end) as MTD_New_Customers,
sum(case when x.order_date between '2024-04-01' and '2024-04-06' then Customers end) as MTD_New_Customers
FROM
    (SELECT 
        y.product_id,
        y.category,
        SUBSTRING_INDEX(y.product, '-', 1) AS product_name,
        x.order_date,
        count(distinct x.order_id) as orders,
sum(x.selling_price) as gmv,
count(distinct x.customer_id) as customers
from order_details_v1 x
join producthierarchy y on x.product_id = y.product_id
group by 1,2,3,4
)x
group by 1,2
limit 20;
--	-------------------------------------------------------------------------------------------------------------------------------------------------------	
--	Table 3: This table presents the status of Top 30 Product Level View:

SELECT 
    SUBSTRING_INDEX(product_name, '-', 1) AS brand_level,
    product_id,
    SUBSTRING_INDEX(product_name, '-', 1) AS product_name,
    
Sum(case when order_date = date_add(curdate(), interval -1 day) then orders else 0 end) as yday_orders,
sum(case when order_date between '2024-04-01' and '2024-04-06' then orders else 0 end) as mtd_orders,
Sum(case when order_date between '2024-03-01' and '2024-03-06' then orders else 0 end) as lmtd_orders,
Sum(case when order_date between '2024-03-01' and '2024-03-01' then orders else 0 end) as lm_orders,
Sum(case when order_date between '2023-04-01' and '2024-03-31' then orders else 0 end) as YTD_orders,
sum(case when x.order_date between '2024-04-01' and '2024-04-06' then Customers end) as MTD_New_Customers,
sum(case when x.order_date between '2024-04-01' and '2024-04-06' then Customers end) as MTD_New_Customers
FROM
    (SELECT 
        y.product_id,
        y.category,
        SUBSTRING_INDEX(y.product, '-', 1) AS product_name,
        x.order_date,
        count(distinct x.order_id) as orders,
sum(x.selling_price) as gmv,
count(distinct x.customer_id) as customers
from order_details_v1 x
join producthierarchy y on x.product_id = y.product_id
group by 1,2,3,4
)x
group by 1,2
limit 30;
--	----------------------------------------------------------------------------------------------------------------------------------------------------------
--	Table 4: This table presents the status of Top 20 State Level View:

select 
state,
Sum(case when order_date = date_add(curdate(), interval -1 day) then orders else 0 end) as yday_orders,
sum(case when order_date between '2024-04-01' and '2024-04-06' then orders else 0 end) as mtd_orders,
Sum(case when order_date between '2024-03-01' and '2024-03-06' then orders else 0 end) as lmtd_orders,
Sum(case when order_date between '2024-03-01' and '2024-03-01' then orders else 0 end) as lm_orders,
Sum(case when order_date between '2023-04-01' and '2024-03-31' then orders else 0 end) as YTD_orders,
sum(case when order_date between '2024-04-01' and '2024-04-06' then Customers end) as MTD_New_Customers,
sum(case when order_date between '2024-04-01' and '2024-04-06' then Customers end) as MTD_New_Customers 
from
(select 
z.state,
x.order_date,
count(distinct x.order_id) as orders,
sum(distinct x.selling_price)*1.18 as txn,
sum(distinct x.selling_price) as gmv,
sum(distinct x.selling_price)/1.18 as revenue,
count(distinct x.customer_id) as customers,
count(distinct a.customer_id) as new_customers,
count(distinct x.store_id) as live_stores
from order_details_v1 x
join store_cities z on x.store_id=z.store_id
join 
( select customer_id, rn as new_customers,order_date from (select order_id,order_date,customer_id, rank() over (partition by customer_id order by order_date) rn 
 from order_details_v1) x
 where rn=1) a on x.customer_id=a.customer_id
 group by 1,2) t
 group by 1
 order by state desc
 limit 20;
 
--	Table 5: This table presents the status of Top 20 City and State Level View:

select 
state,
City,
Sum(case when order_date = date_add(curdate(), interval -1 day) then orders else 0 end) as yday_orders,
sum(case when order_date between '2024-04-01' and '2024-04-06' then orders else 0 end) as mtd_orders,
Sum(case when order_date between '2024-03-01' and '2024-03-06' then orders else 0 end) as lmtd_orders,
Sum(case when order_date between '2024-03-01' and '2024-03-01' then orders else 0 end) as lm_orders,
Sum(case when order_date between '2023-04-01' and '2024-03-31' then orders else 0 end) as YTD_orders,
sum(case when order_date between '2024-04-01' and '2024-04-06' then Customers end) as MTD_New_Customers,
sum(case when order_date between '2024-04-01' and '2024-04-06' then Customers end) as MTD_New_Customers 
from
(select 
z.state,
z.city,
x.order_date,
count(distinct x.order_id) as orders,
sum(distinct x.selling_price)*1.18 as txn,
sum(distinct x.selling_price) as gmv,
sum(distinct x.selling_price)/1.18 as revenue,
count(distinct x.customer_id) as customers,
count(distinct a.customer_id) as new_customers,
count(distinct x.store_id) as live_stores
from order_details_v1 x
join store_cities z on x.store_id=z.store_id
join 
( select customer_id, rn as new_customers,order_date from (select order_id,order_date,customer_id, rank() over (partition by customer_id order by order_date) rn 
 from order_details_v1) x
 where rn=1) a on x.customer_id=a.customer_id
 group by 1,2,3) t
 group by 1,2
 order by state ,city asc
 limit 20;

--	# 6
select 
storetype_id as store_type,
Sum(case when order_date = date_add(curdate(), interval -1 day) then orders else 0 end) as yday_orders,
sum(case when order_date between '2024-04-01' and '2024-04-06' then orders else 0 end) as mtd_orders,
Sum(case when order_date between '2024-03-01' and '2024-03-06' then orders else 0 end) as lmtd_orders,
Sum(case when order_date between '2024-03-01' and '2024-03-01' then orders else 0 end) as lm_orders,
Sum(case when order_date between '2023-04-01' and '2024-03-31' then orders else 0 end) as YTD_orders,
sum(case when order_date between '2024-04-01' and '2024-04-06' then Customers end) as MTD_New_Customers,
sum(case when order_date between '2024-04-01' and '2024-04-06' then Customers end) as MTD_New_Customers 
from
(select 
z.storetype_id,
x.order_date,
count(distinct x.order_id) as orders,
sum(distinct x.selling_price)*1.18 as txn,
sum(distinct x.selling_price) as gmv,
sum(distinct x.selling_price)/1.18 as revenue,
count(distinct x.customer_id) as customers,
count(distinct a.customer_id) as new_customers,
count(distinct x.store_id) as live_stores
from order_details_v1 x
join store_cities z on x.store_id=z.store_id
join 
( select customer_id, rn as new_customers,order_date from (select order_id,order_date,customer_id, rank() over (partition by customer_id order by order_date) rn 
 from order_details_v1) x
 where rn=1) a on x.customer_id=a.customer_id
 group by 1,2) t
 group by 1
 order by storetype_id desc
 limit 20;

--	#7 
select 
store_id,
Sum(case when order_date = date_add(curdate(), interval -1 day) then orders else 0 end) as yday_orders,
sum(case when order_date between '2024-04-01' and '2024-04-06' then orders else 0 end) as mtd_orders,
Sum(case when order_date between '2024-03-01' and '2024-03-06' then orders else 0 end) as lmtd_orders,
Sum(case when order_date between '2024-03-01' and '2024-03-01' then orders else 0 end) as lm_orders,
Sum(case when order_date between '2023-04-01' and '2024-03-31' then orders else 0 end) as YTD_orders,
sum(case when order_date between '2024-04-01' and '2024-04-06' then Customers end) as MTD_New_Customers,
sum(case when order_date between '2024-04-01' and '2024-04-06' then Customers end) as MTD_New_Customers 
from
(
select 
z.store_id,
x.order_date,
count(distinct x.order_id) as orders,
sum(distinct x.selling_price)*1.18 as txn,
sum(distinct x.selling_price) as gmv,
sum(distinct x.selling_price)/1.18 as revenue,
count(distinct x.customer_id) as customers,
count(distinct a.customer_id) as new_customers,
count(distinct x.store_id) as live_stores
from order_details_v1 x
join store_cities z on x.store_id=z.store_id
join 
(
 select customer_id, rn as new_customers,order_date from (select order_id,order_date,customer_id, rank() over (partition by customer_id order by order_date) rn 
 from order_details_v1) x
 where rn=1) a on x.customer_id=a.customer_id
 group by 1,2) t
 group by 1
 order by store_id desc
 limit 20;
 
--	Table 8: This table presents the status of MTD Orders View:

select 
category,
sum(case when order_date between '2024-04-01' and '2024-04-06' then orders else 0 end) as mtd_orders,
sum(case when x.order_date between '2024-04-01' and '2024-04-06' then Customers end) as MTD_New_Customers,
sum(case when x.order_date between '2024-04-01' and '2024-04-06' then Customers end) as MTD_New_Customers,
sum(case when order_date between '2024-04-01' and '2024-04-06' then gmv else 0 end) as mtd_gmv
from
(select
y.category,
x.order_date,
count(distinct x.order_id) as orders,
sum(x.selling_price) as gmv,
count(distinct x.customer_id) as customers
from order_details_v1 x
join producthierarchy y on x.product_id = y.product_id
group by 1,2
)x
group by 1;

--	Table 8: This table presents the status of MTD Orders View:

select 
category,

coalesce(sum(case when x.order_date ='2024-04-06' then Customers end),0) as Yesterday_Customers,
sum(case when x.order_date between '2024-04-01' and '2024-04-06' then Customers end) as MTD_New_Customers
from
(select
y.category,
x.order_date,
count(distinct x.order_id) as orders,
sum(x.selling_price) as gmv,
count(distinct x.customer_id) as customers
from order_details_v1 x
join producthierarchy y on x.product_id = y.product_id
group by 1,2
)x
group by 1;

--	Table 10: This table presents the Unique Customers Retention %:

select
y.category,
y.product,
x.order_date,
x.order_id,
x.selling_price,
X.customer_id,
x.product_id,
x.Store_id
from order_details_v1 x
join producthierarchy y on x.product_id = y.product_id
where order_date between '2024-04-01'and '2024-04-06';
--	-------------------------------------------------------------------------------------------------------------
select 
monthname("2023-01-31") as month,
sum(case when x.order_date between '2023-01-01' and '2023-12-31' then Customers end) as Total_customer,
sum(case when x.order_date between '2023-01-01' and '2023-01-31' then Customers end) as M1,
sum(case when x.order_date between '2023-02-01' and '2023-02-28' then Customers end) as M2,
sum(case when x.order_date between '2023-03-01' and '2023-03-31' then Customers end) as M3,
sum(case when x.order_date between '2023-04-01' and '2023-04-31' then Customers end) as M4,
sum(case when x.order_date between '2023-05-01' and '2023-05-31' then Customers end) as M5,
sum(case when x.order_date between '2023-06-01' and '2023-06-31' then Customers end) as M6,
sum(case when x.order_date between '2023-07-01' and '2023-07-31' then Customers end) as M7,
sum(case when x.order_date between '2023-08-01' and '2023-08-31' then Customers end) as M8,
sum(case when x.order_date between '2023-09-01' and '2023-09-31' then Customers end) as M9,
sum(case when x.order_date between '2023-10-01' and '2023-10-31' then Customers end) as M10,
sum(case when x.order_date between '2023-11-01' and '2023-11-31' then Customers end) as M11,
sum(case when x.order_date between '2023-12-01' and '2023-12-31' then Customers end) as M12

from
(select
x.order_date,
count(distinct x.customer_id) as customers
from order_details_v1 x
join producthierarchy y on x.product_id = y.product_id
group by 1
)x;
--	-----------------------------------------------------------------------------------------------------------------------------
select 
monthname("2023-02-28") as month,
sum(case when x.order_date between '2023-02-01' and '2023-12-31' then Customers end) as Total_customer,
sum(case when x.order_date between '2023-02-01' and '2023-02-28' then Customers end) as M1,
sum(case when x.order_date between '2023-03-01' and '2023-03-31' then Customers end) as M2,
sum(case when x.order_date between '2023-04-01' and '2023-04-31' then Customers end) as M3,
sum(case when x.order_date between '2023-05-01' and '2023-05-31' then Customers end) as M4,
sum(case when x.order_date between '2023-06-01' and '2023-06-31' then Customers end) as M5,
sum(case when x.order_date between '2023-07-01' and '2023-07-31' then Customers end) as M6,
sum(case when x.order_date between '2023-08-01' and '2023-08-31' then Customers end) as M7,
sum(case when x.order_date between '2023-09-01' and '2023-09-31' then Customers end) as M8,
sum(case when x.order_date between '2023-10-01' and '2023-10-31' then Customers end) as M9,
sum(case when x.order_date between '2023-11-01' and '2023-11-31' then Customers end) as M10,
sum(case when x.order_date between '2023-12-01' and '2023-12-31' then Customers end) as M11

from
(select
x.order_date,
count(distinct x.customer_id) as customers
from order_details_v1 x
join producthierarchy y on x.product_id = y.product_id
group by 1
)x;
--	--------------------------------------------------------------------------------------------------------------------------------
select 
monthname("2023-03-31") as month,
sum(case when x.order_date between '2023-03-01' and '2023-12-31' then Customers end) as Total_customer,
sum(case when x.order_date between '2023-03-01' and '2023-03-31' then Customers end) as M1,
sum(case when x.order_date between '2023-04-01' and '2023-04-31' then Customers end) as M2,
sum(case when x.order_date between '2023-05-01' and '2023-05-31' then Customers end) as M3,
sum(case when x.order_date between '2023-06-01' and '2023-06-31' then Customers end) as M4,
sum(case when x.order_date between '2023-07-01' and '2023-07-31' then Customers end) as M5,
sum(case when x.order_date between '2023-08-01' and '2023-08-31' then Customers end) as M6,
sum(case when x.order_date between '2023-09-01' and '2023-09-31' then Customers end) as M7,
sum(case when x.order_date between '2023-10-01' and '2023-10-31' then Customers end) as M8,
sum(case when x.order_date between '2023-11-01' and '2023-11-31' then Customers end) as M9,
sum(case when x.order_date between '2023-12-01' and '2023-12-31' then Customers end) as M10

from
(select
x.order_date,
count(distinct x.customer_id) as customers
from order_details_v1 x
join producthierarchy y on x.product_id = y.product_id
group by 1
)x;

--	Table 11: This table presents the New Customers Retention %:
select 
monthname("2023-01-31") as month,
sum(case when x.order_date between '2023-01-01' and '2023-12-31' then Customers end) as Total_customer,
coalesce(sum(case when (order_date=current_date()-interval 1 day) then customers end),0) as new_customers,
sum(case when x.order_date between '2023-01-01' and '2023-01-31' then Customers end) as M1,
sum(case when x.order_date between '2023-02-01' and '2023-02-28' then Customers end) as M2,
sum(case when x.order_date between '2023-03-01' and '2023-03-31' then Customers end) as M3,
sum(case when x.order_date between '2023-04-01' and '2023-04-31' then Customers end) as M4,
sum(case when x.order_date between '2023-05-01' and '2023-05-31' then Customers end) as M5,
sum(case when x.order_date between '2023-06-01' and '2023-06-31' then Customers end) as M6,
sum(case when x.order_date between '2023-07-01' and '2023-07-31' then Customers end) as M7,
sum(case when x.order_date between '2023-08-01' and '2023-08-31' then Customers end) as M8,
sum(case when x.order_date between '2023-09-01' and '2023-09-31' then Customers end) as M9,
sum(case when x.order_date between '2023-10-01' and '2023-10-31' then Customers end) as M10,
sum(case when x.order_date between '2023-11-01' and '2023-11-31' then Customers end) as M11,
sum(case when x.order_date between '2023-12-01' and '2023-12-31' then Customers end) as M12

from
(select
x.order_date,
y.category,
count(distinct x.customer_id) as customers
from order_details_v1 x
join producthierarchy y on x.product_id = y.product_id
group by 1,2
)x;


--	-------------------------------------------------------------------------------------------------------------------------
Select
monthname("2023-02-28") as month,
sum(case when x.order_date between '2023-01-01' and '2023-12-31' then Customers end) as Total_customer,
coalesce(sum(case when (order_date=current_date()-interval 1 day) then customers end),0) as new_customers,
sum(case when x.order_date between '2023-02-01' and '2023-02-28' then Customers end) as M1,
sum(case when x.order_date between '2023-03-01' and '2023-03-31' then Customers end) as M2,
sum(case when x.order_date between '2023-04-01' and '2023-04-31' then Customers end) as M3,
sum(case when x.order_date between '2023-05-01' and '2023-05-31' then Customers end) as M4,
sum(case when x.order_date between '2023-06-01' and '2023-06-31' then Customers end) as M5,
sum(case when x.order_date between '2023-07-01' and '2023-07-31' then Customers end) as M6,
sum(case when x.order_date between '2023-08-01' and '2023-08-31' then Customers end) as M7,
sum(case when x.order_date between '2023-09-01' and '2023-09-31' then Customers end) as M8,
sum(case when x.order_date between '2023-10-01' and '2023-10-31' then Customers end) as M9,
sum(case when x.order_date between '2023-11-01' and '2023-11-31' then Customers end) as M10,
sum(case when x.order_date between '2023-12-01' and '2023-12-31' then Customers end) as M11

from
(select
x.order_date,
y.category,
count(distinct x.customer_id) as customers
from order_details_v1 x
join producthierarchy y on x.product_id = y.product_id
group by 1,2
)x;

--	----------------------------------------------------------------------------------------------------------
Select
monthname("2023-03-31") as month,
sum(case when x.order_date between '2023-01-01' and '2023-12-31' then Customers end) as Total_customer,
coalesce(sum(case when (order_date=current_date()-interval 1 day) then customers end),0) as new_customers,
sum(case when x.order_date between '2023-03-01' and '2023-03-31' then Customers end) as M1,
sum(case when x.order_date between '2023-04-01' and '2023-04-31' then Customers end) as M2,
sum(case when x.order_date between '2023-05-01' and '2023-05-31' then Customers end) as M3,
sum(case when x.order_date between '2023-06-01' and '2023-06-31' then Customers end) as M4,
sum(case when x.order_date between '2023-07-01' and '2023-07-31' then Customers end) as M5,
sum(case when x.order_date between '2023-08-01' and '2023-08-31' then Customers end) as M6,
sum(case when x.order_date between '2023-09-01' and '2023-09-31' then Customers end) as M7,
sum(case when x.order_date between '2023-10-01' and '2023-10-31' then Customers end) as M8,
sum(case when x.order_date between '2023-11-01' and '2023-11-31' then Customers end) as M9,
sum(case when x.order_date between '2023-12-01' and '2023-12-31' then Customers end) as M10

from
(select
x.order_date,
y.category,
count(distinct x.customer_id) as customers
from order_details_v1 x
join producthierarchy y on x.product_id = y.product_id
group by 1,2
)x;

--	Table 12: This table presents the New Customers Category Level Retention %:
select 
category,
monthname("2023-01-31") as month,
sum(case when x.order_date between '2023-01-01' and '2023-12-31' then Customers end) as Total_customer,
coalesce(sum(case when (order_date=current_date()-interval 1 day) then customers end),0) as new_customers,
sum(case when x.order_date between '2023-01-01' and '2023-01-31' then Customers end) as M1,
sum(case when x.order_date between '2023-02-01' and '2023-02-28' then Customers end) as M2,
sum(case when x.order_date between '2023-03-01' and '2023-03-31' then Customers end) as M3,
sum(case when x.order_date between '2023-04-01' and '2023-04-31' then Customers end) as M4,
sum(case when x.order_date between '2023-05-01' and '2023-05-31' then Customers end) as M5,
sum(case when x.order_date between '2023-06-01' and '2023-06-31' then Customers end) as M6,
sum(case when x.order_date between '2023-07-01' and '2023-07-31' then Customers end) as M7,
sum(case when x.order_date between '2023-08-01' and '2023-08-31' then Customers end) as M8,
sum(case when x.order_date between '2023-09-01' and '2023-09-31' then Customers end) as M9,
sum(case when x.order_date between '2023-10-01' and '2023-10-31' then Customers end) as M10,
sum(case when x.order_date between '2023-11-01' and '2023-11-31' then Customers end) as M11,
sum(case when x.order_date between '2023-12-01' and '2023-12-31' then Customers end) as M12

from
(select
x.order_date,
y.category,
count(distinct x.customer_id) as customers
from order_details_v1 x
join producthierarchy y on x.product_id = y.product_id
group by 1,2
)x
group by 1
limit 5;

--	-------------------------------------------------------------------------------------------------------------------------
Select
category,
monthname("2023-02-28") as month,
sum(case when x.order_date between '2023-01-01' and '2023-12-31' then Customers end) as Total_customer,
coalesce(sum(case when (order_date=current_date()-interval 1 day) then customers end),0) as new_customers,
sum(case when x.order_date between '2023-02-01' and '2023-02-28' then Customers end) as M1,
sum(case when x.order_date between '2023-03-01' and '2023-03-31' then Customers end) as M2,
sum(case when x.order_date between '2023-04-01' and '2023-04-31' then Customers end) as M3,
sum(case when x.order_date between '2023-05-01' and '2023-05-31' then Customers end) as M4,
sum(case when x.order_date between '2023-06-01' and '2023-06-31' then Customers end) as M5,
sum(case when x.order_date between '2023-07-01' and '2023-07-31' then Customers end) as M6,
sum(case when x.order_date between '2023-08-01' and '2023-08-31' then Customers end) as M7,
sum(case when x.order_date between '2023-09-01' and '2023-09-31' then Customers end) as M8,
sum(case when x.order_date between '2023-10-01' and '2023-10-31' then Customers end) as M9,
sum(case when x.order_date between '2023-11-01' and '2023-11-31' then Customers end) as M10,
sum(case when x.order_date between '2023-12-01' and '2023-12-31' then Customers end) as M11

from
(select
x.order_date,
y.category,
count(distinct x.customer_id) as customers
from order_details_v1 x
join producthierarchy y on x.product_id = y.product_id
group by 1,2
)x
group by 1
limit 5;
--	----------------------------------------------------------------------------------------------------------
Select
category,
monthname("2023-03-31") as month,
sum(case when x.order_date between '2023-01-01' and '2023-12-31' then Customers end) as Total_customer,
coalesce(sum(case when (order_date=current_date()-interval 1 day) then customers end),0) as new_customers,
sum(case when x.order_date between '2023-03-01' and '2023-03-31' then Customers end) as M1,
sum(case when x.order_date between '2023-04-01' and '2023-04-31' then Customers end) as M2,
sum(case when x.order_date between '2023-05-01' and '2023-05-31' then Customers end) as M3,
sum(case when x.order_date between '2023-06-01' and '2023-06-31' then Customers end) as M4,
sum(case when x.order_date between '2023-07-01' and '2023-07-31' then Customers end) as M5,
sum(case when x.order_date between '2023-08-01' and '2023-08-31' then Customers end) as M6,
sum(case when x.order_date between '2023-09-01' and '2023-09-31' then Customers end) as M7,
sum(case when x.order_date between '2023-10-01' and '2023-10-31' then Customers end) as M8,
sum(case when x.order_date between '2023-11-01' and '2023-11-31' then Customers end) as M9,
sum(case when x.order_date between '2023-12-01' and '2023-12-31' then Customers end) as M10

from
(select
x.order_date,
y.category,
count(distinct x.customer_id) as customers
from order_details_v1 x
join producthierarchy y on x.product_id = y.product_id
group by 1,2
)x
group by 1
limit 5;
