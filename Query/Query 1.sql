--task 1
with cte as (
	select
	date_part('year', order_purchase_timestamp) as year,
	date_part('month', order_purchase_timestamp) as month,
	count (distinct c) as jumlah_customer_id
	from orders_dataset o
	join customers_dataset c on o.customer_id = c.customer_id
	group by (1,2)
),
avg_customer_year as (
	select year, 
	avg (jumlah_customer_id) as rata_rata_tahunan
from cte
group by (1)
),
--task 2
first_transaction_user as (
select
	c.customers_uniqie_id,
	min (order_purchase_timestamp) as first_purchase_time
	from orders_dataset o
	join customers_dataset c on o.customer_id = c.customer_id
	group by (1)
),
new_customer_per_year as (
	select 
	date_part('year', first_purchase_time) as year,
	count(1) as new_customer_per_year
	from first_transaction_user
	group by 1
),
--task3
count_customer_repeat as (
	select 
	date_part ('year', order_purchase_timestamp) as year,
	c.customers_uniqie_id, count (1) as count_order
	from orders_dataset o
	join customers_dataset c on o.customer_id=c.customer_id
	group by (1,2)
),
customer_repeat_2 as (
	select *
	from count_customer_repeat
	where count_order > 1
),
count_repeat_customer as (
	select year, count (customers_uniqie_id) as count_repeat_customer
	from customer_repeat_2
	group by (1)
),
-- task4
total_order_customer as (
	select date_part ('year', order_purchase_timestamp) as year,
			customers_uniqie_id,
			count(order_id) as total_order
	from orders_dataset o
	join customers_dataset c on o.customer_id=c.customer_id
	group by (1,2)
),
avg_order as (
	select year, avg (total_order) as avg_order
	from total_order_customer
	group by (1)
)
-- task 5
select 
	avg_order.year,
	rata_rata_tahunan,
	new_customer_per_year,
	count_repeat_customer,
	avg_order
from avg_order
join avg_customer_year on avg_order.year = avg_customer_year.year
join new_customer_per_year on avg_order.year = new_customer_per_year.year
join count_repeat_customer on avg_order.year = count_repeat_customer.year