--task 1
with revenue as (
	select 
	date_part('year', o.shipping_limit_date) as year,
	sum (price+freight_value) as revenue
	from order_items_dataset as o
	join orders_dataset s on o.order_id=s.order_id
	where s.order_status = 'delivered'
	group by (1)
),
-- task 2
cancel as (
	select *
	from orders_dataset
	where order_status = 'canceled'
),
jumlah_cancel as(
	select
		date_part ('year', order_purchase_timestamp) as year,
		count (order_status) as jumlah_cancel
	from cancel s
	group by (1)
),

--task 3
group_by_tahun as (
	select
	date_part ('year', order_purchase_timestamp) as year,
	product_category_name as product_revenue_rangking,
	sum (price+freight_value) as sum_revenue_category
	from order_items_dataset o
	join orders_dataset d on o.order_id=d.order_id
	join product_dataset p on o.product_id=p.product_id
	group by (1,2)
),
nambelas as (
	select * 
	from group_by_tahun
	where year =2016
	order by sum_revenue_category DESC
	LIMIT 1
),
juhbelas as (
	select * 
	from group_by_tahun
	where year = 2017
	order by sum_revenue_category DESC
	LIMIT 1
),
depanbelas as (
	select * 
	from group_by_tahun
	where year = 2018
	order by sum_revenue_category DESC
	LIMIT 1
),
sembilanbelas as (
	select * 
	from group_by_tahun
	where year = 2019
	order by sum_revenue_category DESC
	LIMIT 1
),
duapuluh as (
	select * 
	from group_by_tahun
	where year = 2020
	order by sum_revenue_category DESC
	LIMIT 1
),
category as (
	SELECT * FROM nambelas
	UNION ALL
	SELECT * FROM juhbelas
	UNION ALL
	SELECT * FROM depanbelas
),
--task 4
cancel_tahun as (
	select
	date_part ('year', order_purchase_timestamp) as year,
	product_category_name as product_cancel_rangking,
	count ('order_status') as count_category_canceled
	from order_items_dataset o
	join orders_dataset d on o.order_id=d.order_id
	join product_dataset p on o.product_id=p.product_id
	where order_status = 'canceled'
	group by (1,2)
	order by count_category_canceled desc
),
cancel_nambelas as (
	select * 
	from cancel_tahun
	where year =2016
	order by count_category_canceled DESC
	LIMIT 1
),
cancel_juhbelas as (
	select * 
	from cancel_tahun
	where year = 2017
	order by count_category_canceled DESC
	LIMIT 1
),
cancel_depanbelas as (
	select * 
	from cancel_tahun
	where year = 2018
	order by count_category_canceled DESC
	LIMIT 1
),
cancel_sembilanbelas as (
	select * 
	from cancel_tahun
	where year = 2019
	order by count_category_canceled DESC
	LIMIT 1
),
cancel_duapuluh as (
	select * 
	from cancel_tahun
	where year = 2020
	order by count_category_canceled DESC
	LIMIT 1
),
canceled as (
	SELECT
	*
	FROM cancel_nambelas
	UNION ALL
	SELECT
	*
	FROM cancel_juhbelas
	UNION ALL
	SELECT
	*
	FROM cancel_depanbelas
)

-- task 5
select 
r.year,
revenue,
product_revenue_rangking,
sum_revenue_category,
jumlah_cancel,
product_cancel_rangking,
count_category_canceled
from revenue r
join jumlah_cancel as jc on r.year = jc.year
join category as c on r.year = c.year
join canceled as cd on r.year = cd.year