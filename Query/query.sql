/*Menampilkan jumlah penggunaan masing-masing tipe pembayaran secara all time diurutkan dari yang terfavorit*/
select 
	payment_type,
	sum(payment_sequential) as total_type_payment 
from orders_dataset as od
inner join order_payments_dataset as opd on od.order_id = opd.order_id
group by 1
order by total_type_payment desc;

/*Menampilkan detail informasi jumlah penggunaan masing-masing tipe pembayaran untuk setiap tahun*/

SELECT
  year,
  SUM(CASE WHEN payment_type = 'credit_card' THEN total_type_payment ELSE 0 END) AS credit_card,
  SUM(CASE WHEN payment_type = 'boleto' THEN total_type_payment ELSE 0 END) AS boleto,
  SUM(CASE WHEN payment_type = 'voucher' THEN total_type_payment ELSE 0 END) AS voucher,
  SUM(CASE WHEN payment_type = 'debit_card' THEN total_type_payment ELSE 0 END) AS debit_card,
  SUM(CASE WHEN payment_type = 'not_defined' THEN total_type_payment ELSE 0 END) AS not_defined
FROM
(
select 
	date_part('year', order_purchase_timestamp)as year,
	payment_type,
	sum(payment_sequential) as total_type_payment 
from orders_dataset as od
inner join order_payments_dataset as opd on od.order_id = opd.order_id
group by 1,2
order by year, total_type_payment desc
)as tmp
GROUP BY year
ORDER BY year;